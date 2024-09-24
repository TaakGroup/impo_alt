import 'package:flutter/material.dart';
import 'package:impo/src/screens/home/tabs/partnerTab/widgets/partner_custom_indicator_circle.dart';

import '../../../../../models/partner/partner_custom_indicator_model.dart';


class PartnerCustomPageIndicatorRow extends StatelessWidget {
  final List<PartnerCustomIndicatorModel>? indicatorsList;

  const PartnerCustomPageIndicatorRow({Key? key,this.indicatorsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: createItems(indicatorsList!));
  }

  List<PartnerCustomIndicatorCircle> createItems(List<PartnerCustomIndicatorModel> models) {
    List<PartnerCustomIndicatorCircle> items = [];
    items = models
        .map((item) => PartnerCustomIndicatorCircle(
              onPressed: item.onPressed,
              size: item.size,
              color: item.color,
              isSelected: item.isSelected,
            ))
        .toList();
    return items;
  }
}
