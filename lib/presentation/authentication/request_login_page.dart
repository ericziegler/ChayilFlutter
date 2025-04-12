import 'package:chayil/utilities/styles/text_styles.dart';
import 'package:chayil/utilities/styles/colors.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Text(
          'REQUEST LOGIN',
          style: headerTextStyle,
        ),
      ),
    );
  }
}
