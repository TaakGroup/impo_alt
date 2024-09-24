import 'package:flutter/material.dart';

class DownloadProgressWidget extends StatelessWidget {
  final double? progress;
  final bool? isLoading;
  final Widget? icon;
  final Color? innerColor, progressColor;
  final void Function()? onTap;

  const DownloadProgressWidget({
    Key? key,
    this.progress,
    this.isLoading,
    this.icon,
    this.innerColor,
    this.progressColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: innerColor,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isLoading ?? false)
              CircularProgressIndicator(
                value: progress,
                color: progressColor,
                strokeWidth: 1,
              ),
            if (icon != null) Container(child: icon!)

          ],
        ),
      ),
    );
  }
}
