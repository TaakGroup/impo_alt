import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:impo/src/screens/home/tabs/partnerTab/widgets/partner_custom_page_indicator_row.dart';
import '../../../../../models/partner/partner_custom_indicator_model.dart';
import '../../../../../models/partner/partner_slider_model.dart';

class PartnerCarouselSliderWithIndicator extends StatefulWidget {
  final Widget Function(BuildContext, int, int)? itemBuilder;
  final int? itemCount;
  final Color? indicatorColor;
  final index;

  const PartnerCarouselSliderWithIndicator({Key? key,this.itemBuilder,
    this.itemCount,this.indicatorColor,this.index})
      : super(key: key);

  @override
  State<PartnerCarouselSliderWithIndicator> createState() => _PartnerCarouselSliderWithIndicatorState();
}

class _PartnerCarouselSliderWithIndicatorState extends State<PartnerCarouselSliderWithIndicator> {
  List<PartnerCustomIndicatorModel> indicatorsList = [];
  late CarouselSliderController controller;
  int currentIndex = 0;
  @override
  void initState() {
    controller = CarouselSliderController();
    updateIndicatorList(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Stack(
      alignment: Alignment.bottomCenter,
        children: [
      CarouselSlider.builder(
        carouselController: controller,
        itemBuilder: widget.itemBuilder,
        itemCount: widget.itemCount,
        options: CarouselOptions(
            // height: MediaQuery.of(context).size.height/2.4,
            aspectRatio: 0.95,
            viewportFraction: 1,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, reason) {
              currentIndex = index;
              updateIndicatorList(index);
            }),
      ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: ScreenUtil().setWidth(50),
                left:ScreenUtil().setWidth(50),
              ),
              child: Text(
                  partnerSliderList[currentIndex].title!,
                  style: context.textTheme.titleSmall!.copyWith(
                    color: Colors.white
                  ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: ScreenUtil().setWidth(50),
                  left:ScreenUtil().setWidth(50),
              ),
              child: Text(
                partnerSliderList[currentIndex].subTitle!,
                style: context.textTheme.bodySmall!.copyWith(
                    color: Colors.white
                ),
              ),
            ),
            if(widget.itemCount! > 1)
              SizedBox(height: ScreenUtil().setWidth(10),),
            if (widget.itemCount! > 1)
              Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setWidth(16)),
                  child: PartnerCustomPageIndicatorRow(
                    indicatorsList: indicatorsList,
                  )
              ),
              SizedBox(height: ScreenUtil().setWidth(20),)
          ],
        )
    ]);
  }

  void updateIndicatorList(int selectedIndex) {
    int i = 0;
    indicatorsList.clear();
    while (i < widget.itemCount!) {
      PartnerCustomIndicatorModel indicator =
          PartnerCustomIndicatorModel(color: widget.indicatorColor, isSelected: i == selectedIndex);
      indicatorsList.add(indicator);
      i++;
    }
    setState(() {});
  }
}
