// lib/utils/orientation_helper.dart
import 'package:flutter/services.dart';

class OrientationHelper {
  static void lockLandscape() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  static void unlockOrientation() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }
}
