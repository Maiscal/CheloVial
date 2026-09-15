import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Tu perfil local')),
    body: const Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.phone_android, size: 64, color: Color(0xFF1687B8)),
          SizedBox(height: 16),
          Text(
            'Primero jugamos en este dispositivo',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          SizedBox(height: 10),
          Text(
            'Al empezar se genera un identificador único local para guardar tu progreso. Todavía no es una cuenta web ni está conectado a un tutor.',
          ),
          SizedBox(height: 16),
          Text(
            'Más adelante, un tutor podrá vincular el perfil y sincronizar los logros para continuar en otros dispositivos.',
          ),
        ],
      ),
    ),
  );
}
