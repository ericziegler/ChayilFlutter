import 'package:smartlogger/smartlogger.dart';
import 'package:chayil/domain/services/api/api_service.dart';
import 'package:chayil/domain/models/technique/techniques_by_category.dart';
import 'package:chayil/domain/models/technique/techniques_by_rank.dart';
import 'package:chayil/domain/models/technique/technique.dart';
import 'package:chayil/domain/models/api_response/api_response.dart';
import 'package:chayil/domain/models/user/user.dart';
import 'package:chayil/domain/repositories/user_repository.dart';

class TechniqueRepository {
  // Singleton

  static final TechniqueRepository _techniqueRepository =
      TechniqueRepository._internal();

  factory TechniqueRepository() {
    return _techniqueRepository;
  }

  TechniqueRepository._internal();

  // Techniques by Category

  Future<TechniquesByCategory> loadTechniquesByCategory(String rankId) async {
    User? user = await UserRepository().loadUser();
    if (user == null || user.email.isEmpty || user.token.isEmpty) {
      throw Exception('expired_session');
    }
    var params = {'email': user.email, 'token': user.token, 'rankId': rankId};
    var url = buildUrl('technique/list.php', params);
    try {
      ApiResponse<TechniquesByCategory?> response =
          await getModelData(url, TechniquesByCategory.fromJson);
      if (response.status == "success") {
        // Check if data is not null
        if (response.data != null) {
          // Success!
          TechniquesByCategory result = response.data!;
          result.sortTechniquesAlphabetically();
          return result;
        } else {
          throw Exception('No data available.');
        }
      } else if (response.status == 'expired_session') {
        UserRepository().removeUser();
        throw Exception(response.status);
      } else {
        // Handle error based on the status
        Log.d("Bad Status: ${response.status}");
        throw Exception(response.status);
      }
    } catch (e) {
      // Handle exceptions
      Log.d(e.toString());
      rethrow;
    }
  }

  // Techniques By Rank

  Future<TechniquesByRank> loadTechniquesByRank(String categoryId) async {
    User? user = await UserRepository().loadUser();
    if (user == null || user.email.isEmpty || user.token.isEmpty) {
      throw Exception('expired_session');
    }
    var params = {
      'email': user.email,
      'token': user.token,
      'categoryId': categoryId
    };
    var url = buildUrl('technique/list.php', params);
    try {
      ApiResponse<TechniquesByRank?> response =
          await getModelData(url, TechniquesByRank.fromJson);
      if (response.status == "success") {
        // Check if data is not null
        if (response.data != null) {
          // Success!
          TechniquesByRank result = response.data!;
          result.sortTechniquesAlphabetically();
          return result;
        } else {
          throw Exception('No data available.');
        }
      } else if (response.status == 'expired_session') {
        UserRepository().removeUser();
        throw Exception(response.status);
      } else {
        // Handle error based on the status
        Log.d("Bad Status: ${response.status}");
        throw Exception(response.status);
      }
    } catch (e) {
      // Handle exceptions
      Log.d(e.toString());
      rethrow;
    }
  }

  // Technique Details

  Future<Technique> loadTechnique(String id) async {
    User? user = await UserRepository().loadUser();
    if (user == null || user.email.isEmpty || user.token.isEmpty) {
      throw Exception('expired_session');
    }
    var params = {
      'email': user.email,
      'token': user.token,
      'id': id,
    };
    var url = buildUrl('technique/details.php', params);
    try {
      ApiResponse<Technique?> response =
          await getModelData(url, Technique.fromJson);
      if (response.status == "success") {
        // Check if data is not null
        if (response.data != null) {
          // Success!
          return response.data!;
        } else {
          throw Exception('No data available.');
        }
      } else if (response.status == 'expired_session') {
        UserRepository().removeUser();
        throw Exception(response.status);
      } else {
        // Handle error based on the status
        Log.d("Bad Status: ${response.status}");
        throw Exception(response.status);
      }
    } catch (e) {
      // Handle exceptions
      Log.d(e.toString());
      rethrow;
    }
  }
}
