import 'package:flutter/material.dart';
import 'package:social_media/resources/dimens.dart';

class PrimaryButtonView extends StatelessWidget {
  final String label;
  final Color themeColor;

  const PrimaryButtonView({
    Key? key,
    required this.label,
    this.themeColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MARGIN_XXLARGE,
      decoration: BoxDecoration(
        color: themeColor,
        borderRadius: BorderRadius.circular(
          MARGIN_LARGE,
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: TEXT_REGULAR_2X,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
