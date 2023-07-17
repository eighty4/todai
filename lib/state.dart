import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodaiAppState {
  static Future<bool> hasPassedIntro() async {
    if (kDebugMode) {
      if (!Platform.environment.containsKey('FLUTTER_TEST')) {
        return false;
      }
    }
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('intro') == true;
  }

  static Future setPassedIntro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('intro', true);
  }
}
