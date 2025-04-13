import 'dart:convert';

import 'package:chayil/domain/models/categories/category.dart';
import 'package:chayil/domain/models/categories/category_list.dart';
import 'package:chayil/domain/models/ranks/rank.dart';
import 'package:chayil/domain/models/ranks/rank_list.dart';
import 'package:chayil/domain/models/techniques/technique.dart';
import 'package:chayil/domain/models/techniques/technique_list.dart';
import 'package:chayil/domain/models/techniques/techniques_by_category.dart';
import 'package:chayil/domain/models/techniques/techniques_by_rank.dart';
import 'package:chayil/domain/services/cache_service.dart';
import 'package:chayil/domain/services/network_service.dart';
import 'package:chayil/domain/services/secure_storage_service.dart';

class TechniquesRepository {
  final CacheService _cacheService;
  final NetworkService _network;
  final SecureStorageService _secureStorage;

  TechniquesRepository({
    CacheService? cacheService,
    NetworkService? networkService,
    SecureStorageService? secureStorageService,
  })  : _cacheService = cacheService ?? CacheService(),
        _network = networkService ?? NetworkService(),
        _secureStorage = secureStorageService ?? SecureStorageService();

  Future<List<Technique>> getAllTechniques() async {
    final jsonStr = await _cacheService
        .loadDecryptedJson('assets/data/techniques.json.enc');
    final jsonMap = json.decode(jsonStr);
    final techniqueList = TechniqueList.fromJson(jsonMap);
    return techniqueList.techniques;
  }

  Future<List<Category>> getAllCategories() async {
    final jsonStr = await _cacheService
        .loadDecryptedJson('assets/data/categories.json.enc');
    final jsonMap = json.decode(jsonStr);
    final categoryList = CategoryList.fromJson(jsonMap);
    return categoryList.items;
  }

  Future<List<Rank>> getAllRanks() async {
    final jsonStr =
        await _cacheService.loadDecryptedJson('assets/data/ranks.json.enc');
    final jsonMap = json.decode(jsonStr);
    final rankList = RankList.fromJson(jsonMap);
    return rankList.ranks;
  }

  Future<List<TechniquesByCategory>> getTechniquesByCategory(
      String rankId) async {
    final allCategories = await getAllCategories();
    final allTechniques = await getAllTechniques();

    final categorized = allCategories
        .map((category) {
          final matchingTechniques = allTechniques
              .where((t) => t.categoryId == category.id && t.rankId == rankId)
              .toList()
            ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

          return Category(
            id: category.id,
            name: category.name,
            sortOrder: category.sortOrder,
          )..techniques = matchingTechniques;
        })
        .where((c) => c.techniques?.isNotEmpty ?? false)
        .toList();

    final model = TechniquesByCategory(categories: categorized);
    model.sortTechniquesAlphabetically();
    return [model];
  }

  Future<List<TechniquesByRank>> getTechniquesByRank(String categoryId) async {
    final allRanks = await getAllRanks();
    final allTechniques = await getAllTechniques();

    final ranked = allRanks
        .map((rank) {
          final matchingTechniques = allTechniques
              .where((t) => t.rankId == rank.id && t.categoryId == categoryId)
              .toList()
            ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

          return Rank(
            id: rank.id,
            name: rank.name,
            imageAsset: rank.imageAsset,
            primaryColor: rank.primaryColor,
            secondaryColor: rank.secondaryColor,
            sortOrder: rank.sortOrder,
          )..techniques = matchingTechniques;
        })
        .where((r) => r.techniques?.isNotEmpty ?? false)
        .toList();

    final model = TechniquesByRank(ranks: ranked);
    model.sortTechniquesAlphabetically();
    return [model];
  }

  Future<List<String>> getTechniqueVideos(String techniqueId) async {
    final email = await _secureStorage.read('user_email');
    final deviceId = await _secureStorage.read('user_device');

    if (email == null || deviceId == null) {
      throw Exception("User credentials not found in secure storage.");
    }

    final response = await _network.get(
      'video/video.php?email=$email&device=$deviceId&techniqueId=$techniqueId',
    );

    final urls = response['urls'];
    if (urls is List) {
      return urls.cast<String>();
    } else {
      throw Exception("Invalid response format for video URLs.");
    }
  }
}
