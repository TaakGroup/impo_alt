import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:social/core/app/constants/app_routes.dart';
import 'package:social/core/app/constants/assets_paths.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'package:social/core/app/utils/extensions/on_datetime/convertor.dart';
import 'package:social/core/app/view/themes/styles/buttons/button_types.dart';
import 'package:social/core/app/view/themes/styles/text_theme.dart';
import 'package:social/core/app/view/widgets/loading_indicator_widget.dart';
import 'package:social/features/messenger/view/widgets/bubble/image_widget.dart';
import 'package:social/features/share_experience/comments/controller/reply_controller.dart';
import '../../../../../core/app/view/themes/styles/buttons/button_icon/elevated_button_icon.dart';
import '../../data/models/share_experience_comment_model.dart';

// String f = '''
// 1
// روز، داخلی، شعبه یک بانک نسبتا شلوغ، زنی که پشت یک باجه نشسته، دارد دسته‌ای از چک‌ها را مرتب می‌کند ولی مشخص است که ذهنش آشفته است.
// دیشب چندمین بار بود که گفتم نه؟ از دستم در رفته. تو این ماه فکر کنم بار چهام یا پنجم بود. واقعا نمی‌دونم حق با منه یا با حسام. اصلا من چرا اینطوری شدم بعد از ازدواج؟ نه به اون ۲۲، ۲۳ سالگی که خیلی از روزها فکر می‌کردم دلم می‌خواد آغوش داشته باشم و رابطه و نه به حالا که شوهر دارم ولی هر شب دست رد به سینه‌اش می‌زنم. اصن خیلی وقتا مگه نشده وسط روز تو همین بانک شلوغ، دلم می‌خواد؟ پس چرا اینجوری می‌شم؟ نکنه مریض شده باشم؟ نکنه چیزی می‌خورم که این طوری شده؟ برم از مامان سوال کنم؟ ولش کن! همینطوری‌ام نگران زندگی من و بقیه بچه‌هاش هست. نکنه حسام بره خیانت کنه. چقدر مگه می‌تونه تحمل کنه؟
// ۲
// روز، داخلی، یک آرایشگاه نسبتا خلوت مردانه، مردی روی یک صندلی نشسته و آرایشگر دارد همین طور که مویش را کوتاه می‌کند با او حرف می‌زند ولی مرد خیره شده به آینه و انگار اصلا حرف‌ها را نمی‌فهمد. توی خیال خودش است.
// امشب دیگه نمی‌تونه نه بگه. فکر کنم چون دیروز یه کم نامرتب بودم گفت نه! حق داره به هر حال. همین طور که من دوست دارم اون تمیز و خوش‌لباس و خوش‌بو باشه اونم حق داره. الان از اینجا می‌رم خونه. دوش می‌گیرم و با لباس زیر جدیده که خریدم می‌شینم و همین که اومد تو خانه، بغلش می‌کنم و می‌برمش تو اتاق. قبلا هم گفته بود با لباس اداری دوست داره. درسته! راهش همینه. نازنین اصلا آدم آخر شب نیست. رابطه دم غروب رو دوست داره. بالاخره امشب خلاص می‌شم. خیلی وقته دلم می‌خواد. اصن ذهنم رو مشغول کرده، کار نمی‌تونم بکنم!
// ۳
// روز، داخلی، یک کافی‌شاپ خلوت. گوشه کافه روی یک میز دو نفره، نازنین با یک خانم دیگر نشسته. خم شده روی میز و انگار دارد چیز محرمانه‌ای می‌گوید.
// ببخشید تو رو خدا! وقت تو رو هم گرفتم ولی واقعا نمی‌دونستم باید به کی بگم. دیگه فکرامو کردم دیدم من و تو از دبیرستان با هم دوستیم. جیک و پوک همو می‌دونیم. بعدشم تو متاهلی. می‌فهمی حرف منو. آره خلاصه. داستان این بود که بهت گفتم. الان خیلی نگرانم. هم دلم برا حسام می‌سوزه هم خب وقتی دوست ندارم، دوست ندارم دیگه. زوری که نمیشه. اونم من! یادته که! همیشه عاشق پیشه و احساساتی. الان عذاب وجدان دارم که غیبت حسام رو پیش تو می‌کنم ولی خب بابا من دوس ندارم وقتی می‌خوای ازم تعریف کنی همش از سینه و باسن حرف بزنی. من چشمم دارم. صورتمم بد نیست خدایی. موهامم بلنده. بعدشم خب دوس ندارم یهویی منو برداری ببری تو اتاق. یه بوسی. یه بغلی. یه دوستت دارمی. ای بابا. چقدر زندگی سخته سحر! فکر می‌کردم ازدواج می‌کنم همه چی حل میشه!
// زنی که آن روبرو نشسته می‌گوید: خب چرا اینا رو به خودش نمی‌گی؟
// ۴
// روز، داخلی، حسام در اتومبیل نشسته و همین طور که دارد رانندگی می‌کند به رادیو گوش می‌کند. زنی در حال صحبت در رادیو است.
// ببینید اگر شما گرسنه باشید؛ به صرف اینکه یک نیاز جسمی دارید می‌توانید از هر رستورانی در خیابان غذا بخورید؟ نه. این کار نیاز به ارتباط شما با آن رستوران دارد. رستوران باید باز باشد، باید در حال سرویس‌دهی باشد، باید مواد اولیه داشته باشد، آشپز باید مشغول به کار باشد، شما باید پول داشته باشید و البته محترمانه رفتار کنید. آیا می‌توانید رستورانی را پیدا کنید که به شما سرویس بدهد در حالی که پایتان را روی میزهایش قرار داده باشید؟ نه. پس رابطه جنسی پیش از آنکه جنسی باشد، رابطه است. مشکل بزرگ در رابطه‌های جنسی ما، نادیده گرفتن دیگری است.
// کمی بعد حسام جلوی یک گل فروشی توقف می‌کند.
// ۵
// روز، داخلی، نازنین در مترو نشسته و هندزفری توش گوشش است. دارد به یک پادکست گوش می‌دهد.
// میل به رابطه جنسی در میان زنان، بیشتر بعد روانی دارد. نمی‌توان انکار کرد که زنان، وقتی جذابیت مردی را ببینند ممکن است برانگیخته شوند ولی پژوهش‌هایی که درباره علل رابطه جنسی وجود دارد مثل پژوهش جامع مستون و باس، می‌گوید زنان بیش از مردها رابطه جنسی را در بافت یک رابطه متعهدانه و ادامه‌دار ترجیح می‌دهند. آن هم وقتی که احساسات و بیان عشق جزیی از آن باشد. البته این را هم باید گفت که اگرچه پژوهش‌ها تایید می‌کنند که مردان نسبت به زنان بیشتر با محرک‌های بینایی برانگیخته می‌شوند یا به تعبیر عامیانه با چشم عاشق می‌شوند ولی پژوهش‌هایی هم وجود دارد که نشان می‌دهد انگیزه مردان از رابطه جنسی رهایی از تنش، ارضای حس اقتدار و یا حتی جلب توجه عاطفی هم هست و باید به این نیازهای روانی هم توجه کرد.
// ۶
// شب، داخلی، اتاق پذیرایی خانه، گلی توی یک گلدان بلوری روی میز است، چند شیرینی و دو تا چایی نصفه و نیمه. تلویزیون خاموش است. نازنین پاهایش را آورده روی مبل و چهارزانو نشسته ولی رو به حسام و کمی هم بغض کرده. حسام، کمی لم داده روی یک کوسن. حسام صحبت می‌کند.
// واقعا نیاز داشتم این حرفا رو بشنوم نازنین. می‌دونی؟ من همیشه فکر می‌کردم که یه مشکل جسمی دارم که تو اینقدر دوس نداری رابطه با منو. اصن باشگاه رفتن رو به همین خاطر شروع کردم. حتی امروز به همین خاطر رفتم آرایشگاه ولی خب اصن داشتم راه رو اشتباه می‌رفتم. نه که اونا مهم نبودا. نه. خوشحالم اتفاقا که به خودم می‌رسم ولی فکر می‌کردم خب نازنین می‌دونه من دوستش دارم دیگه. می‌دونه من چقدر سختی کشیدم که بهش برسم. می‌بینه چقدر دارم تلاش می‌کنم برای زندگی‌مون. بعدشم خب متاهلیم دیگه. سکس یه بخش مهمی از رابطه متاهلیه دیگه. اونم که رضایت داده زن من باشه که. ولی خب خیلی اشتباه می‌کردم. دوست داشتن تنها چیزیه که فراموش نمی‌شه ولی هر لحظه باید یادآوری‌ش کرد. باید مراقبش بود. مث یه گل. مرسی که حرفاتو بهم گفتی. راستشو بگم؟ من با بوی موهات عاشقت شدم. من دوست دارم زل بزنم به چشات. من عاشق اینم که راه رفتنت رو تماشا کنم. من با لباس خونگی هم دوستت دارم قشنگم. من می‌میرم برای اون وقتایی که تو بغل منی. تو بغلم بمون. باشه؟
// ۷
// شب، داخلی، اتاق خواب، دوستت دارم
// اول راهی که به تخت‌‌خوابتان در اتاق ختم می‌شود، بوسه‌ای است روی کاناپه اتاق پذیرایی‌تان.
// شما چه فکر می‌کنید؟ تجربه شما چیست؟ آیا برای شما رابطه جنسی، صرفا یک نیاز بدنی است یا نوعی جوشش، بعد از آنکه فهمدید کسی را دوست دارید؟
//
//
//
// ''';

class ShareExperienceCommentWidget extends GetWidget<ReplyController> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ShareExperienceCommentModel comment;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final bool hasDeletePlaceholder;
  final bool hasReplayPlaceHolder;
  final void Function(String? id)? onProfilePressed;
  final void Function(ShareExperienceCommentModel model)? onComment;
  final void Function(ShareExperienceCommentModel model)? onMoreMenuPressed;
  final void Function(ShareExperienceCommentModel model)? onLike;
  final void Function(ShareExperienceCommentModel model)? onDislike;
  final void Function(ShareExperienceCommentModel model)? onDeletePressed;
  final void Function(ShareExperienceCommentModel model, AnimatedListState animatedList)? onReplyPressed;
  final void Function(ShareExperienceCommentModel model, ShareExperienceCommentModel reply)? onReplyLikePressed;
  final void Function(ShareExperienceCommentModel model, ShareExperienceCommentModel reply)? onReplyDislikePressed;
  final void Function(ShareExperienceCommentModel model, ShareExperienceCommentModel reply, Function(int) onRemoved)? onReplyDeletePressed;

  ShareExperienceCommentWidget({
    super.key,
    required this.comment,
    this.onLike,
    this.onDislike,
    this.onComment,
    this.backgroundColor,
    this.padding,
    this.onDeletePressed,
    this.onReplyPressed,
    this.onReplyLikePressed,
    this.onReplyDislikePressed,
    this.onReplyDeletePressed,
    this.onProfilePressed,
    this.onMoreMenuPressed,
    this.hasDeletePlaceholder = true,
    this.hasReplayPlaceHolder = false,
  });

  AnimatedListState? get _animatedList => _listKey.currentState;

  Widget _buildRemovedItem(ShareExperienceCommentModel reply, BuildContext context, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: ShareExperienceCommentWidget(comment: reply),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: padding,
          decoration: ShapeDecoration(
            color: backgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => comment.selfExperience ? () {} : onProfilePressed?.call(comment.userId),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: ShapeDecoration(
                    color: context.colorScheme.surface,
                    shape: const CircleBorder(),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(comment.avatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => comment.selfExperience ? () {} : () => onProfilePressed?.call(comment.userId),
                      child: Row(
                        children: [
                          Text(
                            comment.name!,
                            style: context.textTheme.labelMedium,
                          ),
                          const SizedBox(width: 8.0),
                          if (comment.approvedProfile)
                            SvgPicture.asset(
                              AssetPaths.verifyTick,
                              height: 16,
                              width: 16,
                            ),
                          const Spacer(),
                          Text(
                            '${comment.createTime.toNowText} ${comment.topicName != null && comment.topicName!.isNotEmpty ? '.' : ''} ${comment.topicName ?? ''}',
                            style: context.textTheme.labelSmall?.copyWith(color: context.colorScheme.outline),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onComment?.call(comment),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (comment.biography.isNotEmpty) const SizedBox(height: 4),
                          if (comment.biography.isNotEmpty)
                            Text(
                              comment.biography,
                              style: context.textTheme.bodySmall,
                            ),
                          const SizedBox(height: 8),
                          Text(
                            comment.text!,
                            style: context.textTheme.bodySmall,
                          ),
                          if (comment.image != null && comment.image!.isNotEmpty) const SizedBox(height: 8),
                          if (comment.image != null && comment.image!.isNotEmpty)
                            AspectRatio(
                              aspectRatio: 1,
                              child: ImageWidget(
                                imageUrl: comment.image!,
                                fit: BoxFit.cover,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (onReplyPressed != null)
                                Expanded(
                                  child: ElevatedButtonIcon(
                                    color: ButtonColors.surface,
                                    size: ButtonSizes.small,
                                    onPressed: () => onReplyPressed?.call(comment, _animatedList!),
                                    label: Text(
                                      'پاسخ',
                                      style: context.textTheme.labelSmallProminent,
                                    ),
                                    icon: SvgPicture.asset(
                                      AssetPaths.reply,
                                      color: context.colorScheme.outline,
                                    ),
                                  ),
                                )
                              else if (hasReplayPlaceHolder)
                                const Spacer()
                              else
                                const SizedBox(),
                              if (comment.commentCount == null) const SizedBox(width: 20),
                              Expanded(
                                child: Obx(
                                  () => GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: comment.state != null && !comment.selfExperience ? () => onLike?.call(comment) : null,
                                    child: Row(
                                      children: [
                                        Opacity(
                                          opacity: comment.selfExperience ? 0.3 : 1,
                                          child: SvgPicture.asset(
                                            comment.state?.value == ExperienceActionState.like ? AssetPaths.likeFill : AssetPaths.like,
                                            height: 20,
                                            width: 20,
                                            color: comment.state?.value == ExperienceActionState.like
                                                ? context.colorScheme.primary
                                                : context.colorScheme.outline,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            comment.likeCount.value.toString(),
                                            style: context.textTheme.bodyLarge,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // const Spacer(),
                              Expanded(
                                child: Obx(
                                  () => GestureDetector(
                                    onTap: comment.state != null && !comment.selfExperience ? () => onDislike?.call(comment) : null,
                                    behavior: HitTestBehavior.opaque,
                                    child: Row(
                                      mainAxisAlignment: onDeletePressed != null && comment.selfExperience
                                          ? MainAxisAlignment.start
                                          : MainAxisAlignment.end,
                                      children: [
                                        Opacity(
                                          opacity: comment.selfExperience ? 0.3 : 1,
                                          child: SvgPicture.asset(
                                            comment.state?.value == ExperienceActionState.dislike
                                                ? AssetPaths.dislikeFill
                                                : AssetPaths.dislike,
                                            height: 20,
                                            width: 20,
                                            color: comment.state?.value == ExperienceActionState.dislike
                                                ? context.colorScheme.primary
                                                : context.colorScheme.outline,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              comment.disliked.value.toString(),
                                              style: context.textTheme.bodyLarge,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // if (comment.commentCount != null && onComment != null) const Spacer(),
                              if (comment.commentCount != null && onComment != null)
                                Expanded(
                                  child: Obx(
                                    () => Row(
                                      mainAxisAlignment: onDeletePressed != null && comment.selfExperience
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(AssetPaths.message),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            comment.commentCount.toString(),
                                            style: context.textTheme.bodyLarge,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              // if (hasDeletePlaceholder || onDeletePressed != null && comment.selfExperience) const Spacer(),
                              if (onDeletePressed != null && comment.selfExperience)
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: GestureDetector(
                                    onTap: () => onDeletePressed?.call(comment),
                                    child: SvgPicture.asset(
                                      AssetPaths.trash,
                                      height: 20,
                                      width: 20,
                                      color: context.colorScheme.outline,
                                    ),
                                  ),
                                )
                              else if(onMoreMenuPressed != null)
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => onMoreMenuPressed?.call(comment),
                                    child: Icon(
                                      Icons.more_vert_rounded,
                                      size: 20,
                                      color: context.colorScheme.outline,
                                    ),
                                  ),
                                )
                              else if (hasDeletePlaceholder)
                                  const SizedBox(width: 20, height: 20)
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    if (onReplyPressed != null)
                      controller.obx(
                        (_) => AnimatedList(
                          key: _listKey,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          initialItemCount: comment.replies.length,
                          itemBuilder: (BuildContext context, int index, animation) => ShareExperienceCommentWidget(
                            comment: comment.replies[index],
                            onLike: (reply) => onReplyLikePressed?.call(comment, reply),
                            onDislike: (reply) => onReplyDislikePressed?.call(comment, reply),
                            hasDeletePlaceholder: false,
                            hasReplayPlaceHolder: true,
                            onProfilePressed: onProfilePressed,
                            onDeletePressed: (reply) => onReplyDeletePressed?.call(
                              comment,
                              reply,
                              (index) => _animatedList?.removeItem(
                                index,
                                (context, animation) => _buildRemovedItem(reply, context, animation),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
        controller.obx((_) {
          if (comment.replies.isNotEmpty && comment.remainReplyCount > 0) {
            return Obx(
              () => SizedBox(
                child: controller.isPaginationLoading.value
                    ? Center(child: LoadingIndicatorWidget(color: context.colorScheme.primary))
                    : GestureDetector(
                        onTap: () => controller.getMoreReplies(comment, _animatedList!),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 24,
                              child: Divider(
                                color: context.colorScheme.outline,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'مشاهده ${comment.remainReplyCount} پاسخ به ${comment.name}',
                              style: context.textTheme.labelSmallProminent?.copyWith(color: context.colorScheme.primary),
                            ),
                          ],
                        ),
                      ),
              ),
            );
          } else {
            return const SizedBox();
          }
        })
      ],
    );
  }
}
