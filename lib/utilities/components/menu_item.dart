import 'package:flutter/material.dart';
import 'package:chayil/utilities/styles/colors.dart';
import 'package:chayil/utilities/styles/text_styles.dart';

class MenuItem extends StatelessWidget {
  final String text;
  final String? imageAsset;
  final VoidCallback? onTap;

  const MenuItem({
    Key? key,
    required this.text,
    this.imageAsset,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double imageSize = 60;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: backgroundColor,
        padding: const EdgeInsets.fromLTRB(16, 0, 12, 0),
        child: Row(
          children: [
            if (imageAsset != null) ...[
              Image.asset(
                imageAsset!,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
            ] else ...[
              const SizedBox(height: imageSize),
            ],
            Expanded(
              child: Text(
                text,
                style: rankTextStyle,
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: separatorColor,
            ),
          ],
        ),
      ),
    );
  }
}
