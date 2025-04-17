import 'package:chayil/domain/services/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:chayil/domain/repositories/user_repository.dart';
import 'package:chayil/domain/models/users/user.dart';
import 'package:chayil/presentation/authentication/request_login_page.dart';
import 'package:chayil/presentation/authentication/register_device_page.dart';
import 'package:chayil/presentation/main_tab/main_tab_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with WidgetsBindingObserver {
  final UserRepository _userRepository = UserRepository();
  final SecureStorageService _secureStorageService = SecureStorageService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.delayed(const Duration(milliseconds: 500), () {
        _handleUserFlow();
      });
    });
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
    await _secureStorageService.initializeIfFreshInstall();
    final user = await _userRepository.authenticateUser();

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

    final currentRoute = ModalRoute.of(context);

    // Define a route name for comparison (optional improvement: use a route enum or string map)
    final newRouteName = (page is MainTabPage) ? 'MainTab' : 'OtherPage';
    final currentRouteName = currentRoute?.settings.name;

    if (currentRouteName == newRouteName) return;

    final newPageRoute = MaterialPageRoute(
      builder: (context) => page,
      settings: RouteSettings(name: newRouteName),
    );

    if (currentRoute != null) {
      Navigator.of(context).replace(
        oldRoute: currentRoute,
        newRoute: newPageRoute,
      );
    } else {
      // fallback if ModalRoute is null (might be in edge cases or custom nav stacks)
      Navigator.of(context).pushReplacement(newPageRoute);
    }
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
