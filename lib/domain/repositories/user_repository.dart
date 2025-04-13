import 'package:chayil/domain/models/users/user.dart';
import 'package:chayil/domain/services/network_service.dart';
import 'package:chayil/domain/services/secure_storage_service.dart';

class UserRepository {
  final NetworkService _network;
  final SecureStorageService _secureStorage;

  UserRepository({
    required NetworkService networkService,
    required SecureStorageService secureStorageService,
  })  : _network = networkService,
        _secureStorage = secureStorageService;

  // Authenticate user with email + device
  Future<User?> authenticate(String email, String deviceId) async {
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

  Future<User?> tryAuthenticateCachedUser() async {
    final user = await getCachedUser();
    if (user == null || user.deviceId == null) return null;

    return await authenticate(user.email, user.deviceId!);
  }

  bool needsDeviceRegistration(User user) {
    return user.deviceId == null;
  }

  // Send a verification code to the user's email
  Future<void> sendVerificationCode(String email) async {
    await _network.get('user/send_verification.php?email=$email');
  }

  // Verify a submitted login code
  Future<bool> verifyLoginCode(String email, String code) async {
    final response = await _network.get(
      'user/verify.php?email=$email&code=$code',
    );

    return response['status'] == 'success';
  }

  // Register device ID for a user
  Future<User> registerDevice(String email, String deviceId) async {
    final response = await _network.post(
      'user/register_device.php?email=$email&device=$deviceId',
    );

    final user = User.fromJson(response);
    await _saveUser(user);
    return user;
  }

  // Save the user to secure storage
  Future<void> _saveUser(User user) async {
    await _secureStorage.write('user_email', user.email);
    await _secureStorage.write('user_role', user.role.name);
    await _secureStorage.write('user_status', user.status.name);
    if (user.deviceId != null) {
      await _secureStorage.write('user_device', user.deviceId!);
    }
  }

  // Optionally fetch the user from secure storage
  Future<User?> getCachedUser() async {
    final email = await _secureStorage.read('user_email');
    final role = await _secureStorage.read('user_role');
    final status = await _secureStorage.read('user_status');
    final device = await _secureStorage.read('user_device');

    if (email == null || role == null || status == null) return null;

    return User(
      email: email,
      deviceId: device,
      status: UserStatus.values.firstWhere((e) => e.name == status),
      role: UserRole.values.firstWhere((e) => e.name == role),
    );
  }

  Future<void> logout() async {
    await _secureStorage.delete('user_email');
    await _secureStorage.delete('user_role');
    await _secureStorage.delete('user_status');
    await _secureStorage.delete('user_device');
  }
}
