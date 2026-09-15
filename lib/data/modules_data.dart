import '../pages/models/level.dart';
import '../pages/models/module.dart';

/// Catálogo declarativo: agrega niveles cambiando datos, no creando pantallas.
final List<Module> modulesData = [
  Module(id: 'caminar', name: 'Caminando por mi ciudad', description: 'Reconocer entorno', iconAsset: 'assets/modulo1.jpg', levels: _moduleOne()),
  Module(id: 'senales', name: 'Aprendiendo las señales', description: 'Reconocer señales', iconAsset: 'assets/modulo2.png', levels: _moduleTwo()),
  Module(id: 'decisiones', name: '¿Qué harías tú?', description: 'Decisiones seguras', iconAsset: 'assets/modulo3.png', levels: _moduleThree()),
];

List<Level> _moduleOne() => [
  _level('m1_1', 'Las aceras', 'puzzle', next: 'm1_2', config: {'imageUrl': 'assets/modulo1.jpg', 'piecesCount': 9, 'timeLimit': 80}),
  _level('m1_2', 'El cruce peatonal', 'quiz', next: 'm1_3', config: _question('¿El cruce peatonal es el lugar seguro para cruzar?', ['Verdadero', 'Falso'], 0)),
  _level('m1_3', 'Medios de transporte', 'pairs', next: 'm1_4', config: _pairs),
  _level('m1_4', 'Cruce con semáforo', 'colorSequence', next: 'm1_5', config: _sequence(['#E53935', '#FBC02D', '#76D900'], 3)),
  _level('m1_5', 'Vías públicas', 'imageSelection', config: _imageChoice),
];

List<Level> _moduleTwo() => [
  _level('m2_1', 'Agente de tránsito', 'quiz', next: 'm2_2', config: _question('¿Qué indica el agente cuando levanta la mano?', ['Detenerse', 'Seguir', 'Girar'], 0)),
  _level('m2_2', 'Semáforo', 'colorSequence', next: 'm2_3', config: _sequence(['#F44336', '#FFC107', '#76D900'], 3)),
  _level('m2_3', 'Semáforo peatonal', 'colorSequence', next: 'm2_4', config: _sequence(['#F44336', '#76D900'], 3)),
  _level('m2_4', 'Reconocer la señal', 'quiz', next: 'm2_5', config: _question('La señal PARE significa…', ['Detenerse', 'Seguir', 'Girar a la derecha'], 0)),
  _level('m2_5', 'Señales nuevas', 'quiz', next: 'm2_6', config: _question('Una señal preventiva sirve para…', ['Advertir un peligro', 'Acelerar', 'Estacionar'], 0)),
  _level('m2_6', 'Señales ciclista', 'quiz', next: 'm2_7', config: _question('El ciclista debe circular por…', ['La ciclovía', 'La vereda', 'El parque'], 0)),
  _level('m2_7', 'Señales preventivas', 'pairs', config: _pairs),
];

List<Level> _moduleThree() => [
  _level('m3_1', 'Peatón responsable', 'colorSequence', next: 'm3_2', config: _sequence(['#F44336', '#FFC107', '#76D900'], 3)),
  _level('m3_2', '¿Qué significa esta señal?', 'quiz', next: 'm3_3', config: _question('La señal PARE indica…', ['Detenerse', 'Seguir', 'Girar'], 0)),
  _level('m3_3', 'Cruza con seguridad', 'simulator', next: 'm3_4', config: {'simulatorType': 'pedestrian', 'orientation': 'landscape', 'speed': 170}),
  _level('m3_4', 'Conduce con cuidado', 'simulator', next: 'm3_5', config: {'simulatorType': 'vehicle', 'orientation': 'landscape', 'speed': 190}),
  _level('m3_5', 'Cinturón de seguridad', 'imageSelection', config: _imageChoice),
];

Level _level(String id, String name, String type, {String next = '', Map<String, dynamic> config = const {}}) => Level(
  id: id, name: name, type: Level.gameTypeFromString(type), config: config,
  locked: id != 'm1_1' && id != 'm2_1' && id != 'm3_1', nextLevelId: next,
);

Map<String, dynamic> _question(String text, List<String> options, int correct) => {'questions': [{'text': text, 'options': options, 'correctIndex': correct}]};
Map<String, dynamic> _sequence(List<String> colors, int rounds) => {'colors': colors, 'initialLength': 2, 'roundsToWin': rounds};
final _pairs = {'icons': ['assets/images/chelovial/cheloLike.png', 'assets/images/chelovial/cheloSaludo.png', 'assets/images/chelovial/cheloLike.png', 'assets/images/chelovial/cheloSaludo.png']};
final _imageChoice = {'options': ['assets/modulo1.jpg', 'assets/modulo2.png', 'assets/modulo3.png'], 'correctIndex': 1};
