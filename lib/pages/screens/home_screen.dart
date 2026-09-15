// lib/screens/home_screen.dart
import 'package:flutter/material.dart';

import '../models/module.dart';
import '../../modulo/child_profile.dart';
import 'levels_screen.dart';

/// Entrada del módulo. El mapa se abre directamente, sin un menú intermedio.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.module, required this.color, required this.profile});

  final Module module;
  final Color color;
  final ChildProfile profile;

  @override
  Widget build(BuildContext context) => LevelsScreen(
        levels: module.levels,
        moduleName: module.name,
        moduleSubtitle: module.description,
        moduleImage: module.iconAsset,
        accentColor: color,
        profile: profile,
      );
}
