// lib/games/puzzle_game.dart
import 'package:flutter/material.dart';
import 'base_game.dart';
import '../models/level.dart';

class PuzzleGame extends BaseGameWidget {
  const PuzzleGame({super.key, required Level level, required onComplete}) : super(level: level, onComplete: onComplete);

  @override
  State<PuzzleGame> createState() => _PuzzleGameState();
}

class _PuzzleGameState extends BaseGameState<PuzzleGame> {
  // Implementación mínima: muestra la imagen y un botón para "completar"
  @override
  Widget build(BuildContext context) {
    final image = cfg['imageUrl'] ?? '';
    final pieces = cfg['piecesCount'] ?? 9;
    final timeLimit = cfg['timeLimit'] ?? 60;

    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (image != '')
                  Image.asset(image, width: 250, height: 250, fit: BoxFit.contain)
                else
                  const Icon(Icons.extension, size: 120),
                const SizedBox(height: 12),
                Text('Piezas: $pieces  •  Tiempo: $timeLimit s'),
                const SizedBox(height: 8),
                const Text('Plantilla de rompecabezas (implementar lógica)'),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton(
            onPressed: () => finish(success: true),
            child: const Text('Simular completar rompecabezas'),
          ),
        )
      ],
    );
  }
}
