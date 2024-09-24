import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';

import '../../../../core/app/view/themes/styles/buttons/button_types.dart';
import '../../../../core/app/view/themes/styles/buttons/loading_button/elevation_loading_button.dart';
import '../../../../core/app/view/widgets/dialog/base_dialog.dart';
import '../../data/models/action_model.dart';
import '../../data/models/dialog_model.dart';

class DialogInteraction extends StatelessWidget {
  final StateMixin state;
  final DialogModel data;
  final Function(ActionModel action) firstAction;
  final Function(ActionModel action) secondAction;

  const DialogInteraction({
    super.key,
    required this.state,
    required this.data,
    required this.firstAction,
    required this.secondAction,
  });

  static showDialog({
    required StateMixin state,
    required Function(ActionModel) firstAction,
    required Function(ActionModel) secondAction,
    required DialogModel data,
    required bool isDismissible,
  }) {
    Get.dialog(
      DialogInteraction(
        state: state,
        data: data,
        firstAction: firstAction,
        secondAction: secondAction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      // title: data.title,
      description: data.description,
      actions: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: context.buttonThemes
                  .elevatedButtonStyle(
                    color: ButtonColors.surface,
                    wide: true,
                  )
                  ?.copyWith(elevation: WidgetStateProperty.all(0)),
              onPressed: () => firstAction.call(data.first.action),
              child: Text(data.first.text),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevationStateButton(
              elevation: 0,
              onPressed: () => secondAction.call(data.second.action),
              state: state,
              text: data.second.text,
              wide: true,
            ),
          ),
        ],
      ),
    );
  }
}
