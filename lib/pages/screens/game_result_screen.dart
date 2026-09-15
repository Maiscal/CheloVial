import 'package:flutter/material.dart';

import '../../utils/voice_guide.dart';

class GameResultScreen extends StatefulWidget {
  const GameResultScreen({super.key, required this.success, this.childName = '', this.stars = 0, this.moduleComplete = false});
  final bool success;
  final String childName;
  final int stars;
  final bool moduleComplete;

  @override
  State<GameResultScreen> createState() => _GameResultScreenState();
}

class _GameResultScreenState extends State<GameResultScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => VoiceGuide.speak(
      widget.success ? '¡Bien hecho, ${widget.childName}! Completaste el módulo y ganaste ${widget.stars} estrellas.' : 'Ups. Esa no era la respuesta. Puedes volver a intentarlo.',
    ));
  }

  @override
  Widget build(BuildContext context) {
    final success = widget.success;
    return Scaffold(
      body: SafeArea(
        child: Stack(fit: StackFit.expand, children: [
          Image.asset('assets/paisaje.jpg', fit: BoxFit.cover),
          ColoredBox(color: const Color(0xFFBFEAFF).withOpacity(.52)),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 26),
            child: Column(children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(success ? 'Bien hecho\n${widget.childName}' : 'Ups', style: const TextStyle(fontSize: 42, height: 1.05, color: Color(0xFF11A9EF), fontWeight: FontWeight.w900, shadows: [Shadow(color: Colors.white, blurRadius: 2)])),
              ),
              if (!success) const Text('Esa no era la respuesta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF26364B))),
              const Spacer(),
              Image.asset(success ? 'assets/images/chelovial/cheloLike.png' : 'assets/images/chelovial/cheloTriste.png', height: 255, fit: BoxFit.contain),
              const SizedBox(height: 8),
              if (success) Text(List.filled(widget.stars, '★').join('  '), style: const TextStyle(color: Color(0xFFFFC400), fontSize: 42)),
              Text(success ? 'Ganaste ${widget.stars} estrellas' : 'Puedes volver a intentarlo,\n¡ÁNIMO!', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, height: 1.15, fontWeight: FontWeight.w800, color: Color(0xFF26364B))),
              const Spacer(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _ResultButton(icon: Icons.home_rounded, color: success ? const Color(0xFF21B8F1) : const Color(0xFFFF5252), onTap: () => Navigator.of(context).pop(false)),
                _ResultButton(icon: success ? Icons.play_arrow_rounded : Icons.restart_alt, color: const Color(0xFF76D900), onTap: () => Navigator.of(context).pop(true)),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _ResultButton extends StatelessWidget {
  const _ResultButton({required this.icon, required this.color, required this.onTap});
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 84, height: 64,
    child: FilledButton(onPressed: onTap, style: FilledButton.styleFrom(backgroundColor: color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: Icon(icon, size: 42, color: Colors.white)),
  );
}
