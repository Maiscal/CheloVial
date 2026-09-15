class AchievementMock {
  const AchievementMock(this.title, this.description, this.current, this.total, this.icon);
  final String title;
  final String description;
  final int current;
  final int total;
  final String icon;
}

const achievements = <AchievementMock>[
  AchievementMock('Primer paso', 'Completa tu primer nivel', 1, 1, '👟'),
  AchievementMock('Explorador', 'Consigue 10 estrellas', 8, 10, '🧭'),
  AchievementMock('Amigo de Chelo', 'Completa 5 niveles', 3, 5, '🐢'),
  AchievementMock('Gran caminante', 'Consigue 25 estrellas', 18, 25, '⭐'),
  AchievementMock('Ciudadano seguro', 'Completa todos los retos', 3, 12, '🏅'),
];

const rankingUsers = <Map<String, Object>>[
  {'name': 'Sofía', 'stars': 35, 'avatar': '🦊'},
  {'name': 'Mateo', 'stars': 29, 'avatar': '🐼'},
  {'name': 'Valentina', 'stars': 24, 'avatar': '🐰'},
  {'name': 'Lucas', 'stars': 21, 'avatar': '🐯'},
  {'name': 'Tú', 'stars': 18, 'avatar': '🐢'},
  {'name': 'Emma', 'stars': 15, 'avatar': '🐨'},
];
