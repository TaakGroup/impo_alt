import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:social/core/app/constants/assets_paths.dart';
import 'bubble/image_widget.dart';

class ImagePreviewPage extends StatelessWidget {
  final String imageUrl;
  File? imageFile;
  RxBool downloadComplete = false.obs;
  RxBool showAppBar = true.obs;

  ImagePreviewPage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () => showAppBar.value = !showAppBar.value,
          child: Obx(
            () {
              return Stack(
                children: [
                  InteractiveViewer(
                    scaleEnabled: true,
                    panEnabled: true,
                    child: Hero(
                      tag: imageUrl,
                      child: Center(
                        child: ImageWidget(
                          imageUrl: imageUrl,
                          onFileLoaded: (_) {},
                        ),
                      ),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: !showAppBar.value
                        ? const SizedBox()
                        : Container(
                            color: Colors.black54,
                            height: 88,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: SafeArea(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: Get.back,
                                    icon: SvgPicture.asset(
                                      AssetPaths.arrowRight,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
