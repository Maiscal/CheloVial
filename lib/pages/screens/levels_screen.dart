import 'package:flutter/material.dart';

import '../../utils/persistence.dart';
import '../../utils/voice_guide.dart';
import '../../modulo/child_profile.dart';
import '../../data/modules_data.dart';
import 'game_result_screen.dart';
import '../models/level.dart';
import 'level_play_screen.dart';

const _lime = Color(0xFF73DB00);
const _road = Color(0xFF767676);

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({
    super.key,
    required this.levels,
    required this.moduleName,
    required this.moduleSubtitle,
    required this.moduleImage,
    required this.accentColor,
    required this.profile,
  });
  final List<Level> levels;
  final String moduleName;
  final String moduleSubtitle;
  final String moduleImage;
  final Color accentColor;
  final ChildProfile profile;

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  late Future<List<bool>> _unlockedLevels;

  @override
  void initState() {
    super.initState();
    _unlockedLevels = _loadUnlockedLevels();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VoiceGuide.speak('Estás en el módulo ${widget.moduleName}. Toca el nivel de inicio para comenzar.');
    });
  }

  Future<List<bool>> _loadUnlockedLevels() => Future.wait(
        widget.levels.asMap().entries.map(
          (entry) async => entry.key == 0 ||
              !entry.value.locked ||
              await Persistence.isUnlocked(entry.value.id),
        ),
      );

  Future<void> _openLevel(Level level, bool unlocked) async {
    if (!unlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa el nivel anterior para desbloquearlo.')),
      );
      return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LevelPlayScreen(level: level, allLevels: widget.levels, accentColor: widget.accentColor)),
    );
    if (!mounted) return;
    setState(() => _unlockedLevels = _loadUnlockedLevels());
    final completed = await Future.wait(widget.levels.map((item) => Persistence.isCompleted(item.id)));
    final allLevels = modulesData.expand((module) => module.levels);
    final totalCompleted = (await Future.wait(allLevels.map((item) => Persistence.isCompleted(item.id)))).where((done) => done).length;
    widget.profile.completedLevels = totalCompleted;
    widget.profile.stars = totalCompleted;
    await Persistence.saveProfile(widget.profile);
    if (mounted && completed.every((item) => item)) _showModuleComplete(completed.length);
  }

  void _showModuleComplete(int stars) => Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => GameResultScreen(success: true, childName: widget.profile.name, stars: stars, moduleComplete: true)),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFE7F8FF),
        body: SafeArea(
          child: FutureBuilder<List<bool>>(
            future: _unlockedLevels,
            builder: (context, snapshot) {
              final unlocked = snapshot.data ??
                  List<bool>.generate(widget.levels.length, (index) => index == 0);
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _ModuleHeader(
                    total: widget.levels.length,
                    title: widget.moduleName,
                    subtitle: widget.moduleSubtitle,
                    image: widget.moduleImage,
                    color: widget.accentColor,
                  )),
                  SliverToBoxAdapter(
                    child: _LevelMap(
                      levels: widget.levels,
                      unlocked: unlocked,
                      onLevelTap: _openLevel,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
}

class _ModuleHeader extends StatelessWidget {
  const _ModuleHeader({required this.total, required this.title, required this.subtitle, required this.image, required this.color});
  final int total;
  final String title;
  final String subtitle;
  final String image;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MÓDULO: ${subtitle.toUpperCase()}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(17),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(17),
                child: Row(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(image, fit: BoxFit.cover),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 13, 8, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(subtitle, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 12),
                            Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, height: 1.1)),
                            const Spacer(),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text('★ 3 / $total', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 48),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

class _LevelMap extends StatelessWidget {
  const _LevelMap({required this.levels, required this.unlocked, required this.onLevelTap});
  final List<Level> levels;
  final List<bool> unlocked;
  final Future<void> Function(Level level, bool unlocked) onLevelTap;

  @override
  Widget build(BuildContext context) {
    // Cada nodo necesita espacio para su etiqueta y, en el inicio, el globo.
    // La altura aumenta para módulos largos en vez de apilar los niveles.
    final mapHeight = (levels.length * 155 + 180).toDouble().clamp(720.0, 1600.0).toDouble();
    return SizedBox(
      height: mapHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final points = _levelPoints(constraints.maxWidth, mapHeight, levels.length);
          return Stack(
            children: [
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFDDF5FF), Color(0xFFF5FBFF), Color(0xFFE7F0CA)],
                    ),
                  ),
                ),
              ),
              Positioned.fill(child: CustomPaint(painter: _CloudPainter())),
              Positioned.fill(child: CustomPaint(painter: _RoadPainter(points: points))),
              ...List.generate(levels.length, (index) {
                final point = points[index];
                return Positioned(
                  left: point.dx - 43,
                  top: point.dy - 43,
                  child: _LevelNode(
                    level: levels[index],
                    number: index + 1,
                    unlocked: unlocked[index],
                    isStart: index == 0,
                    onTap: () => onLevelTap(levels[index], unlocked[index]),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

List<Offset> _levelPoints(double width, double height, int count) {
  if (count == 0) return const [];
  // El recorrido conserva una curva de carretera y deja la misma distancia
  // vertical entre nodos sin importar cuántos juegos tenga un módulo.
  const xFractions = [.50, .28, .70, .32, .67, .38, .60, .30, .72, .46];
  return List.generate(count, (index) {
    final y = .89 - (index * .79 / (count - 1 == 0 ? 1 : count - 1));
    return Offset(width * xFractions[index % xFractions.length], height * y);
  });
}

class _LevelNode extends StatelessWidget {
  const _LevelNode({required this.level, required this.number, required this.unlocked, required this.isStart, required this.onTap});
  final Level level;
  final int number;
  final bool unlocked;
  final bool isStart;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = unlocked ? _lime : const Color(0xFF9B9B9B);
    return Semantics(
      button: true,
      label: '${level.name}${unlocked ? '' : ', bloqueado'}',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isStart) const _Bubble(text: 'INICIO'),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              customBorder: const CircleBorder(),
              child: Ink(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 5),
                  boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 4, offset: Offset(0, 3))],
                ),
                child: Icon(
                  unlocked ? (isStart ? Icons.play_arrow_rounded : Icons.star_rounded) : Icons.lock_rounded,
                  size: 45,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 115,
            child: Text('Nivel $number', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF4A4A4A))),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 7),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 3)],
        ),
        child: Text(text, style: const TextStyle(color: Color(0xFF62B521), fontWeight: FontWeight.w800)),
      );
}

class _RoadPainter extends CustomPainter {
  const _RoadPainter({required this.points});
  final List<Offset> points;
  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final previous = points[i - 1];
      final current = points[i];
      path.cubicTo(previous.dx, (previous.dy + current.dy) / 2, current.dx, (previous.dy + current.dy) / 2, current.dx, current.dy);
    }
    canvas.drawPath(path, Paint()..color = _road..style = PaintingStyle.stroke..strokeWidth = 105..strokeCap = StrokeCap.round);
    _paintDashedPath(canvas, path);
  }

  void _paintDashedPath(Canvas canvas, Path path) {
    final paint = Paint()..color = Colors.white..strokeWidth = 6..strokeCap = StrokeCap.round;
    for (final metric in path.computeMetrics()) {
      for (double distance = 16; distance < metric.length; distance += 45) {
        canvas.drawPath(
          metric.extractPath(distance, (distance + 22).clamp(0, metric.length).toDouble()),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RoadPainter oldDelegate) => oldDelegate.points != points;
}

class _CloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(.62);
    for (final cloud in [Offset(size.width * .12, 90), Offset(size.width * .83, 215), Offset(size.width * .15, 430), Offset(size.width * .84, 585)]) {
      canvas.drawCircle(cloud, 25, paint);
      canvas.drawCircle(cloud + const Offset(25, -8), 32, paint);
      canvas.drawCircle(cloud + const Offset(53, 4), 22, paint);
    }
  }
  @override
  bool shouldRepaint(covariant _CloudPainter oldDelegate) => false;
}
