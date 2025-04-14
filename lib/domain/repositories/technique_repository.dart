import 'dart:convert';

import 'package:chayil/domain/models/categories/category.dart';
import 'package:chayil/domain/models/ranks/rank.dart';
import 'package:chayil/domain/models/techniques/technique.dart';
import 'package:chayil/domain/models/techniques/techniques_by_category.dart';
import 'package:chayil/domain/models/techniques/techniques_by_rank.dart';
import 'package:chayil/domain/services/cache_service.dart';
import 'package:chayil/domain/services/network_service.dart';
import 'package:chayil/domain/repositories/user_repository.dart';
import 'package:chayil/domain/models/users/user.dart';

class TechniqueRepository {
  final CacheService _cacheService;
  final NetworkService _network;
  final UserRepository _userRepository;

  TechniqueRepository({
    CacheService? cacheService,
    NetworkService? networkService,
    UserRepository? userRepository,
  })  : _cacheService = cacheService ?? CacheService(),
        _network = networkService ?? NetworkService(),
        _userRepository = userRepository ?? UserRepository();

  Future<List<Technique>> getAllTechniques() async {
    final jsonStr = await _cacheService.loadJson('assets/data/techniques.json');
    final List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList.map((json) => Technique.fromJson(json)).toList();
  }

  Future<Technique> getTechnique(String techniqueId) async {
    final techniques = await getAllTechniques();
    return techniques.firstWhere((technique) => technique.id == techniqueId);
  }

  Future<List<Category>> getAllCategories() async {
    final jsonStr = await _cacheService.loadJson('assets/data/categories.json');
    final List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList.map((json) => Category.fromJson(json)).toList();
  }

  Future<Category> getCategory(String categoryId) async {
    final categories = await getAllCategories();
    return categories.firstWhere((cat) => cat.id == categoryId);
  }

  Future<List<Rank>> getAllRanks() async {
    final jsonStr = await _cacheService.loadJson('assets/data/ranks.json');
    final List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList.map((json) => Rank.fromJson(json)).toList();
  }

  Future<Rank> getRank(String rankId) async {
    final ranks = await getAllRanks();
    return ranks.firstWhere((rank) => rank.id == rankId);
  }

  Future<TechniquesByCategory> getTechniquesByCategory(String rankId) async {
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
    return model;
  }

  Future<TechniquesByRank> getTechniquesByRank(String categoryId) async {
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
            stripeColor: rank.stripeColor,
            sortOrder: rank.sortOrder,
          )..techniques = matchingTechniques;
        })
        .where((r) => r.techniques?.isNotEmpty ?? false)
        .toList();

    final model = TechniquesByRank(ranks: ranked);
    model.sortTechniquesAlphabetically();
    return model;
  }

  Future<List<String>> getTechniqueVideos(String techniqueId) async {
    User? user = await _userRepository.loadCachedUser();
    if (user == null || user.deviceId == null) {
      throw Exception("User credentials not found in secure storage.");
    }

    final response = await _network.get(
      'video/video.php?email=${user.email}&device=${user.deviceId}&techniqueId=$techniqueId',
    );

    final urls = response['urls'];
    if (urls is List) {
      return urls.cast<String>();
    } else {
      throw Exception("Invalid response format for video URLs.");
    }
  }
}
