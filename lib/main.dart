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
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        brightness: Brightness.light,
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
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: accentColor,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: Colors.black,
          secondary: accentColor,
          surface: Colors.grey[900]!,
          onSurface: Colors.white,
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.grey[900],
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          contentTextStyle: const TextStyle(color: Colors.white),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: accentColor,
        ),
      ),
      home: const SplashPage(),
    );
  }
}
