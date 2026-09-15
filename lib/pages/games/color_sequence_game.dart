// lib/games/color_sequence_game.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'base_game.dart';

class ColorSequenceGame extends BaseGameWidget {
  const ColorSequenceGame({super.key, required level, required onComplete}) : super(level: level, onComplete: onComplete);

  @override
  State<ColorSequenceGame> createState() => _ColorSequenceGameState();
}

class _ColorSequenceGameState extends BaseGameState<ColorSequenceGame> {
  List<Color> colors = [];
  List<int> sequence = [];
  List<int> userInput = [];
  int round = 0;
  int? flashingIndex;
  bool showing = false;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    final colorStrings = List<String>.from(cfg['colors'] ?? ['#FF0000', '#00FF00', '#0000FF']);
    colors = colorStrings.map((s) => _hexToColor(s)).toList();
    final initial = cfg['initialLength'] ?? 3;
    _nextRound(initial, notify: false);
  }

  void _nextRound(int length, {bool notify = true}) {
    sequence = List<int>.generate(length, (_) => _random.nextInt(colors.length));
    userInput = [];
    round++;
    if (notify) setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) => _showSequence());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) => Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: constraints.maxWidth.clamp(280, 520).toDouble()),
          child: Column(mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Text('Ronda $round de ${cfg['roundsToWin'] ?? 3}', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 14,
          children: List.generate(colors.length, (i) => AnimatedContainer(
            duration: const Duration(milliseconds: 130), width: 72, height: 72,
            decoration: BoxDecoration(color: colors[i], borderRadius: BorderRadius.circular(14), boxShadow: flashingIndex == i ? const [BoxShadow(color: Colors.white, blurRadius: 18, spreadRadius: 7)] : null),
          )),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: showing ? null : _showSequence,
          child: const Text('Mostrar secuencia'),
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          children: List.generate(colors.length, (i) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: colors[i]),
              onPressed: showing ? null : () => _press(i),
              child: const SizedBox(width: 40, height: 40),
            );
          }),
        ),
      ],
    ))),
    ));
  }

  Future<void> _showSequence() async {
    if (showing || !mounted) return;
    setState(() => showing = true);
    await Future.delayed(const Duration(milliseconds: 350));
    for (final index in sequence) {
      if (!mounted) return;
      setState(() => flashingIndex = index);
      await Future.delayed(const Duration(milliseconds: 550));
      if (!mounted) return;
      setState(() => flashingIndex = null);
      await Future.delayed(const Duration(milliseconds: 180));
    }
    if (mounted) setState(() => showing = false);
  }

  void _press(int index) {
    userInput.add(index);
    if (userInput.length == sequence.length) {
      final ok = _compare(sequence, userInput);
      if (ok) {
        if (round >= (cfg['roundsToWin'] ?? 3)) {
          finish(success: true);
        } else {
          _nextRound(sequence.length + 1);
        }
      } else {
        finish(success: false);
      }
    }
  }

  bool _compare(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) if (a[i] != b[i]) return false;
    return true;
  }

  Color _hexToColor(String hex) {
    final h = hex.replaceAll('#', '');
    final v = int.parse(h, radix: 16);
    if (h.length == 6) return Color(0xFF000000 | v);
    return Color(v);
  }
}
