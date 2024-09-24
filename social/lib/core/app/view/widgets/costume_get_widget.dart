import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_widget_cache.dart';

abstract class BaseCostumeGetWidget<S extends GetLifeCycleBase?> extends GetWidgetCache {
  void Function(S?) onInit = (_) {};

  BaseCostumeGetWidget({Key? key}) : super(key: key);

  @protected
  final String? tag = null;

  S get controller => BaseCostumeGetWidget._cache[this] as S;

  static final _cache = Expando<GetLifeCycleBase>();

  @protected
  Widget build(BuildContext context);

  @override
  WidgetCache createWidgetCache() => _CostumeGetCache<S>();
}

class _CostumeGetCache<S extends GetLifeCycleBase?> extends WidgetCache<BaseCostumeGetWidget<S>> {
  S? _controller;
  bool _isCreator = false;
  InstanceInfo? info;

  @override
  void onInit() {
    info = GetInstance().getInstanceInfo<S>(tag: widget!.tag);

    _isCreator = info!.isPrepared && info!.isCreate;

    if (info!.isRegistered) {
      _controller = Get.find<S>(tag: widget!.tag);

      if(info!.isCreate) widget?.onInit.call(_controller);
    }

    BaseCostumeGetWidget._cache[widget!] = _controller;
    super.onInit();
  }

  @override
  void onClose() {
    if (_isCreator) {
      Get.asap(() {
        widget!.controller!.onDelete();
        Get.log('"${widget!.controller.runtimeType}" onClose() called');
        Get.log('"${widget!.controller.runtimeType}" deleted from memory');
        BaseCostumeGetWidget._cache[widget!] = null;
      });
    }
    info = null;
    super.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return widget!.build(context);
  }
}

abstract class CostumeGetWidget<S extends GetLifeCycleBase?> extends BaseCostumeGetWidget<S> {
  CostumeGetWidget({super.key});

  @override
  void Function(S? controller) get onInit => onInitController;

  onInitController(S? controller) {}
}