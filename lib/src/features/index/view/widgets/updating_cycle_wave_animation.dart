import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/app/constans/assets_paths.dart';
import '../../../../core/app/utiles/helper/custom_decoder_lottie.dart';

class UpdatingCycleWaveAnimation extends StatelessWidget {
  final Animation<double> controller;
  final Color color;

  const UpdatingCycleWaveAnimation({
    super.key,
    required this.color,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      AssetPaths.updatingCycle,
      controller: controller,
      width: double.infinity,
      decoder: customDecoder,
      fit: BoxFit.fill,
      repeat: false,
      delegates: LottieDelegates(
        values: [
          ValueDelegate.color(
            const ["**", 'First', '**'],
            value: color,
          ),
          ValueDelegate.color(
            const ["**", 'Second', '**'],
            value: color,
          ),
        ],
      ),
    );
  }
}
