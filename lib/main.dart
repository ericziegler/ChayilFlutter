import 'package:flutter/material.dart';
import 'package:chayil/presentation/splash/splash_page.dart';
import 'package:chayil/utilities/styles/colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ChayilApp());
}

class ChayilApp extends StatelessWidget {
  const ChayilApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chayil',
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: ThemeData(
        primaryColor: toolbarColor,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
          backgroundColor: toolbarColor,
          foregroundColor: textColor,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: accentColor,
          background: backgroundColor,
          onBackground: textColor,
        ),
        scaffoldBackgroundColor: backgroundColor,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: textColor),
          bodyMedium: TextStyle(color: textColor),
          bodySmall: TextStyle(color: textColor),
          // Define other text styles as needed
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: accentColor,
        ),
      ),
      home: const SplashPage(),
    );
  }
}
