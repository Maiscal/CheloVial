import 'package:flutter/material.dart';

class ModuloPlaceholderPage extends StatelessWidget {
  const ModuloPlaceholderPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Caminando por mi ciudad')),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.directions_walk,
              size: 100,
              color: Color(0xFF37A874),
            ),
            const SizedBox(height: 18),
            Text(
              '¡Muy pronto comenzaremos!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            const Text(
              'El primer módulo está habilitado como acceso visual. Los juegos llegarán después.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Volver a módulos'),
            ),
          ],
        ),
      ),
    ),
  );
}
