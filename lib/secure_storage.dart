
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final storage = const FlutterSecureStorage();
  Future read(String key) async {
    return await storage.read(key: key);
  }

  Future write(String key, String value) async {
    return await storage.write(key: key, value: value);
  }

  Future delete(String key) async {
    await storage.delete(key: key);
  }
}
