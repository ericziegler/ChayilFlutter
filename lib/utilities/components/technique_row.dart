import 'package:flutter/material.dart';
import 'package:chayil/utilities/styles/colors.dart';
import 'package:chayil/utilities/styles/text_styles.dart';

class TechniqueRow extends StatelessWidget {
  final String text;
  final String colorHex;
  final String stripeHex;
  final VoidCallback? onTap;

  const TechniqueRow({
    Key? key,
    required this.text,
    required this.colorHex,
    required this.stripeHex,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: toolbarColor,
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
        child: IntrinsicHeight(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: Container(
                  color: HexColor.fromHex(stripeHex),
                  width: 12,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    text,
                    style: techniqueRowTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
