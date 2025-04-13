import 'package:flutter/material.dart';
import '../styles/colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: const Center(
        child: SizedBox(
          width: 64,
          height: 64,
          child: CircularProgressIndicator(
            color: accentColor,
          ),
        ),
      ),
    );
  }
}
