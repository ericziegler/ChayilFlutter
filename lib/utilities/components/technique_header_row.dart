import 'package:flutter/material.dart';
import 'package:chayil/utilities/styles/colors.dart';
import 'package:chayil/utilities/styles/text_styles.dart';

class TechniqueHeaderRow extends StatelessWidget {
  final String text;
  final String backgroundHex;
  final String foregroundHex;
  final String? imageAsset;

  const TechniqueHeaderRow({
    Key? key,
    required this.text,
    required this.backgroundHex,
    required this.foregroundHex,
    this.imageAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double imageSize = 50;

    return Container(
      decoration: BoxDecoration(
        color: HexColor.fromHex(backgroundHex),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      margin: const EdgeInsets.fromLTRB(0, 16, 12, 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            width: imageSize,
            height: imageSize,
            decoration: const BoxDecoration(
              color: neutralColor,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                imageAsset ?? 'assets/images/fist.png',
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: techniqueHeaderTextStyle(HexColor.fromHex(foregroundHex)),
            ),
          ),
        ],
      ),
    );
  }
}
