import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'bubble/image_widget.dart';

class ImageMessageView extends StatelessWidget {
  final String imageUrl;
  final BorderRadiusGeometry borderRadius;
  final void Function()? onTap;

  const ImageMessageView({
    Key? key,
    required this.imageUrl,
    this.borderRadius = BorderRadius.zero,
    this.onTap,
  }) : super(key: key);
  //
  // int get width => metadata.width.toInt();
  //
  // int get height => metadata.height.toInt();

  double get aspectRatio => 1.0;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Center(
          child: ImageWidget(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
