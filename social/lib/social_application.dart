import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'core/app.dart';
import 'core/app/constants/app_routes.dart';
import 'core/app/constants/messages.dart';
import 'core/app/utils/mixin/handle_failure_mixin.dart';
import 'core/app/view/themes/theme.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'features/share_experience/comments/controller/comment_controller.dart';
import 'initial_bindings.dart';
import 'routes.dart';

class InitialRout {
  final String route;
  final String id;

  InitialRout({required this.route, required this.id});

  String toPath(String base) => '$base?route=$route&&id=$id';
}

class ShareExperienceApp extends StatelessWidget {
  final String baseUrl;
  final String baseMediaUrl;
  final String token;
  final InitialRout? initialRoute;

  const ShareExperienceApp({
    Key? key,
    required this.token,
    required this.baseUrl,
    required this.baseMediaUrl,
    this.initialRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (Get.currentRoute == (initialRoute?.toPath(AppRoutes.shareExperience) ?? AppRoutes.shareExperience)) {
          return Future(() => true);
        } else if (Get.currentRoute.contains(AppRoutes.comment)) {
          return CommentController.to.onWillBack();
        } else {
          Get.back();
          return Future(() => false);
        }
      },
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Share Experience",
        onInit: App.onAppStart(context, token, baseUrl, baseMediaUrl),
        initialBinding: InitialBindings(),
        theme: ImpoTheme.light,
        themeMode: ThemeMode.light,
        textDirection: TextDirection.rtl,
        translations: Messages(),
        locale: const Locale('fa_IR'),
        getPages: Routs.routs,
        initialRoute: initialRoute?.toPath(AppRoutes.shareExperience) ?? AppRoutes.shareExperience,
        routingCallback: HandleFailureMixin.onRouteChange,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: ResponsiveWrapper.builder(
            maxWidth: 480.0,
            AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: context.isDarkMode ? Brightness.light : Brightness.dark,
                statusBarBrightness: context.isDarkMode ? Brightness.dark : Brightness.light,
              ),
              child: child!,
            ),
            defaultScale: true,
            breakpoints: const [
              ResponsiveBreakpoint.autoScale(360, name: MOBILE),
              ResponsiveBreakpoint.resize(480, name: TABLET),
            ],
          ),
        ),
      ),
    );
  }
}
