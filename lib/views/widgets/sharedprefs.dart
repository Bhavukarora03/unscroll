import 'package:shared_preferences/shared_preferences.dart';

class TextPreferences {
  static SharedPreferences? _prefs;
  static const String _text = 'text';

  static Future init() async => _prefs = await SharedPreferences.getInstance();




  static Future<void> setTime(int text) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_text, text);
  }
}

