import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../modulo/child_profile.dart';

class LogrosPage extends StatefulWidget {
  const LogrosPage({super.key, required this.profile});
  final ChildProfile profile;
  @override
  State<LogrosPage> createState() => _LogrosPageState();
}

class _LogrosPageState extends State<LogrosPage> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final list = _showAll ? achievements : achievements.take(3);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
        children: [
          Container(
            height: 78,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFF56D400),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(31)),
            ),
            child: const Text(
              'Mis logros',
              style: TextStyle(
                color: Colors.white,
                fontSize: 31,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                for (final item in list) _AchievementCard(item: item),
                if (!_showAll)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF56D400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      onPressed: () => setState(() => _showAll = true),
                      child: const Text(
                        'Mostrar más logros',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.item});
  final AchievementMock item;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 17),
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: const [
        BoxShadow(
          color: Color(0x33000000),
          offset: Offset(0, 3),
          blurRadius: 3,
        ),
      ],
    ),
    child: Row(
      children: [
        Text(item.icon, style: const TextStyle(fontSize: 42)),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF0764C5),
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(item.description, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 8),
              if (item.current != item.total)
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: item.current / item.total,
                        color: const Color(0xFF56D400),
                        backgroundColor: const Color(0xFFD7D7D7),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '⭐ ${item.current} / ${item.total}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
            ],
          ),
        ),
        if (item.current == item.total)
          const Icon(Icons.check_circle, color: Color(0xFF20B66C), size: 26),
      ],
    ),
  );
}
