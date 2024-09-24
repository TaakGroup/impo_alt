import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'package:social/core/app/view/widgets/loading_indicator_widget.dart';
import 'package:social/features/share_experience/social/controller/share_experience_controller.dart';
import 'package:social/features/share_experience/social/view/widgets/share_experience_comment_widget.dart';

import '../../../../../core/app/constants/assets_paths.dart';
import '../../../../../core/app/view/themes/styles/buttons/button_types.dart';
import '../../../../../core/app/view/themes/styles/decorations.dart';
import '../../controller/share_experience_profile_activities_controller.dart';
import '../../controller/share_experience_profile_controller.dart';

class shareExperienceProfileActivitiesPage extends StatelessWidget {
  const shareExperienceProfileActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          style: context.buttonThemes.outlineButtonStyle(color: ButtonColors.surface)?.copyWith(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.all(8.0),
                ),
              ),
          onPressed: Get.back,
          icon: SvgPicture.asset(
            AssetPaths.arrowRight,
            color: context.colorScheme.onSurface,
            height: 24,
            width: 24,
          ),
        ),
        title: Text(ShareExperienceProfileActivitiesController.to.args.$2),
      ),
      body: ShareExperienceProfileActivitiesController.to.obx(
        (model) => ListView.separated(
          controller: ShareExperienceProfileActivitiesController.to.scroll,
          itemCount: ShareExperienceProfileActivitiesController.to.items.length,
          padding: Decorations.pagePaddingHorizontal.copyWith(bottom: 24, top: 16),
          shrinkWrap: true,
          separatorBuilder: (_, index) => const Divider(height: 32),
          itemBuilder: (_, index) {
            return Column(
              children: [
                ShareExperienceCommentWidget(
                  comment: ShareExperienceProfileActivitiesController.to.items[index],
                  onLike: ShareExperienceController.to.like,
                  onDislike: ShareExperienceController.to.dislike,
                  onComment: ShareExperienceProfileController.to.onComment,
                  onProfilePressed: ShareExperienceProfileController.to.onOpenProfile,
                  onDeletePressed: ShareExperienceProfileActivitiesController.to.deleteExperience,
                ),
                if (index == ShareExperienceProfileActivitiesController.to.items.length - 1)
                  Obx(
                    () => Center(
                      child: LoadingIndicatorWidget(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        isShow: ShareExperienceProfileActivitiesController.to.isPaginationLoading.value,
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        onLoading: Center(
          child: LoadingIndicatorWidget(
            color: context.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
