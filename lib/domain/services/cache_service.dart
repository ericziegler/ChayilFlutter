import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:encrypt/encrypt.dart' as encrypt;

class CacheService {
  CacheService._privateConstructor();
  static final CacheService _instance = CacheService._privateConstructor();
  factory CacheService() => _instance;

  final _key = encrypt.Key.fromBase16(
    'f3b67b8dcafc62f4a0c1f8210f35d7a1c594e7a6cc179df689be79a11aa408a0',
  );
  final _iv = encrypt.IV.fromBase16('6e3e1fcb5a2d8c73427f54a92103a4IV');

  Future<String> loadDecryptedJson(String assetPath) async {
    final encryptedData = await rootBundle.load(assetPath);
    final encryptedBytes = encryptedData.buffer.asUint8List();
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final decrypted = encrypter.decryptBytes(
      encrypt.Encrypted(encryptedBytes),
      iv: _iv,
    );
    return utf8.decode(decrypted);
  }
}
