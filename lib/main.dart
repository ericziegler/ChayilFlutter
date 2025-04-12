import 'package:flutter/material.dart';
import 'package:chayil/utilities/managers/dependency_container.dart';
import 'package:chayil/utilities/style/theme.dart';
import 'package:chayil/presentation/splash/splash_page.dart';

void main() {
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chayil Martial Arts',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
    );
  }
}
