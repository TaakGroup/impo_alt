import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'package:taakitecture/core/interfaces/failures.dart';
import '../../constants/assets_paths.dart';
import '../../constants/messages.dart';
import '../themes/styles/buttons/button_types.dart';
import '../themes/styles/decorations.dart';

class NetworkFailureSheet extends StatelessWidget {
  final Failure failure;
  final void Function() retry;

  const NetworkFailureSheet({super.key, required this.failure, required this.retry});

  static Future show(Failure failure, Function() retry) => Get.bottomSheet(
        NetworkFailureSheet(failure: failure, retry: retry),
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
      );

  String get title {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return Messages.networkFailureTitle;
      case ServerFailure:
        return Messages.serverFailureTitle;
      default:
        return 'مشکلی به وجود آمده!';
    }
  }

  String get subtitle {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return Messages.networkFailureMessage;
      case ServerFailure:
        return Messages.serverFailureMessage;
      default:
        return 'مشکلی به وجود آمده!';
    }
  }

  String get image {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return AssetPaths.networkFailure;
      case ServerFailure:
        return AssetPaths.serverFailure;
      default:
        return AssetPaths.networkFailure;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: Decorations.pagePaddingHorizontal,
        height: double.infinity,
        child: Column(
          children: [
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.width * 0.2),
              child: Image.asset(image),
            ),
            const SizedBox(height: 32),
            Text(title, style: context.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(subtitle, textAlign: TextAlign.center, style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.outline)),
            const Spacer(),
            ElevatedButton(
              onPressed: retry,
              style: context.buttonThemes.elevatedButtonStyle(wide: true, color: ButtonColors.surface),
              child: const Text('تلاش مجدد'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
