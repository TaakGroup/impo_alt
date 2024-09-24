
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/app/constans/assets_paths.dart';

class HeaderActivationWidget extends StatelessWidget {
  final String progressBar;
  const HeaderActivationWidget({super.key, required this.progressBar});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image.asset(
          AssetPaths.backQuestion,
          width: Get.width,
          fit: BoxFit.cover,
        ),
        progressBar != '' ?
        Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: SvgPicture.asset(
              progressBar
          ),
        ) : SizedBox.shrink()
      ],
    );
  }
}
