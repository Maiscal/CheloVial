// lib/screens/level_play_screen.dart
import 'package:flutter/material.dart';
import '../models/level.dart';
import '../games/base_game.dart';
import '../games/puzzle_game.dart';
import '../games/quiz_game.dart';
import '../games/pairs_game.dart';
import '../games/color_sequence_game.dart';
import '../games/image_selection_game.dart';
import '../games/simulators/pedestrian_simulator.dart';
import '../games/simulators/vehicle_simulator.dart';
import '../../utils/persistence.dart';
import '../../utils/voice_guide.dart';
import 'game_result_screen.dart';

class LevelPlayScreen extends StatefulWidget {
  final Level level;
  final List<Level> allLevels;
  final Color accentColor;
  const LevelPlayScreen({Key? key, required this.level, required this.allLevels, required this.accentColor}) : super(key: key);

  @override
  State<LevelPlayScreen> createState() => _LevelPlayScreenState();
}

class _LevelPlayScreenState extends State<LevelPlayScreen> {
  int _restartVersion = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => VoiceGuide.speak(_instructionFor(widget.level)));
  }

  String _instructionFor(Level level) => switch (level.type) {
        GameType.puzzle => 'Arma el rompecabezas antes de que termine el tiempo.',
        GameType.quiz => 'Lee la pregunta y toca la respuesta correcta.',
        GameType.pairs => 'Encuentra las imágenes que forman pareja.',
        GameType.colorSequence => 'Mira los colores y repite la secuencia.',
        GameType.imageSelection => 'Toca la imagen correcta.',
        GameType.simulator => 'Mueve a Chelo con los botones y evita los obstáculos.',
      };

  @override
  Widget build(BuildContext context) {
    final level = widget.level;
    Widget gameWidget;

    switch (level.type) {
      case GameType.puzzle:
        gameWidget = PuzzleGame(key: ValueKey(_restartVersion), level: level, onComplete: _onComplete);
        break;
      case GameType.quiz:
        gameWidget = QuizGame(key: ValueKey(_restartVersion), level: level, onComplete: _onComplete);
        break;
      case GameType.pairs:
        gameWidget = PairsGame(key: ValueKey(_restartVersion), level: level, onComplete: _onComplete);
        break;
      case GameType.colorSequence:
        gameWidget = ColorSequenceGame(key: ValueKey(_restartVersion), level: level, onComplete: _onComplete);
        break;
      case GameType.imageSelection:
        gameWidget = ImageSelectionGame(key: ValueKey(_restartVersion), level: level, onComplete: _onComplete);
        break;
      case GameType.simulator:
        final simType = level.config['simulatorType'] ?? 'pedestrian';
        if (simType == 'pedestrian') {
          gameWidget = PedestrianSimulator(level: level, onComplete: _onComplete);
        } else {
          gameWidget = VehicleSimulator(level: level, onComplete: _onComplete);
        }
        break;
      default:
        gameWidget = Center(child: Text('Tipo de juego no soportado'));
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(92),
        child: _GameHeader(
          current: widget.allLevels.indexWhere((item) => item.id == level.id),
          total: widget.allLevels.length,
          color: widget.accentColor,
          onSpeak: () => VoiceGuide.speak(_instructionFor(level)),
          onBack: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ColoredBox(
          color: level.id.startsWith('m1_')
              ? const Color(0xFFE8FFD9)
              : level.id.startsWith('m2_')
                  ? const Color(0xFFFFD7D7)
                  : const Color(0xFFFFF0BF),
          child: gameWidget,
        ),
      ),
    );
  }

  void _onComplete({required bool success}) async {
    if (success) {
      await Persistence.completeLevel(widget.level.id);
      // desbloquear siguiente nivel si existe
      final nextId = widget.level.nextLevelId;
      if (nextId.isNotEmpty) {
        await Persistence.unlockLevel(nextId);
      }
    }
    if (success) {
      if (mounted) Navigator.of(context).pop();
    } else {
      final retry = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => const GameResultScreen(success: false)),
      );
      if (!mounted) return;
      if (retry == true) {
      setState(() => _restartVersion++);
      } else {
        Navigator.of(context).pop();
      }
    }
  }
}

class _GameHeader extends StatelessWidget {
  const _GameHeader({required this.current, required this.total, required this.color, required this.onSpeak, required this.onBack});
  final int current;
  final int total;
  final Color color;
  final VoidCallback onSpeak;
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      child: Material(
        elevation: 5, borderRadius: BorderRadius.circular(34), color: Colors.white,
        child: Row(children: [
          IconButton(onPressed: onBack, icon: Icon(Icons.arrow_back_ios_new_rounded, color: color)),
          Expanded(child: Row(children: List.generate(total, (index) => Expanded(child: Container(
            height: 6, margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(color: index <= current ? color : const Color(0xFFAAAAAA), borderRadius: BorderRadius.circular(10)),
          ))))),
          IconButton(onPressed: onSpeak, icon: Icon(Icons.volume_up_rounded, color: color)),
        ]),
      ),
    ),
  );
}
