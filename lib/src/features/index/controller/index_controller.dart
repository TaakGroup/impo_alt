import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/features/index/controller/cycle_controller.dart';
import 'package:impo/src/features/index/controller/action_controller.dart';
import 'package:impo/src/features/index/data/models/action_model.dart';
import 'package:impo/src/features/index/data/models/articles_widget_model.dart';
import 'package:impo/src/features/index/data/models/base_widget_model.dart';
import 'package:impo/src/features/index/data/models/cycle_widget_model.dart';
import 'package:impo/src/features/index/data/models/prediction_widget_model.dart';
import 'package:impo/src/features/index/view/widgets/articles_widget.dart';
import 'package:impo/src/features/index/view/widgets/report_empty_state_widget.dart';
import 'package:impo/src/features/index/view/widgets/reports_widget.dart';
import 'package:impo/src/features/index/view/widgets/stories_widget.dart';
import 'package:social/core/app/utils/mixin/handle_failure_mixin.dart';
import 'package:taakitecture/taakitecture.dart';
import '../data/models/hint_widget_model.dart';
import '../data/models/index_model.dart';
import '../data/models/pregnancy_widget_model.dart';
import '../data/models/report_empty_state_widget_model.dart';
import '../data/models/reports_widget_model.dart';
import '../data/models/story_widget_model.dart';
import '../data/models/subscription_widget_model.dart';
import '../data/repositories/index_repository.dart';
import '../view/widgets/hints_widget.dart';
import '../view/widgets/prediction_widget.dart';
import '../view/widgets/pregnancy_widget.dart';
import '../view/widgets/subscription_widget.dart';

class IndexController extends BaseController with HandleFailureMixin {
  Rx<Color> backgroundColor = Colors.white.obs;
  RxBool showAppbarTitle = false.obs;
  RxString appbarTitle = "".obs;
  ScrollController scroll = ScrollController();

  IndexController(IndexRepository super.remoteRepository);

  static IndexController get to => Get.find();

  @override
  void onInit() {
    getIndex();
    scroll.addListener(() => showAppbarTitle.value = scroll.offset > 32);

    super.onInit();
  }

  getIndex() => find();

  @override
  Duration get minimumLoadingTime => Duration(seconds: 10);

  @override
  onLoading() {
    CycleController.to.onLoading();
    backgroundColor.value = Colors.white;

    return super.onLoading();
  }

  List<Widget> getWidgetsFromModels(List<BaseWidgetModel> widgets) {
    final List<Widget> list = [];

    for (var model in widgets) {
      switch (model.type) {
        case WidgetType.cycle:
          CycleController.to.updateCycle(model.data as CycleWidgetModel);
          break;
        case WidgetType.story:
          list.add(StoriesWidget(model: model.data as StoryWidgetModel));
          break;
        case WidgetType.hint:
          list.add(HintsWidget(model: model.data as HintWidgetModel));
          break;
        case WidgetType.prediction:
          list.add(PredictionWidget(model: model.data as PredictionWidgetModel));
          break;
        case WidgetType.article:
          list.add(ArticlesWidget(model: model.data as ArticlesWidgetModel));
          break;
        case WidgetType.report:
          list.add(ReportsWidget(model: model.data as ReportsWidgetModel));
          break;
        case WidgetType.reportEmpty:
          list.add(ReportEmptyStateWidget(model: model.data as ReportEmptyStateWidgetModel));
          break;
        case WidgetType.pregnancy:
        case WidgetType.breastfeeding:
          list.add(PregnancyWidget(model: model.data as PregnancyWidgetModel));
          break;
        case WidgetType.subscription:
          list.add(SubscriptionWidget(model: model.data as SubscriptionWidgetModel, onActionPressed: onAction, onSubmitPressed: onAction));
          break;
      }
    }

    return list;
  }

  @override
  onSuccess(result) {
    backgroundColor.value = result.background;
    appbarTitle.value = result.headline;
    ActionController.to.popupHandler(result.actions, then: getIndex);

    return super.onSuccess(getWidgetsFromModels(result.widgets));
  }

  onAction(ActionModel action) async {
    await ActionController.to.actionHandler(action);
    getIndex();
  }
}
