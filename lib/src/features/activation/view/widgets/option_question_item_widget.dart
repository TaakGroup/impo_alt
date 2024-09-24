import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/components/circle_check_radio_widget.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:impo/src/core/app/view/widgets/animations/expanded_section.dart';
import 'package:impo/src/features/activation/data/models/questions_page_model.dart';

class OptionQuestionItemWidget extends StatelessWidget {
  final OptionsQuestionsPageModel item;
  final void Function()? onTap;
   OptionQuestionItemWidget({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Obx(
          ()=> AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
            padding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 10
            ),
            margin: EdgeInsets.only(
                bottom: 8,
            ),
            decoration: BoxDecoration(
                color: item.selected.value ?
                Color(0xffFFEBF2):context.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: item.selected.value ? context.colorScheme.primary : Colors.transparent
                )
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleCheckRadioWidget(
                      isSelected: item.selected.value,
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.text,
                            style: context.textTheme.labelMedium,
                          ),
                          ExpandedSection(
                            child: Column(
                              children: [
                                Divider(color: Color(0xffFFD2E2)),
                                Text(
                                  item.description,
                                  style: context.textTheme.bodySmall,
                                ),
                              ],
                            ),
                            expand: item.selected.value && item.description != '',
                          )
                          // item.selected.value && item.description != '' ?
                          // Column(
                          //   children: [
                          //     Divider(color: Color(0xffFFD2E2)),
                          //     Text(
                          //       item.description,
                          //       style: context.textTheme.bodySmall,
                          //     ),
                          //   ],
                          // ) : SizedBox.shrink(),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            )
          ),
      )
    );
  }
}
