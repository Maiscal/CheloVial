import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../modulo/child_profile.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key, required this.profile});
  final ChildProfile profile;
  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  String _filter = 'Semanal';
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: const Text(
        'Clasificación',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      leading: const BackButton(),
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 18),
      children: [
        const Text(
          '¡Cada estrella es un gran logro!',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 15),
        SegmentedButton<String>(
          style: const ButtonStyle(visualDensity: VisualDensity.compact),
          segments: const [
            ButtonSegment(value: 'Hoy', label: Text('Hoy')),
            ButtonSegment(value: 'Semanal', label: Text('Semanal')),
            ButtonSegment(value: 'Todos', label: Text('Todos')),
          ],
          selected: {_filter},
          onSelectionChanged: (v) => setState(() => _filter = v.first),
        ),
        const SizedBox(height: 24),
        const _Podium(),
        const SizedBox(height: 15),
        for (var i = 3; i < rankingUsers.length; i++)
          _RankRow(position: i + 1, user: rankingUsers[i]),
      ],
    ),
  );
}

class _Podium extends StatelessWidget {
  const _Podium();
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 225,
    child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        _podium(0, 1, 'Sofía', '🦊', const Color(0xFF55D600), 104),
        _podium(-115, 2, 'Mateo', '🐼', const Color(0xFF24AEEB), 78),
        _podium(115, 3, 'Valentina', '🐰', const Color(0xFFFF9800), 58),
      ],
    ),
  );
  Widget _podium(
    double x,
    int place,
    String name,
    String icon,
    Color color,
    double height,
  ) => Positioned(
    bottom: 0,
    left: 150 + x,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(icon, style: const TextStyle(fontSize: 48)),
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        Container(
          width: 72,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
          ),
          child: Text(
            '$place',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 45,
            ),
          ),
        ),
      ],
    ),
  );
}

class _RankRow extends StatelessWidget {
  const _RankRow({required this.position, required this.user});
  final int position;
  final Map<String, Object> user;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: user['name'] == 'Tú' ? const Color(0xFFDDF5E8) : Colors.white,
      borderRadius: BorderRadius.circular(23),
      boxShadow: const [
        BoxShadow(
          color: Color(0x19000000),
          blurRadius: 3,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        Text('$position°', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 17),
        Text(user['avatar']! as String, style: const TextStyle(fontSize: 30)),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            user['name']! as String,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        const Icon(Icons.star, color: Color(0xFFFFA11A)),
        Text(
          ' ${user['stars']}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
