import 'package:flutter/material.dart';
import 'package:chayil/domain/repositories/user_repository.dart';
import 'package:chayil/domain/services/network_service.dart';
import 'package:chayil/domain/services/secure_storage_service.dart';
import 'package:chayil/presentation/authentication/request_login_page.dart';
import 'package:chayil/presentation/authentication/register_device_page.dart';
import 'package:chayil/presentation/main_tab/main_tab_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with WidgetsBindingObserver {
  late final UserRepository _userRepository;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // 👇 Instantiate services directly
    final networkService = NetworkService();
    final secureStorageService = SecureStorageService();

    _userRepository = UserRepository(
      networkService: networkService,
      secureStorageService: secureStorageService,
    );

    _handleUserFlow(); // Run initially
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _handleUserFlow(); // Run every time app is foregrounded
    }
  }

  Future<void> _handleUserFlow() async {
    final user = await _userRepository.tryAuthenticateCachedUser();

    if (!mounted) return;

    if (user == null) {
      _navigateTo(const RequestLoginPage());
      return;
    }

    if (_userRepository.needsDeviceRegistration(user)) {
      final didRegister = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (context) => const RegisterDevicePage()),
      );

      if (didRegister == true) {
        _navigateTo(const MainTabPage());
      } else {
        _navigateTo(const RequestLoginPage());
      }
    } else {
      _navigateTo(const MainTabPage());
    }
  }

  void _navigateTo(Widget page) {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
    );
  }
}
