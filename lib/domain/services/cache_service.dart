import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class CacheService {
  CacheService._privateConstructor();
  static final CacheService _instance = CacheService._privateConstructor();
  factory CacheService() => _instance;

  Future<String> loadJson(String assetPath) async {
    final rawJson = await rootBundle.loadString(assetPath);
    return rawJson;
  }

  Future<Map<String, dynamic>> loadJsonAsMap(String assetPath) async {
    final rawJson = await loadJson(assetPath);
    return json.decode(rawJson);
  }

  Future<List<dynamic>> loadJsonAsList(String assetPath) async {
    final rawJson = await loadJson(assetPath);
    return json.decode(rawJson);
  }
}
