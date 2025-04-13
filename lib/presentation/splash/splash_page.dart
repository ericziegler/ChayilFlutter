import 'package:flutter/material.dart';
import 'package:chayil/presentation/main_tab/main_tab_page.dart';
import 'package:chayil/presentation/authentication/request_login_page.dart';
import 'package:chayil/domain/repositories/user_repository.dart';
import 'package:chayil/utilities/managers/dependency_container.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final UserRepository _userRepository;

  @override
  void initState() {
    super.initState();
    _userRepository = getIt<UserRepository>();
    _checkUser();
  }

  void _checkUser() async {
    final user = await _userRepository.getCachedUser();

    if (!mounted) return;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainTabPage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const RequestLoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
    );
  }
}
