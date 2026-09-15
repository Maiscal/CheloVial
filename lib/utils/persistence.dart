// lib/utils/persistence.dart
// Persistencia simple. Para persistencia real añade shared_preferences en pubspec.yaml
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../modulo/child_profile.dart';

class Persistence {
  static Future<void> unlockLevel(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('unlocked_$id', true);
  }

  static Future<bool> isUnlocked(String id) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('unlocked_$id') ?? false;
  }

  static Future<void> completeLevel(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('completed_$id', true);
  }

  static Future<bool> isCompleted(String id) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('completed_$id') ?? false;
  }

  static Future<void> saveProfile(ChildProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('child_profile', jsonEncode(profile.toJson()));
  }

  static Future<ChildProfile?> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('child_profile');
    if (saved == null) return null;
    return ChildProfile.fromJson(Map<String, Object?>.from(jsonDecode(saved) as Map));
  }
}
