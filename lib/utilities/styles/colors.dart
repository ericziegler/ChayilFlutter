import 'package:flutter/material.dart';

extension HexColor on Color {
  // Constructor for creating a color from a hex code.
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', '')); // Removes '#' if it exists
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  // Method to get hex string from color
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

extension ColorUtils on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1, 'amount must be between 0 and 1');
    final f = 1 - amount;
    return Color.fromARGB(
      alpha,
      (red * f).round(),
      (green * f).round(),
      (blue * f).round(),
    );
  }
}

const Color backgroundColor = Color(0xFF121212);
const Color textColor = Color(0xFFFFFFFF);
const Color secondaryTextColor = Color(0xFF888888);
const Color toolbarColor = Color(0xFF1E1E1E);
const Color toolbarIconColor = Color(0xFFB4BBBF);
const Color separatorColor = Color(0xFF383838);
const Color accentColor = Color(0xFFE50825);
const Color neutralColor = Color(0xFFF0F0F0);
