import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/view/widgets/design_size_figma.dart';
import '../../../../core/app/constans/assets_paths.dart';
import '../../controller/index_controller.dart';
import '../widgets/cycle_widget.dart';
import '../widgets/loading_shimmer_widgets.dart';
import '../widgets/main_app_bar.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DesignSizeFigma(
      builder: (context) => Container(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: MainAppBar(
            title: IndexController.to.obx(
              (state) => Obx(
                () => AnimatedOpacity(
                  opacity: IndexController.to.showAppbarTitle.value ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 200),
                  child: Text(
                    IndexController.to.appbarTitle.value,
                    style: context.textTheme.bodySmall,
                  ),
                ),
              ),
              onLoading: SizedBox(),
            ),
          ),
          body: SingleChildScrollView(
            controller: IndexController.to.scroll,
            child: Column(
              children: [
                Obx(
                  () => CycleWidget(
                    headline: IndexController.to.appbarTitle.value,
                    onActionPressed: IndexController.to.onAction,
                  ),
                ),
                Obx(
                  () => AnimatedContainer(
                    curve: Curves.fastOutSlowIn,
                    duration: Duration(milliseconds: 2000),
                    color: IndexController.to.backgroundColor.value,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          repeat: ImageRepeat.noRepeat,
                          alignment: Alignment.topCenter,
                          fit: BoxFit.fitWidth,
                          image: AssetImage(AssetPaths.backgroundGradient),
                        ),
                      ),
                      child: IndexController.to.obx(
                        (widgets) => ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(bottom: 32, top: 16),
                          shrinkWrap: true,
                          itemBuilder: (_, index) => widgets![index],
                          separatorBuilder: (_, index) => SizedBox(height: 16),
                          itemCount: widgets.length,
                        ),
                        onLoading: LoadingShimmerWidget(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
