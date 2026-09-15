import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../modulo/child_profile.dart';
import '../../widgets/section_card.dart';
import 'editPerfil.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key, required this.profile});
  final ChildProfile profile;
  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            const Spacer(),
            Text(
              'Perfil',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFFDCAA69),
              ),
            ),
            const Spacer(),
            IconButton(
              tooltip: 'Editar perfil',
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EditPerfilPage(profile: widget.profile),
                  ),
                );
                setState(() {});
              },
              icon: const Icon(Icons.edit, color: Color(0xFFDCAA69)),
            ),
          ],
        ),
        SectionCard(
          color: const Color(0xFFDCAA69),
          child: Row(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 43,
                  backgroundImage: AssetImage('assets/images/user/user${widget.profile.avatar}.png'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.profile.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${widget.profile.age} añitos',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Color(0xFFFFD21E), size: 30),
                        Text(
                          ' ${widget.profile.stars}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _Stat(
              icon: Icons.star,
              color: const Color(0xFFFFA64D),
              value: '${widget.profile.stars}',
              label: 'estrellas',
            ),
            _Stat(
              icon: Icons.flag,
              color: const Color(0xFF37A874),
              value: '${widget.profile.completedLevels}',
              label: 'niveles',
            ),
          ],
        ),
        Text(
          'Mi avance',
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Niveles completados',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: widget.profile.completedLevels / 12,
                minHeight: 12,
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFF37A874),
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.profile.completedLevels} completados · ${widget.profile.pendingLevels} pendientes',
              ),
            ],
          ),
        ),
        Text(
          'Logro más reciente',
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        SectionCard(
          color: const Color(0xFFFFF2D9),
          child: Row(
            children: [
              Text(
                achievements.first.icon,
                style: const TextStyle(fontSize: 38),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  '¡Primer paso!\nCompletaste tu primer nivel.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SectionCard(
          color: widget.profile.tutorLinked ? const Color(0xFFE3F6E7) : const Color(0xFFFFF2D9),
          child: Row(children: [
            Icon(widget.profile.tutorLinked ? Icons.verified_user_rounded : Icons.info_outline, color: const Color(0xFFDCAA69)),
            const SizedBox(width: 10),
            Expanded(child: Text(widget.profile.tutorLinked ? 'Tutor vinculado. Tu progreso se puede sincronizar.' : 'Aún no tienes un tutor vinculado.', style: const TextStyle(fontWeight: FontWeight.w600))),
          ]),
        ),
      ],
    ),
  );
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Expanded(
    child: SectionCard(
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 21),
          ),
          Text(label),
        ],
      ),
    ),
  );
}
