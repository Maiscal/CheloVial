import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../modulo/child_profile.dart';
import '../pages/menu/inicio.dart';
import '../pages/menu/logros.dart';
import '../pages/menu/perfil.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.profile});
  final ChildProfile profile;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      InicioPage(profile: widget.profile),
      LogrosPage(profile: widget.profile),
      PerfilPage(profile: widget.profile),
    ];
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 66,
        color: Colors.white,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: _selectedIndex == 0
            ? const Color(0xFF22AEEB)
            : _selectedIndex == 1
            ? const Color(0xFF55D600)
            : const Color(0xFFDCAA69),
        animationDuration: const Duration(milliseconds: 320),
        items: [
          _navItem(0, Icons.grid_view_rounded, 'Módulos'),
          _navItem(1, Icons.emoji_events_outlined, 'Logros'),
          _navItem(2, Icons.account_circle_outlined, 'Perfil'),
        ],
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final selected = _selectedIndex == index;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 29,
          color: selected ? Colors.white : const Color(0xFF858585),
        ),
        if (!selected)
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF707070), fontSize: 10),
            ),
          ),
      ],
    );
  }
}
