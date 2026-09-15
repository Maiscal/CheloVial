import 'package:flutter/material.dart';

class AssetOrIcon extends StatelessWidget {
  const AssetOrIcon({
    super.key,
    required this.asset,
    required this.icon,
    this.size = 70,
    this.color,
  });
  final String asset;
  final IconData icon;
  final double size;
  final Color? color;
  @override
  Widget build(BuildContext context) => Image.asset(
    asset,
    width: size,
    height: size,
    fit: BoxFit.contain,
    errorBuilder: (_, __, ___) => Icon(
      icon,
      size: size,
      color: color ?? Theme.of(context).colorScheme.primary,
    ),
  );
}
