import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/app/constans/assets_paths.dart';
import '../../../../core/app/utiles/helper/custom_decoder_lottie.dart';

class CycleWaveWidget extends StatelessWidget {
  final Color color;

  const CycleWaveWidget({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      AssetPaths.cycleWave,
      width: double.infinity,
      decoder: customDecoder,
      fit: BoxFit.fill,
      delegates: LottieDelegates(
        values: [
          ValueDelegate.color(
            const ["**", 'avali', '**'],
            value: color,
          ),
          ValueDelegate.color(
            const ["**", 'dovomi', '**'],
            value: color,
          ),
        ],
      ),
    );
  }
}
