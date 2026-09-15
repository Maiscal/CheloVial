// lib/games/base_game.dart
import 'package:flutter/material.dart';
import '../models/level.dart';

abstract class BaseGameWidget extends StatefulWidget {
  final Level level;
  final void Function({required bool success}) onComplete;
  const BaseGameWidget({required this.level, required this.onComplete, Key? key}) : super(key: key);
}

abstract class BaseGameState<T extends BaseGameWidget> extends State<T> {
  late Map<String, dynamic> cfg;

  @override
  void initState() {
    super.initState();
    cfg = widget.level.config;
  }

  void finish({required bool success}) {
    widget.onComplete(success: success);
  }
}
