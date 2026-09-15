import 'package:flutter/material.dart';

import '../../modulo/child_profile.dart';
import '../../utils/persistence.dart';

class EditPerfilPage extends StatefulWidget {
  const EditPerfilPage({super.key, required this.profile});
  final ChildProfile profile;
  @override
  State<EditPerfilPage> createState() => _EditPerfilPageState();
}

class _EditPerfilPageState extends State<EditPerfilPage> {
  late final TextEditingController _name;
  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.profile.name);
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _editAge() async {
    if (!widget.profile.tutorLinked) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('La edad solo puede cambiarse cuando un tutor esté vinculado.')));
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmación de adulto'),
        content: const Text(
          'Esta acción estará protegida por una validación de tutor cuando se conecte la app. ¿Eres un adulto responsable?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sí, continuar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final controller = TextEditingController(text: '${widget.profile.age}');
    final newAge = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Actualizar edad'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Edad'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, int.tryParse(controller.text)),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (newAge != null && newAge >= 3 && newAge <= 120) {
      setState(() => widget.profile.age = newAge);
      await Persistence.saveProfile(widget.profile);
    }
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) return;
    widget.profile.name = _name.text.trim();
    await Persistence.saveProfile(widget.profile);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Editar perfil')),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(child: CircleAvatar(radius: 62, backgroundImage: AssetImage('assets/images/user/user${widget.profile.avatar}.png'))),
          const SizedBox(height: 12),
          SizedBox(height: 62, child: ListView.separated(
            scrollDirection: Axis.horizontal, itemCount: 8, separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, index) => InkWell(
              onTap: () => setState(() => widget.profile.avatar = index + 1),
              child: CircleAvatar(radius: 26, backgroundColor: widget.profile.avatar == index + 1 ? const Color(0xFF24AEEB) : Colors.transparent, child: CircleAvatar(radius: 23, backgroundImage: AssetImage('assets/images/user/user${index + 1}.png'))),
            ),
          )),
          const Text('Puedes cambiar cómo quieres que te llamemos.', style: TextStyle(fontSize: 17)),
          const SizedBox(height: 18),
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Nombre',
              prefixIcon: Icon(Icons.face),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _save,
            child: const Text('Guardar cambios'),
          ),
          const Divider(height: 40),
          const Text(
            'Edad',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text('${widget.profile.age} años'),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _editAge,
            icon: const Icon(Icons.verified_user),
            label: const Text('Soy adulto/tutor: modificar edad'),
          ),
          const SizedBox(height: 12),
          Text(widget.profile.tutorLinked ? 'Tutor vinculado: puedes actualizar la edad.' : 'Vincula un tutor para poder cambiar la edad.', style: const TextStyle(fontSize: 12)),
        ],
      ),
    ),
  );
}
