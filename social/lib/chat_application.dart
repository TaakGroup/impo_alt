import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social/features/messenger/controller/messenger_controller.dart';
import 'core/app.dart';
import 'core/app/constants/app_routes.dart';
import 'core/app/constants/messages.dart';
import 'core/app/utils/mixin/handle_failure_mixin.dart';
import 'core/app/view/themes/theme.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'initial_bindings.dart';
import 'routes.dart';

class ChatApp extends StatelessWidget {
  final Function(bool hasPartner) back;
  final String baseUrl;
  final String baseMediaUrl;
  final String token;
  final String id;

  String get initRoute => '${AppRoutes.chat}?id=$id';

  const ChatApp({
    Key? key,
    required this.token,
    required this.baseUrl,
    required this.baseMediaUrl,
    required this.id,
    required this.back,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {


        return Future.value(false);
      },
      child: GetMaterialApp(
        title: "Chat",
        debugShowCheckedModeBanner: false,
        onInit: App.onAppStart(context, token, baseUrl, baseMediaUrl),
        initialBinding: InitialBindings(),
        theme: ImpoTheme.light,
        themeMode: ThemeMode.light,
        textDirection: TextDirection.rtl,
        translations: Messages(),
        locale: const Locale('fa_IR'),
        getPages: Routs.routs,
        initialRoute: initRoute,
        routingCallback: (_) {
          if (_?.isBack == true && !HandleFailureMixin.isSheetOpen) {
            back(MessengerController.to.hasPartner);
          }
        },
        builder: (context, child) => ResponsiveWrapper.builder(
          maxWidth: 480.0,
          child,
          defaultScale: true,
          breakpoints: const [
            ResponsiveBreakpoint.autoScale(360, name: MOBILE),
            ResponsiveBreakpoint.resize(480, name: TABLET),
          ],
        ),
      ),
    );
  }
}
