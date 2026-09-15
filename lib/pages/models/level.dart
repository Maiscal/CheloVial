// lib/models/level.dart
import 'game_config.dart';

enum GameType { puzzle, quiz, pairs, colorSequence, imageSelection, simulator }

class Level {
  final String id;
  final String name;
  final GameType type;
  final Map<String, dynamic> config;
  final String assetPreview;
  final bool locked;
  final String nextLevelId;

  Level({
    required this.id,
    required this.name,
    required this.type,
    this.config = const {},
    this.assetPreview = '',
    this.locked = true,
    this.nextLevelId = '',
  });

  factory Level.fromJson(Map<String, dynamic> json) => Level(
        id: json['id'],
        name: json['name'],
        type: Level.gameTypeFromString(json['type'] ?? 'puzzle'),
        config: Map<String, dynamic>.from(json['config'] ?? {}),
        assetPreview: json['assetPreview'] ?? '',
        locked: json['locked'] ?? true,
        nextLevelId: json['nextLevelId'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.toString().split('.').last,
        'config': config,
        'assetPreview': assetPreview,
        'locked': locked,
        'nextLevelId': nextLevelId,
      };

  static GameType gameTypeFromString(String s) {
    switch (s) {
      case 'puzzle':
        return GameType.puzzle;
      case 'quiz':
        return GameType.quiz;
      case 'pairs':
        return GameType.pairs;
      case 'colorSequence':
        return GameType.colorSequence;
      case 'imageSelection':
        return GameType.imageSelection;
      case 'simulator':
        return GameType.simulator;
      default:
        return GameType.puzzle;
    }
  }
}
