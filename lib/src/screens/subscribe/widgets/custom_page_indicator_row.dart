import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../models/subscribe/custom_indicator_model.dart';
import 'custom_indicator_circle.dart';

class CustomPageIndicatorRow extends StatelessWidget {
  final List<CustomIndicatorModel>? indicatorsList;

  const CustomPageIndicatorRow({Key? key,this.indicatorsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: ScreenUtil().setWidth(10),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: createItems(indicatorsList!)),
    );
  }

  List<CustomIndicatorCircle> createItems(List<CustomIndicatorModel> models) {
    List<CustomIndicatorCircle> items = [];
    items = models
        .map((item) => CustomIndicatorCircle(
              onPressed: item.onPressed,
              size: item.size,
              color: item.color,
              isSelected: item.isSelected,
            ))
        .toList();
    return items;
  }
}
