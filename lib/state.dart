import 'package:shared_preferences/shared_preferences.dart';

class TodaiAppState {
  static Future<bool> hasPassedIntro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('intro') == true;
  }

  static Future setPassedIntro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('intro', true);
  }
}
