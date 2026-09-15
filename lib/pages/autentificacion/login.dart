import 'package:flutter/material.dart';

import '../../modulo/child_profile.dart';
import '../../widgets/app_shell.dart';
import '../../utils/persistence.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _age = TextEditingController();
  int _avatar = 1;

  @override
  void dispose() {
    _name.dispose();
    _age.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (!_formKey.currentState!.validate()) return;
    final profile = ChildProfile(
      localId:
          'CV-${DateTime.now().microsecondsSinceEpoch.toRadixString(36).toUpperCase()}',
      name: _name.text.trim(),
      age: int.parse(_age.text),
      avatar: _avatar,
    );
    await Persistence.saveProfile(profile);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => AppShell(profile: profile)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(33, 15, 33, 22),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/images/user/user$_avatar.png',
                  height: 285,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (i) {
                    final index = i + 1;
                    return GestureDetector(
                      onTap: () => setState(() => _avatar = index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: EdgeInsets.all(_avatar == index ? 2 : 0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _avatar == index
                                ? const Color(0xFF24AEEB)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 17,
                          backgroundImage: AssetImage(
                            'assets/images/user/user$index.png',
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Tu nombre?',
                  style: TextStyle(fontSize: 16, color: Color(0xFF30394B)),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'Ingresa tu nombre',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Ingresa tu nombre'
                      : null,
                ),
                const SizedBox(height: 18),
                const Text(
                  'Cuantos años tienes?',
                  style: TextStyle(fontSize: 16, color: Color(0xFF30394B)),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _age,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Ingresa tus añitos',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (v) {
                    final n = int.tryParse(v ?? '');
                    return n == null || n < 3
                        ? 'Ingresa una edad válida'
                        : null;
                  },
                ),
                const SizedBox(height: 56),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF24AEEB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    minimumSize: const Size.fromHeight(48),
                  ),
                  onPressed: _continue,
                  child: const Text('Aceptar', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 34),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'Ya tienes cuenta?',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF344052),
                        ),
                      ),
                      SizedBox(height: 9),
                      Text(
                        'Presiona aquí para ingresar con tu cuenta',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF344052),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
