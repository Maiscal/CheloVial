// lib/games/pairs_game.dart
import 'package:flutter/material.dart';
import 'base_game.dart';

class PairsGame extends BaseGameWidget {
  const PairsGame({super.key, required level, required onComplete}) : super(level: level, onComplete: onComplete);

  @override
  State<PairsGame> createState() => _PairsGameState();
}

class _PairsGameState extends BaseGameState<PairsGame> {
  List<String> items = [];
  List<bool> revealed = [];
  int firstIndex = -1;
  int matches = 0;

  @override
  void initState() {
    super.initState();
    items = List<String>.from(cfg['icons'] ?? []);
    items.shuffle();
    revealed = List<bool>.filled(items.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _onTap(index),
          child: Container(
            color: Colors.blueGrey[50],
            child: Center(
              child: revealed[index]
                  ? Image.asset(items[index], width: 60, height: 60)
                  : const Icon(Icons.help_outline, size: 40),
            ),
          ),
        );
      },
    );
  }

  void _onTap(int index) {
    if (revealed[index]) return;
    setState(() => revealed[index] = true);
    if (firstIndex == -1) {
      firstIndex = index;
      return;
    }
    // comparar
    if (_isPair(firstIndex, index)) {
      matches++;
      firstIndex = -1;
      if (matches * 2 == items.length) {
        finish(success: true);
      }
    } else {
      final a = firstIndex;
      Future.delayed(const Duration(milliseconds: 600), () {
        setState(() {
          revealed[a] = false;
          revealed[index] = false;
          firstIndex = -1;
        });
      });
    }
  }

  bool _isPair(int a, int b) {
    // Asumimos que pares son iguales por nombre de asset
    return items[a] == items[b];
  }
}
