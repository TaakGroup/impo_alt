import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:impo/src/core/app/constans/assets_paths.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmerWidget extends StatelessWidget {
  const LoadingShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colorScheme.surface,
      highlightColor: Color(0xfffcfcfc),
      direction: ShimmerDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, right: 16),
        child: SvgPicture.asset(AssetPaths.shimmerState),
      ),
    );
  }
}