import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageService {
  SecureStorageService._privateConstructor();
  static final SecureStorageService _instance =
      SecureStorageService._privateConstructor();
  factory SecureStorageService() => _instance;

  static const _storage = FlutterSecureStorage();

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }

  /// Clears secure storage on fresh install
  Future<void> initializeIfFreshInstall() async {
    final prefs = await SharedPreferences.getInstance();
    final hasRunBefore = prefs.getBool('hasRunBefore') ?? false;

    if (!hasRunBefore) {
      print("DELETING ALL");
      await _storage.deleteAll();
      await prefs.setBool('hasRunBefore', true);
    }
  }
}
