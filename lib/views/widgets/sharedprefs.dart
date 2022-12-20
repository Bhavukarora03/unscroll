import 'package:shared_preferences/shared_preferences.dart';

class TextPreferences {

  static const String _text = 'text';


  static Future<void> setTime(int text) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_text, text);
  }

  static Future<int> getTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_text) ?? 0;
  }

  static Future<void> removeTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_text);
  }

  static Future<void> setTheme(bool theme) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('theme', theme);
  }
}

