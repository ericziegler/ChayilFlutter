import 'dart:convert';
import 'package:chayil/domain/models/techniques/technique.dart';
import 'package:chayil/domain/models/ranks/rank.dart';
import 'package:chayil/domain/models/categories/category.dart';
import 'package:chayil/domain/models/techniques/techniques_by_category.dart';
import 'package:chayil/domain/models/techniques/techniques_by_rank.dart';
import 'package:chayil/domain/services/cache_service.dart';

class TechniquesRepository {
  final CacheService _cacheService;

  TechniquesRepository(this._cacheService);

  Future<List<Technique>> getAllTechniques() async {
    final jsonString = await _cacheService
        .loadDecryptedJson('assets/data/techniques.json.enc');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((item) => Technique.fromJson(item)).toList();
  }

  Future<List<Category>> getAllCategories() async {
    final jsonString = await _cacheService
        .loadDecryptedJson('assets/data/categories.json.enc');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((item) => Category.fromJson(item)).toList();
  }

  Future<List<Rank>> getAllRanks() async {
    final jsonString =
        await _cacheService.loadDecryptedJson('assets/data/ranks.json.enc');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((item) => Rank.fromJson(item)).toList();
  }

  Future<List<TechniquesByCategory>> getTechniquesByCategory(
      String rankId) async {
    final techniques = await getAllTechniques();
    final categories = await getAllCategories();

    return categories
        .map((category) {
          final filteredTechniques = techniques
              .where((t) => t.categoryId == category.id && t.rankId == rankId)
              .toList()
            ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
          return TechniquesByCategory(
              category: category, techniques: filteredTechniques);
        })
        .where((group) => group.techniques.isNotEmpty)
        .toList();
  }

  Future<List<TechniquesByRank>> getTechniquesByRank(String categoryId) async {
    final techniques = await getAllTechniques();
    final ranks = await getAllRanks();

    return ranks
        .map((rank) {
          final filteredTechniques = techniques
              .where((t) => t.rankId == rank.id && t.categoryId == categoryId)
              .toList()
            ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
          return TechniquesByRank(rank: rank, techniques: filteredTechniques);
        })
        .where((group) => group.techniques.isNotEmpty)
        .toList();
  }
}
