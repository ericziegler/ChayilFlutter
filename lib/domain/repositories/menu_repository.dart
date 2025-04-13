import 'package:smartlogger/smartlogger.dart';
import 'package:chayil/domain/services/api/api_service.dart';
import 'package:chayil/domain/models/category/category_list.dart';
import 'package:chayil/domain/models/rank/rank_list.dart';
import 'package:chayil/domain/models/api_response/api_response.dart';
import 'package:chayil/domain/models/user/user.dart';
import 'package:chayil/domain/repositories/user_repository.dart';

class MenuRepository {
  // Singleton

  static final MenuRepository _menuRepository = MenuRepository._internal();

  factory MenuRepository() {
    return _menuRepository;
  }

  MenuRepository._internal();

  // Ranks

  Future<RankList> loadRanks() async {
    User? user = await UserRepository().loadUser();
    if (user == null || user.email.isEmpty || user.token.isEmpty) {
      throw Exception('expired_session');
    }
    var params = {'email': user.email, 'token': user.token};
    var url = buildUrl('menu/ranks.php', params);
    try {
      ApiResponse<RankList?> response =
          await getModelData(url, RankList.fromJson);
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

  // Categories

  Future<CategoryList> loadCategories() async {
    User? user = await UserRepository().loadUser();
    if (user == null || user.email.isEmpty || user.token.isEmpty) {
      throw Exception('expired_session');
    }
    var params = {'email': user.email, 'token': user.token};
    var url = buildUrl('menu/categories.php', params);
    try {
      ApiResponse<CategoryList?> response =
          await getModelData(url, CategoryList.fromJson);
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
