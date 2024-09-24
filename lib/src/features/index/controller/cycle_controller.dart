import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/app/constans/messages.dart';
import '../data/models/cycle_widget_model.dart';

class CycleController extends GetxController with GetTickerProviderStateMixin {
  late CycleWidgetModel cycle;

  late final AnimationController _successTextAnimationController;
  late final Animation<double> successTextAnimation;

  late final AnimationController _updatingTextAnimationController;
  late final Animation<double> updatingTextAnimation;

  late final AnimationController _waveAnimationPositionController;
  late final Animation<Offset> waveAnimationPosition;

  late final AnimationController _pulseController;
  late final Animation<double> pulseAnimation;

  late final AnimationController _lottieWaveAnimationController;
  late final Animation<double> lottieWaveAnimation;

  Rx<CrossFadeState> crossFade = CrossFadeState.showSecond.obs;
  RxString loadingText = "".obs;

  static CycleController get to => Get.find();

  @override
  Future<void> onInit() async {
    _initCycle();
    _initSuccessTextAnimation();
    _initUpdatingTextAnimation();
    _initWaveAnimationPositionController();
    _initUpdatingLottieAnimation();
    _initPulseAnimation();

    super.onInit();
  }

  onLoading() => _loadingAnimation();

  updateCycle(CycleWidgetModel result) {
    cycle = result;
    update();
    successAnimation();
  }

  _initCycle() {
    cycle = CycleWidgetModel()
      ..backgroundColor = Color(0xffFFF9F3)
      ..foregroundColor = Color(0xffF0C49B)
      ..textColor = Colors.transparent
      ..leading = ''
      ..title = ''
      ..description = ''
      ..buttons = [];
  }

  _initSuccessTextAnimation() {
    _successTextAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    successTextAnimation = CurvedAnimation(
      parent: _successTextAnimationController,
      curve: Curves.easeOutBack,
    );
  }

  _initUpdatingTextAnimation() {
    _updatingTextAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    updatingTextAnimation = CurvedAnimation(
      parent: _updatingTextAnimationController,
      curve: Curves.easeOutBack,
    );
  }

  _initWaveAnimationPositionController() {
    _waveAnimationPositionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    waveAnimationPosition = Tween<Offset>(
      begin: const Offset(0, -0.1),
      end: const Offset(0, 0.7),
    ).animate(
      CurvedAnimation(
        parent: _waveAnimationPositionController,
        curve: Curves.easeIn,
      ),
    );
  }

  _initUpdatingLottieAnimation() {
    _lottieWaveAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 3000));
    lottieWaveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_lottieWaveAnimationController);
  }

  _initPulseAnimation() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    pulseAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(_pulseController);
  }

  successAnimation() async {
    crossFade.value = CrossFadeState.showFirst;
    loadingText.value = Messages.successUpdate;
    _updatingTextAnimationController.forward(from: 0);
    await _waveAnimationPositionController.forward(from: 0);
    _updatingTextAnimationController.value = 0;
    _successTextAnimationController.forward();
  }

  _loadingAnimation() async {
    crossFade.value = CrossFadeState.showSecond;
    loadingText.value = Messages.loadingUpdate;
    _successTextAnimationController.value = 0;
    _lottieWaveAnimationController.forward(from: 0);
    _updatingTextAnimationController.forward();
    _pulseController.repeat(reverse: true);
    _successTextAnimationController.reverse();
  }

  @override
  void dispose() {
    _successTextAnimationController.dispose();
    _updatingTextAnimationController.dispose();
    _waveAnimationPositionController.dispose();
    _lottieWaveAnimationController.dispose();
    _pulseController.dispose();

    super.dispose();
  }
}
