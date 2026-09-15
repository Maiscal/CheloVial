// lib/data/levels_data.dart
import '../pages/models/level.dart';

final List<Level> levelsData = [
  Level(
    id: 'lvl_001',
    name: 'El cruce peatonal',
    type: Level.gameTypeFromString('simulator'),
    config: {
      'simulatorType': 'pedestrian',
      'orientation': 'landscape',
      'controls': ['up', 'down'],
      'laneCount': 1,
      'obstacleDirection': 'leftToRight',
      'speed': 1.2
    },
    assetPreview: 'assets/levels/crossing.png',
    locked: false,
    nextLevelId: 'lvl_002',
  ),
  Level(
    id: 'lvl_002',
    name: 'Reconociendo señales',
    type: Level.gameTypeFromString('quiz'),
    config: {
      'questions': [
        {
          'text': '¿Qué significa esta señal?',
          'options': ['Alto', 'Ceda el paso', 'Prohibido estacionar'],
          'correctIndex': 0,
          'image': 'assets/signs/stop.png'
        }
      ],
      'mode': 'multiple'
    },
    assetPreview: 'assets/levels/signs.png',
    locked: true,
    nextLevelId: 'lvl_003',
  ),
  Level(
    id: 'lvl_003',
    name: 'Rompecabezas de la tortuga',
    type: Level.gameTypeFromString('puzzle'),
    config: {
      'imageUrl': 'assets/games/turtle.png',
      'piecesCount': 9,
      'timeLimit': 90
    },
    assetPreview: 'assets/levels/puzzle.png',
    locked: true,
    nextLevelId: 'lvl_004',
  ),
  Level(
    id: 'lvl_004',
    name: 'Parejas de iconos',
    type: Level.gameTypeFromString('pairs'),
    config: {
      'icons': [
        'assets/icons/a.png',
        'assets/icons/b.png',
        'assets/icons/c.png',
        'assets/icons/a.png',
        'assets/icons/b.png',
        'assets/icons/c.png'
      ],
      'pairsCount': 3,
      'timeLimit': 60
    },
    assetPreview: 'assets/levels/pairs.png',
    locked: true,
    nextLevelId: 'lvl_005',
  ),
  Level(
    id: 'lvl_005',
    name: 'Secuencia de colores',
    type: Level.gameTypeFromString('colorSequence'),
    config: {
      'initialLength': 3,
      'colors': ['#FF0000', '#00FF00', '#0000FF', '#FFFF00'],
      'speedIncrement': 0.2
    },
    assetPreview: 'assets/levels/sequence.png',
    locked: true,
    nextLevelId: '',
  ),
];
