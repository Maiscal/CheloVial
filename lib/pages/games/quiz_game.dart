// lib/games/quiz_game.dart
import 'package:flutter/material.dart';
import 'base_game.dart';

class QuizGame extends BaseGameWidget {
  const QuizGame({super.key, required level, required onComplete}) : super(level: level, onComplete: onComplete);

  @override
  State<QuizGame> createState() => _QuizGameState();
}

class _QuizGameState extends BaseGameState<QuizGame> {
  int current = 0;
  int score = 0;

  @override
  Widget build(BuildContext context) {
    final questions = List<Map<String, dynamic>>.from(cfg['questions'] ?? []);
    if (questions.isEmpty) {
      return Center(child: Text('No hay preguntas configuradas'));
    }
    final q = questions[current];
    final options = List<String>.from(q['options'] ?? []);

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (q['image'] != null)
                  Image.asset(q['image'], height: 150, fit: BoxFit.contain),
                const SizedBox(height: 12),
                Text(q['text'] ?? '', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 12),
                ...List.generate(options.length, (i) {
                  return ListTile(
                    title: Text(options[i]),
                    onTap: () {
                      if (i == (q['correctIndex'] ?? 0)) score++;
                      if (current < questions.length - 1) {
                        setState(() => current++);
                      } else {
                        finish(success: score == questions.length);
                      }
                    },
                  );
                })
              ],
            ),
          ),
        ),
      ],
    );
  }
}
