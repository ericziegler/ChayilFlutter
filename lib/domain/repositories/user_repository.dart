import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:chayil/domain/models/users/user.dart';
import 'package:chayil/domain/services/network_service.dart';
import 'package:chayil/domain/services/secure_storage_service.dart';

class UserRepository {
  final NetworkService _network = NetworkService();
  final SecureStorageService _secureStorage = SecureStorageService();

  static const _authEmailKey = 'auth_email_key';
  static const _authDeviceIdKey = 'auth_device_id_key';

  static const _userEmailKey = 'user_email_key';
  static const _userDeviceIdKey = 'user_device_id_key';
  static const _userStatusKey = 'user_status_key';
  static const _userRoleKey = 'user_role_key';

  // ===========================
  // MARK: - User Caching
  // ===========================

  Future<String?> loadSecureEmail() async {
    return await _secureStorage.read(_authEmailKey);
  }

  Future<void> saveSecureEmail(String email) async {
    await _secureStorage.write(_authEmailKey, email);
  }

  Future<void> _saveUser(User user) async {
    await _secureStorage.write(_userEmailKey, user.email);
    await _secureStorage.write(_userRoleKey, user.role.name);
    await _secureStorage.write(_userStatusKey, user.status.name);
    if (user.deviceId != null) {
      await _secureStorage.write(_userDeviceIdKey, user.deviceId!);
    }
  }

  Future<User?> loadCachedUser() async {
    final email = await _secureStorage.read(_userEmailKey);
    final role = await _secureStorage.read(_userRoleKey);
    final status = await _secureStorage.read(_userStatusKey);
    final device = await _secureStorage.read(_userDeviceIdKey);

    if (email == null || role == null || status == null) return null;

    return User(
      email: email,
      deviceId: device,
      status: UserStatus.values.firstWhere((e) => e.name == status),
      role: UserRole.values.firstWhere((e) => e.name == role),
    );
  }

  Future<void> clearCachedUser() async {
    await _secureStorage.delete(_userEmailKey);
    await _secureStorage.delete(_userDeviceIdKey);
    await _secureStorage.delete(_userStatusKey);
    await _secureStorage.delete(_userRoleKey);
  }

  // ======================
  // MARK: - Authentication
  // ======================

  Future<User?> authenticateUser() async {
    final email = await loadSecureEmail();
    final deviceId = await _loadCachedDeviceId() ?? '';

    if (email == null) return null;

    return await _authenticate(email, deviceId);
  }

  Future<User?> _authenticate(String email, String deviceId) async {
    // TODO: EZ - Remove
    print('👉 Authenticating with email=$email & device=$deviceId');
    final response = await _network.get(
      'user/authenticate.php?email=$email&device=$deviceId',
    );

    if (response['status'] == 'invalid') return null;

    if (response['status'] == 'canRegister') {
      return User(
        email: email,
        deviceId: null,
        status: UserStatus.inactive,
        role: UserRole.student,
      );
    }

    final user = User.fromJson(response);
    await _saveUser(user);
    return user;
  }

  // ====================
  // MARK: - Verification
  // ====================

  // Send a verification code to the user's email
  Future<void> sendVerificationCode(String email) async {
    final response =
        await _network.get('user/send_verification.php?email=$email');

    if (response['status'] == 'success') {
      await saveSecureEmail(email);
    }
  }

  // Verify a submitted login code
  Future<bool> verifyLoginCode(String code) async {
    final email = await loadSecureEmail();
    if (email == null) return false;

    final response = await _network.get(
      'user/verify.php?email=$email&code=$code',
    );

    return response['status'] == 'success';
  }

  // ===========================
  // MARK: - Device Registration
  // ===========================

  bool needsDeviceRegistration(User user) {
    return user.deviceId == null;
  }

  // Register device ID for a user
  Future<User> registerDevice(String email, String? existingDeviceId) async {
    final deviceId = existingDeviceId ?? await _getOrCreateDeviceId();

    final response = await _network.get(
      'user/register_device.php?email=$email&device=$deviceId',
    );

    final user = User.fromJson(response);
    await _secureStorage.write(_authDeviceIdKey, deviceId);
    await _saveUser(user);
    return user;
  }

  Future<String?> _loadCachedDeviceId() async {
    return await _secureStorage.read(_authDeviceIdKey);
  }

  Future<String> _getOrCreateDeviceId() async {
    // First try to load it from secure storage
    final storedId = await _secureStorage.read(_authDeviceIdKey);
    if (storedId != null) return storedId;

    // If not found, generate one based on device info
    final deviceInfo = DeviceInfoPlugin();
    String newId;

    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      newId = info.id;
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      newId = info.identifierForVendor ?? _generateRandomId();
    } else {
      newId = _generateRandomId(); // fallback for other platforms
    }

    await _secureStorage.write(_authDeviceIdKey, newId);
    return newId;
  }

  String _generateRandomId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
