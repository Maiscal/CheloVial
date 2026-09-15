import 'package:flutter_tts/flutter_tts.dart';

/// Narrador local reutilizable. Las frases salen de cada pantalla y no se
/// envían a un servidor: funciona también sin conexión una vez instalada la voz.
class VoiceGuide {
  VoiceGuide._();
  static final FlutterTts _tts = FlutterTts();
  static bool _ready = false;

  static Future<void> speak(String text) async {
    if (!_ready) {
      await _tts.setLanguage('es-ES');
      await _tts.setSpeechRate(.44);
      await _tts.setPitch(1.08);
      _ready = true;
    }
    await _tts.stop();
    await _tts.speak(text);
  }

  static Future<void> stop() => _tts.stop();
}
