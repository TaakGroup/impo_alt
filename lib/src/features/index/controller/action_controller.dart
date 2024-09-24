import 'package:get/get.dart';
import 'package:impo/src/features/index/data/models/action_model.dart';
import 'package:impo/src/features/index/data/models/dialog_model.dart';
import 'package:impo/src/features/index/data/models/interaction_sheet_model.dart';
import 'package:impo/src/features/index/view/overlays/interaction_sheet.dart';
import 'package:social/core/app/utils/mixin/handle_failure_mixin.dart';
import 'package:taakitecture/taakitecture.dart';

import '../data/models/base_popup_model.dart';
import '../data/models/multi_option_sheet_model.dart';
import '../view/overlays/interaction_dialog.dart';
import '../view/overlays/multi_option_sheet.dart';

class ActionController extends BaseController with HandleFailureMixin {
  ActionController(super.remoteRepository);

  static ActionController get to => Get.find();

  onInit() {
    change(null, status: RxStatus.success());

    super.onInit();
  }

  Future apiCall(final id) => find(id);

  Future internalRoutHandler(int internal) async {
    // TODO
    print('**************************************=> Internal Rout $internal');
    return await Future.delayed(Duration(seconds: 5));
  }

  Future popupHandler(List<BasePopupModel> list, {Function()? then}) async {
    for (var model in list) {
      switch (model.type) {
        case PopupType.multiOption:
          await showMultiOptionSheet(model.data as MultiOptionSheetModel);
          break;
        case PopupType.interaction:
          await showInteractionSheet(model.data as InteractionSheetModel, model.isDismissible);
          break;
        case PopupType.dialog:
          await showInteractionDialog(model.data as DialogModel, model.isDismissible);
          break;
      }
    }

    if (list.isNotEmpty) {
      then?.call();
    }
  }

  showInteractionDialog(DialogModel data, bool isDismissible) {
    return DialogInteraction.showDialog(
      state: this,
      firstAction: actionHandler,
      secondAction: actionHandler,
      data: data,
      isDismissible: isDismissible,
    );
  }

  Future showInteractionSheet(InteractionSheetModel data, bool isDismissible) {
    return InteractionSheet.showSheet(
      state: this,
      model: data,
      isDismissible: isDismissible,
      onSubmit: () => actionHandler(data.button.action),
    );
  }

  Future showMultiOptionSheet(MultiOptionSheetModel model) {
    Rx<OptionItemModel> selected = model.items.first.obs;

    return MultiOptionSheet.showSheet(
      state: this,
      model: model,
      selectedItem: selected,
      onItemSelected: (value) => selected.value = value,
      onSubmit: () => actionHandler(selected.value.action),
    );
  }

  actionHandler(ActionModel action) {
    switch (action.type) {
      case ActionType.None:
        return;
      case ActionType.InternalRout:
        return internalRoutHandler(action.internal!);
      case ActionType.ApiCall:
        return apiCall(action.api);
      case ActionType.NextStep:
        return popupHandler([action.popup!]);
      case ActionType.Done:
        return Get.back();
    }
  }

  @override
  onSuccess(result) {
    Get.back(result: true);
    return super.onSuccess(result);
  }
}
