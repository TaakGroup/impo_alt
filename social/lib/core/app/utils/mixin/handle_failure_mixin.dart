import 'package:get/get.dart';
import 'package:taakitecture/taakitecture.dart';
import '../../view/pages/network_failure_page.dart';

mixin HandleFailureMixin<Model> on BaseController<Model> {
  static final Set<FailedService> listOfServicesNeedReloaded = {};
  static final List<String> routes = [];
  static bool isSheetOpen = false;

  @override
  onFailure(String id, Failure failure, Function service) {
    final FailedService failedService = FailedService(id: id, service: service, failure: failure, rout: Get.currentRoute);
    listOfServicesNeedReloaded.add(failedService);
    if (!isSheetOpen) failureSheet(failure);
  }

  _retry() {
    for (FailedService failedService in listOfServicesNeedReloaded) {
      failedService.service.call();
    }

    listOfServicesNeedReloaded.clear();
    Get.back();
  }

  failureSheet(Failure failure) async {
    isSheetOpen = true;

    await NetworkFailureSheet.show(failure, _retry);

    isSheetOpen = false;
  }

  static onRouteChange(Routing? routing) {
    if (routing != null) {
      if (routing.isBack!) {
        onPop(routes.last);
        routes.removeLast();
      } else {
        routes.add(routing.current);
      }
    }
  }

  static void onPop(String rout) {
    listOfServicesNeedReloaded.removeWhere((element) => element.rout == rout);
  }
}

class FailedService {
  final String id;
  final Function service;
  final Failure failure;
  final String rout;

  FailedService({required this.id, required this.service, required this.failure, required this.rout});

  @override
  bool operator ==(Object other) => other is FailedService && other.runtimeType == runtimeType && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
