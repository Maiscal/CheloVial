import 'package:flutter/material.dart';

import 'pages/autentificacion/login.dart';

void main() => runApp(const CheloVialApp());

class CheloVialApp extends StatelessWidget {
  const CheloVialApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'CheloVial',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1687B8),
        primary: const Color(0xFF1687B8),
        secondary: const Color(0xFFFFA64D),
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: Theme.of(context).textTheme.apply(fontFamily: 'sans-serif'),
    ),
    home: const LoginPage(),
  );
}
