// lib/models/module.dart
import 'level.dart';

class Module {
  final String id;
  final String name;
  final String description;
  final String iconAsset;
  final List<Level> levels;

  Module({
    required this.id,
    required this.name,
    this.description = '',
    this.iconAsset = '',
    this.levels = const [],
  });

  factory Module.fromJson(Map<String, dynamic> json) => Module(
        id: json['id'],
        name: json['name'],
        description: json['description'] ?? '',
        iconAsset: json['iconAsset'] ?? '',
        levels: (json['levels'] as List<dynamic>? ?? [])
            .map((e) => Level.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'iconAsset': iconAsset,
        'levels': levels.map((l) => l.toJson()).toList(),
      };
}
