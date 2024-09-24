import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;

  const MainAppBar({super.key, this.title});

  @override
  Widget build(BuildContext context) => GlassContainer.clearGlass(
        color: Colors.transparent,
        blur: 12.0,
        borderWidth: 0.0,
        child: AppBar(
          title: title,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          leading: Icon(
            Icons.calendar_month_outlined,
            size: 32,
            color: context.colorScheme.inverseSurface,
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
      );

  @override
  Size get preferredSize => Size.fromHeight(50.0);
}