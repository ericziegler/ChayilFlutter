import 'package:flutter/services.dart' show rootBundle;
import 'package:encrypt/encrypt.dart';
import 'dart:convert';

typedef FromJson<T> = T Function(Map<String, dynamic> json);

class CacheService {
  // AES key and IV (same as you used to encrypt)
  static final _key = Key.fromBase16(
      'f3b67b8dcafc62f4a0c1f8210f35d7a1c594e7a6cc179df689be79a11aa408a0');
  static final _iv = IV.fromBase16('6e3e1fcb5a2d8c73427f54a92103a4fb');
  static final _encrypter = Encrypter(AES(_key, mode: AESMode.cbc));

  // Generic loader
  Future<List<T>> loadEncryptedJsonList<T>({
    required String assetPath,
    required FromJson<T> fromJson,
  }) async {
    final encryptedBytes = await rootBundle.load(assetPath);
    final data = encryptedBytes.buffer.asUint8List();

    final decrypted = _encrypter.decrypt(Encrypted(data), iv: _iv);
    final List<dynamic> jsonList = json.decode(decrypted);
    return jsonList.map((e) => fromJson(e as Map<String, dynamic>)).toList();
  }
}
