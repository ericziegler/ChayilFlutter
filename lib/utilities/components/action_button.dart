import 'package:flutter/material.dart';
import 'package:chayil/utilities/styles/text_styles.dart';
import 'package:chayil/utilities/styles/colors.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const ActionButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor,
          backgroundColor: accentColor,
          disabledForegroundColor: textColor.withOpacity(0.5),
          disabledBackgroundColor: accentColor.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: actionButtonTextStyle,
          fixedSize: const Size.fromHeight(55),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
