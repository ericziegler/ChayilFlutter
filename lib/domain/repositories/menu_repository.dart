import 'package:smartlogger/smartlogger.dart';
import 'dart:convert';
import 'dart:async';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:chayil/domain/services/api/api_service.dart';
import 'package:chayil/domain/models/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chayil/domain/models/api_response/api_response.dart';

class UserRepository {
  // Singleton

  static final UserRepository _userRepository = UserRepository._internal();

  factory UserRepository() {
    return _userRepository;
  }

  UserRepository._internal();

  // Properties

  static const _requestCodeEmailKey = 'com.chayil.keys.requestEmail';
  static const _userKey = 'com.chayil.keys.user';
  final StreamController<User?> _userController =
      StreamController<User?>.broadcast();
  Stream<User?> get onUserChanged => _userController.stream;

  User? user;

  // Caching

  Future<String?> loadRequestCodeEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_requestCodeEmailKey);
  }

  Future<void> saveRequestCodeEmail(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_requestCodeEmailKey, email);
  }

  Future<User?> loadUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString(_userKey);
    if (userJson != null) {
      user = User.fromJson(jsonDecode(userJson));
      return user;
    }
    return null;
  }

  Future<void> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toJson());
    await prefs.setString(_userKey, userJson);
    _updateUser(user);
  }

  Future<void> removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    _updateUser(null);
  }

  void _updateUser(User? user) {
    _userController.add(user);
  }

  // Login

  Future<void> requestLoginCode(String email) async {
    var params = {'email': email};
    var url = buildUrl('user/request_login.php', params);
    try {
      ApiResponse<dynamic> response = await getModelData(url);
      if (response.status == "success") {
        // Success! Cache the email.
        saveRequestCodeEmail(email);
      } else {
        // Handle error based on the status
        Log.d("Bad Status");
        throw Exception('Request failed with status: ${response.status}.');
      }
    } catch (e) {
      // Handle exceptions
      Log.d(e.toString());
      rethrow;
    }
  }

  Future<User> login(String email, String code) async {
    String deviceName = await _getDeviceName();
    var params = {'email': email, 'code': code, 'device': deviceName};
    var url = buildUrl('user/login.php', params);
    try {
      ApiResponse<User?> response = await getModelData(url, User.fromJson);
      if (response.status == "success") {
        // Check if data is not null
        if (response.data != null) {
          // Success! Cache the user
          saveUser(response.data!);
          return response.data!;
        } else {
          throw Exception('No user data available.');
        }
      } else {
        // Handle error based on the status
        Log.d("Bad Status");
        throw Exception('Request failed with status: ${response.status}.');
      }
    } catch (e) {
      // Handle exceptions
      Log.d(e.toString());
      rethrow;
    }
  }

  Future<String> _getDeviceName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.model != null && androidInfo.model.isNotEmpty) {
        return androidInfo.model;
      }
    } catch (e) {
      try {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        if (iosInfo.utsname.machine != null &&
            iosInfo.utsname.machine.isNotEmpty) {
          return iosInfo.utsname.machine;
        }
      } catch (e) {
        return 'UNKNOWN';
      }
    }
    return 'UNKNOWN';
  }
}
