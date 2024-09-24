import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:social/core/app.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'package:shimmer/shimmer.dart';

import '../image_preview_page.dart';

class ImageWidget extends StatelessWidget {
  final Function(double)? progress;
  final Function(FileInfo)? onFileLoaded;
  final Function()? onError;
  final bool isShimmerLoading;
  final String imageUrl;
  final double? width, height;
  final BoxFit? fit;
  final BorderRadiusGeometry? borderRadius;

  final DefaultCacheManager cacheManager = DefaultCacheManager();

  ImageWidget({
    Key? key,
    required this.imageUrl,
    this.progress,
    this.onFileLoaded,
    this.onError,
    this.width,
    this.height,
    this.fit,
    this.borderRadius,
    this.isShimmerLoading = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: '${App.baseUrl}/doctor/file/$imageUrl',
      cacheManager: cacheManager,
      height: height,
      width: width,
      fit: fit,
      imageBuilder: (_, imageProvider) {
        cacheManager.getFileFromCache(imageUrl).then((value) => onFileLoaded?.call(value!));
        return GestureDetector(
          onTap: () => Get.to(() => ImagePreviewPage(imageUrl: imageUrl)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              image: DecorationImage(
                image: imageProvider,
                fit: fit,
              ),
            ),
          ),
        );
      },
      errorWidget: (context, url, error) {
        onError?.call();
        return Icon(Icons.error, color: Theme.of(context).colorScheme.outline);
      },
      progressIndicatorBuilder: (context, url, downloadProgress) {
        if (downloadProgress.progress != null) {
          progress?.call(downloadProgress.progress!);
        }
        if (isShimmerLoading) {
          return Shimmer.fromColors(
            baseColor: context.colorScheme.outline.withOpacity(0.5),
            highlightColor: context.colorScheme.outline.withOpacity(0.8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: context.colorScheme.outline.withOpacity(0.1),
              ),
            ),
          );
        } else {
          return ImageProgressIndicator(value: downloadProgress.progress);
        }
      },
    );
  }
}

class ImageProgressIndicator extends StatelessWidget {
  final double? value;

  const ImageProgressIndicator({Key? key, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black26,
          ),
          child: CircularProgressIndicator(
            value: value,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }
}
