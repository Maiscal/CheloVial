/// Perfil local del niño. Aún no representa una cuenta web ni un tutor vinculado.
class ChildProfile {
  ChildProfile({required this.localId, required this.name, required this.age, this.avatar = 1, this.tutorLinked = false, this.linkCode});
  final String localId;
  String name;
  int age;
  int avatar;
  bool tutorLinked;
  String? linkCode;
  int stars = 0;
  int completedLevels = 0;
  int get pendingLevels => 17 - completedLevels;

  Map<String, Object?> toJson() => {'id': localId, 'name': name, 'age': age, 'avatar': avatar, 'tutorLinked': tutorLinked, 'linkCode': linkCode};
  factory ChildProfile.fromJson(Map<String, Object?> json) => ChildProfile(
    localId: json['id']! as String, name: json['name']! as String, age: json['age']! as int,
    avatar: json['avatar'] as int? ?? 1, tutorLinked: json['tutorLinked'] as bool? ?? false, linkCode: json['linkCode'] as String?,
  );
}
