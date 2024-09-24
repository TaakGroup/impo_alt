import 'package:impo/src/features/index/data/models/articles_widget_model.dart';
import 'package:impo/src/features/index/data/models/cycle_widget_model.dart';
import 'package:impo/src/features/index/data/models/prediction_widget_model.dart';
import 'package:impo/src/features/index/data/models/pregnancy_widget_model.dart';
import 'package:impo/src/features/index/data/models/report_empty_state_widget_model.dart';
import 'package:impo/src/features/index/data/models/reports_widget_model.dart';
import 'package:impo/src/features/index/data/models/story_widget_model.dart';
import 'package:impo/src/features/index/data/models/subscription_widget_model.dart';
import 'package:taakitecture/taakitecture.dart';

import 'hint_widget_model.dart';
import 'index_model.dart';

abstract class BaseDataWidgetModel extends BaseModel with ModelMixin {
  late String title;
  late String description;

  static BaseDataWidgetModel fromType(WidgetType type, data) {
    switch (type) {
      case WidgetType.cycle:
        return CycleWidgetModel().fromJson(data);
      case WidgetType.hint:
        return HintWidgetModel().fromJson(data);
      case WidgetType.story:
        return StoryWidgetModel().fromJson(data);
      case WidgetType.prediction:
        return PredictionWidgetModel().fromJson(data);
      case WidgetType.article:
        return ArticlesWidgetModel().fromJson(data);
      case WidgetType.report:
        return ReportsWidgetModel().fromJson(data);
      case WidgetType.reportEmpty:
        return ReportEmptyStateWidgetModel().fromJson(data);
      case WidgetType.pregnancy:
      case WidgetType.breastfeeding:
        return PregnancyWidgetModel().fromJson(data);
      case WidgetType.subscription:
        return SubscriptionWidgetModel().fromJson(data);
    }
  }

  @override
  Map<String, dynamic> get properties => {
        'title': title,
        'description': description,
      };

  @override
  void setProp(String key, value) {
    switch (key) {
      case 'title':
        title = value;
        break;
      case 'description':
        description = value;
        break;
    }
  }
}
