import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../models/subscribe/custom_indicator_model.dart';
import 'custom_page_indicator_row.dart';

class CarouselSliderWithIndicator extends StatefulWidget {
  final Widget Function(BuildContext, int, int)? itemBuilder;
  final int? itemCount;
  final Color? indicatorColor;

  const CarouselSliderWithIndicator({Key? key,this.itemBuilder,this.itemCount,this.indicatorColor})
      : super(key: key);

  @override
  State<CarouselSliderWithIndicator> createState() => _CarouselSliderWithIndicatorState();
}

class _CarouselSliderWithIndicatorState extends State<CarouselSliderWithIndicator> {
  List<CustomIndicatorModel> indicatorsList = [];
  late CarouselSliderController controller;

  @override
  void initState() {
    controller = CarouselSliderController();
    updateIndicatorList(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setWidth(16)),
      child: Column(children: [
        CarouselSlider.builder(
          carouselController: controller,
          itemBuilder: widget.itemBuilder,
          itemCount: widget.itemCount,
          options: CarouselOptions(
              height: MediaQuery.of(context).size.height/5,
              viewportFraction: 1,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              onPageChanged: (index, reason) {
                updateIndicatorList(index);
              }),
        ),
        if (widget.itemCount! > 1)
          Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setWidth(16)),
              child: CustomPageIndicatorRow(
                indicatorsList: indicatorsList,
              )),
      ]),
    );
  }

  void updateIndicatorList(int selectedIndex) {
    int i = 0;
    indicatorsList.clear();
    while (i < widget.itemCount!) {
      CustomIndicatorModel indicator =
          CustomIndicatorModel(color: widget.indicatorColor, isSelected: i == selectedIndex);
      indicatorsList.add(indicator);
      i++;
    }
    setState(() {});
  }
}
