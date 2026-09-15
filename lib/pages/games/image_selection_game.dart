// lib/games/image_selection_game.dart
import 'package:flutter/material.dart';
import 'base_game.dart';

class ImageSelectionGame extends BaseGameWidget {
  const ImageSelectionGame({super.key, required level, required onComplete}) : super(level: level, onComplete: onComplete);

  @override
  State<ImageSelectionGame> createState() => _ImageSelectionGameState();
}

class _ImageSelectionGameState extends BaseGameState<ImageSelectionGame> {
  @override
  Widget build(BuildContext context) {
    final options = List<String>.from(cfg['options'] ?? []);
    final correct = cfg['correctIndex'] ?? 0;

    return Column(
      children: [
        const SizedBox(height: 12),
        const Text('Selecciona la imagen correcta'),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(12),
            children: List.generate(options.length, (i) {
              return GestureDetector(
                onTap: () {
                  finish(success: i == correct);
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(options[i], fit: BoxFit.contain),
                  ),
                ),
              );
            }),
          ),
        )
      ],
    );
  }
}
