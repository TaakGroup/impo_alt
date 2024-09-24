import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:social/chat_application.dart';
import 'package:social/core/app/constants/assets_paths.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'package:social/core/app/utils/extensions/on_datetime/on_datetime.dart';
import 'package:social/core/app/view/widgets/loading_indicator_widget.dart';
import '../../../../core/app/view/themes/styles/decorations.dart';
import '../../controller/messenger_controller.dart';
import '../widgets/bubble/message_bubble_widget.dart';
import '../widgets/messenger_input.dart';

class MessengerPage extends StatelessWidget {
  const MessengerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: MessengerController.to.scaffoldKey,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size(
          double.infinity,
          56.0,
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: AppBar(
              backgroundColor: Colors.white.withOpacity(0.5),
              title: MessengerController.to.obx(
                (messenger) => Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        image: DecorationImage(image: CachedNetworkImageProvider(messenger!.partnerAvatar)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        shadows: [
                          const BoxShadow(
                            color: Color(0x4CFFFFFF),
                            blurRadius: 0,
                            offset: Offset(0, 0),
                            spreadRadius: 2.50,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(messenger.partnerName),
                  ],
                ),
                onLoading: const SizedBox(),
              ),
              leading: IconButton(
                icon: SvgPicture.asset(AssetPaths.arrowRight, color: context.colorScheme.onBackground),
                onPressed: ()  {

                  Navigator.of(context).pop();
                  // Get.delete<GetMaterialController>();

                },
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.20, -0.98),
            end: Alignment(-0.2, 0.98),
            colors: [Color(0xFFFFD9F0), Color(0xFFF4D5F6), Color(0xFFBCD4F8)],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: MessengerController.to.obx(
                (model) => CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  controller: MessengerController.to.scrollController,
                  reverse: true,
                  shrinkWrap: true,
                  slivers: [
                    SliverPadding(
                      padding: Decorations.pagePaddingHorizontal.copyWith(bottom: 56 + 16),
                      sliver: SliverAnimatedList(
                        key: MessengerController.to.listKey,
                        initialItemCount: MessengerController.to.messages.length,
                        itemBuilder: (context, index, animation) => Padding(
                          padding: EdgeInsets.only(bottom: index != 0 ? 16.0 : 0),
                          child: MessagesBubbleWidget(
                            animation: animation,
                            message: MessengerController.to.messages[index],
                          ),
                        ),
                      ),
                    ),
                    // SliverAppBar(
                    //   backgroundColor: Colors.transparent,
                    //   expandedHeight: 56,
                    //   pinned: false,
                    //   floating: false,
                    //   snap: false,
                    //   flexibleSpace: FlexibleSpaceBar(
                    //     centerTitle: true,
                    //     title: Text(
                    //       model.createTime.toPersianText,
                    //       style: context.textTheme.labelSmall?.copyWith(color: context.colorScheme.outline),
                    //     ),
                    //   ),
                    // ),
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 16, bottom: 32),
                      sliver: SliverToBoxAdapter(
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                            child: Container(
                              color: context.colorScheme.background.withOpacity(0.5),
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                              child: Text(
                                model!.text,
                                textAlign: TextAlign.center,
                                style: context.textTheme.titleSmall,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.only(top: 56 + context.mediaQuery.padding.top + 22),
                      sliver: SliverToBoxAdapter(
                        child: Center(
                          child: Text(
                            model.createTime.toPersianText,
                            style: context.textTheme.labelSmall?.copyWith(color: context.colorScheme.outline),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                onLoading: Center(
                  child: LoadingIndicatorWidget(color: context.colorScheme.background),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: MessengerController.to.obx(
                (_) {
                  return MessengerInput(
                    canSend: MessengerController.to.canSendMessages,
                    messageTextEditingController: MessengerController.to.messageTextEditingController,
                    onSendPressed: MessengerController.to.sendMessage,
                  );
                },
                onLoading: const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
