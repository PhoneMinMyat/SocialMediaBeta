import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:social_media/resources/dimens.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: const Center(
        child: SizedBox(
          width: MARGIN_XXLARGE,
          height: MARGIN_XXLARGE,
          child: LoadingIndicator(
            indicatorType: Indicator.ballRotate,
            colors: [Colors.white],
            strokeWidth: 2,
            backgroundColor: Colors.transparent,
            pathBackgroundColor: Colors.black,
          ),
        ),
      ),
    );
  }
}
