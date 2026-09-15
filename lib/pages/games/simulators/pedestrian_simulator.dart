// lib/games/simulators/pedestrian_simulator.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../models/level.dart';
import '../base_game.dart';
import '../../../utils/orientation_helper.dart';

class PedestrianSimulator extends BaseGameWidget {
  const PedestrianSimulator({required Level level, required onComplete}) : super(level: level, onComplete: onComplete);

  @override
  State<PedestrianSimulator> createState() => _PedestrianSimulatorState();
}

class _PedestrianSimulatorState extends BaseGameState<PedestrianSimulator> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  double elapsed = 0;
  int laneIndex = 1; // posición vertical discreta
  List<_Obstacle> obstacles = [];
  final int laneCount = 3;
  final double spawnInterval = 1.2;
  double spawnTimer = 0;
  bool finished = false;

  @override
  void initState() {
    super.initState();
    // Forzar landscape si config lo pide
    if (cfg['orientation'] == 'landscape') OrientationHelper.lockLandscape();
    _ticker = createTicker(_tick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    OrientationHelper.unlockOrientation();
    super.dispose();
  }

  void _tick(Duration d) {
    if (finished) return;
    final dt = d.inMilliseconds / 1000.0 - elapsed;
    elapsed = d.inMilliseconds / 1000.0;
    spawnTimer += dt;
    if (spawnTimer >= spawnInterval) {
      spawnTimer = 0;
      _spawnObstacle();
    }
    // mover obstáculos
    for (var o in obstacles) {
      o.x += (cfg['speed'] ?? 120) * dt;
    }
    // eliminar fuera de pantalla
    obstacles.removeWhere((o) => o.x > 2000);
    // colisión simple
    for (var o in obstacles) {
      if ((o.lane == laneIndex) && (o.x > 80 && o.x < 160)) {
        // colisión
        finished = true;
        finish(success: false);
        return;
      }
    }
    if (elapsed >= (cfg['goalSeconds'] ?? 20)) {
      finished = true;
      finish(success: true);
      return;
    }
    setState(() {});
  }

  void _spawnObstacle() {
    final lane = DateTime.now().microsecond % laneCount;
    obstacles.add(_Obstacle(lane: lane, x: -100.0));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final laneHeight = size.height / laneCount;
    return Stack(
      children: [
        // fondo carretera
        Positioned.fill(child: Container(color: const Color(0xFF555B60))),
        Positioned(left: 0, right: 0, top: laneHeight - 4, child: Container(height: 8, color: Colors.white70)),
        Positioned(left: 0, right: 0, top: laneHeight * 2 - 4, child: Container(height: 8, color: Colors.white70)),
        // obstáculos
        ...obstacles.map((o) {
          return Positioned(
            left: o.x + 120,
            top: o.lane * laneHeight + laneHeight / 4,
            child: Icon(Icons.directions_car, size: laneHeight / 2, color: Colors.red),
          );
        }),
        // jugador (tortuga)
        Positioned(
          left: 100,
          top: laneIndex * laneHeight + laneHeight / 4,
          child: Column(
            children: [
              Image.asset('assets/images/chelovial/cheloCaminando.png', width: laneHeight / 2, height: laneHeight / 2),
            ],
          ),
        ),
        // controles
        Positioned(
          left: 18,
          bottom: 12,
          child: _SimulatorButton(
            icon: Icons.arrow_upward,
            onPressed: () => setState(() => laneIndex = (laneIndex - 1).clamp(0, laneCount - 1).toInt()),
          ),
        ),
        Positioned(
          right: 18,
          bottom: 12,
          child: _SimulatorButton(
            icon: Icons.arrow_downward,
            onPressed: () => setState(() => laneIndex = (laneIndex + 1).clamp(0, laneCount - 1).toInt()),
          ),
        ),
      ],
    );
  }
}

class _SimulatorButton extends StatelessWidget {
  const _SimulatorButton({required this.icon, required this.onPressed});
  final IconData icon;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    elevation: 5,
    shape: const CircleBorder(),
    child: IconButton(iconSize: 42, padding: const EdgeInsets.all(18), onPressed: onPressed, icon: Icon(icon, color: Colors.black)),
  );
}

class _Obstacle {
  int lane;
  double x;
  _Obstacle({required this.lane, required this.x});
}
