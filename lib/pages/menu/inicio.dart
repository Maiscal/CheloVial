import 'package:flutter/material.dart';

import '../../modulo/child_profile.dart';
import '../../data/modules_data.dart';
import '../../utils/voice_guide.dart';
//import '../models/modulo_placeholder.dart';
import '../screens/home_screen.dart';
import 'ranking.dart';

const _green = Color(0xFF56D400);
const _blue = Color(0xFF24AEEB);

class InicioPage extends StatefulWidget {
  const InicioPage({super.key, required this.profile});
  final ChildProfile profile;

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VoiceGuide.speak('Hola ${widget.profile.name}. Soy Chelo y voy a acompañarte a aprender seguridad vial.');
    });
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        _GreetingCard(profile: widget.profile),
        const SizedBox(height: 14),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _ModuleCard(
          number: 1,
          title: 'Caminando\npor mi ciudad',
          stars: '3/5',
          color: _green,
          image: 'assets/modulo1.jpg',
          enabled: true,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen(module: modulesData[0], color: _green, profile: widget.profile)),
            //MaterialPageRoute(builder: (_) => const ModuloPlaceholderPage()),
          ),
        )),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _ModuleCard(
          number: 2,
          title: 'Aprendiendo\nlas señales',
          stars: '0/5',
          color: const Color(0xFFFF6970),
          image: 'assets/modulo2.png',
          enabled: true,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen(module: modulesData[1], color: const Color(0xFFFF5252), profile: widget.profile)),
          ),
        )),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _ModuleCard(
          number: 3,
          title: '¿Qué harías tú?\nDecisiones seguras',
          stars: '0/5',
          color: const Color(0xFFFFA11A),
          image: 'assets/modulo3.png',
          enabled: true,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen(module: modulesData[2], color: const Color(0xFFFFC400), profile: widget.profile)),
          ),
        )),
        const SizedBox(height: 6),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: _blue,
            side: const BorderSide(color: Color(0xFF8D8D8D)),
            shape: const StadiumBorder(),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RankingPage(profile: widget.profile)),
          ),
          icon: const Icon(Icons.leaderboard),
          label: const Text('Ver clasificación'),
        )),
      ],
    ),
  );
}

class _GreetingCard extends StatelessWidget {
  const _GreetingCard({required this.profile});
  final ChildProfile profile;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(18),
    child: SizedBox(
      height: 250,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/paisaje.jpg', fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.withOpacity(.45), Colors.transparent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hola ${profile.name}',
                  style: const TextStyle(
                    fontSize: 31,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(
                        color: Color(0xFF1265B9),
                        blurRadius: 2,
                        offset: Offset(1, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 55),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 37,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 31,
                        backgroundImage: AssetImage(
                          'assets/images/user/user1.png',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Vamos aprender juntos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        shadows: [Shadow(color: Colors.black54, blurRadius: 3)],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            bottom: 0,
            child: Image.asset(
              'assets/images/chelovial/cheloSaludo.png',
              height: 160,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    ),
  );
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.number,
    required this.title,
    required this.stars,
    required this.color,
    required this.image,
    required this.enabled,
    this.onTap,
  });
  final int number;
  final String title;
  final String stars;
  final Color color;
  final String image;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Opacity(
    opacity: enabled ? 1 : .55,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(15),
        elevation: 3,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(15),
          child: SizedBox(
            height: 72,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      '$number',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          height: 1.05,
                        ),
                      ),
                      Text(
                        '★ $stars',
                        style: const TextStyle(
                          color: Color(0xFFFFDE19),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(15),
                  ),
                  child: Image.asset(
                    image,
                    width: 120,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    enabled ? Icons.play_circle_fill : Icons.lock,
                    color: Colors.white,
                    size: 33,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
