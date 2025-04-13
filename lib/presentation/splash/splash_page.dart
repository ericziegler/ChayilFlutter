import 'package:flutter/material.dart';
import 'package:chayil/presentation/main_tab/main_tab_page.dart';
import 'package:chayil/presentation/authentication/request_login_page.dart';
import 'package:chayil/domain/repositories/user_repository.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  void _checkUser() async {
    var user = await UserRepository().loadUser();
    if (!mounted) return;

    if (user != null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainTabPage()));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const RequestLoginPage()));
    }
  }

  final _userRepository = UserRepository();

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
