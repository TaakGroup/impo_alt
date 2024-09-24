

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/packages/featureDiscovery/feature_discovery.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';

class TabTarget extends StatelessWidget {

  final id;
  final icon;
  final title;
  final description;
  final child;
  final contentLocation;
  final alignTitle;
  final width;
  final height;
  final onOpen;

  TabTarget({this.id,this.icon,this.title,this.description,
    this.child,this.contentLocation,this.alignTitle,this.width,this.height,this.onOpen});

  @override
  Widget build(BuildContext context) {
    timeDilation = .5;
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return  new DescribedFeatureOverlay(
      featureId: id,
      width: width != null ? width : 2,
      height: height != null ? height : 2,
      pulseDuration: Duration(milliseconds: 1700),
      contentLocation: contentLocation,
      tapTarget: icon,
      backgroundColor: Color(0xff5c0240),
      title:  Align(
        alignment: alignTitle != null ? alignTitle : Alignment.centerRight,
        child: Text(
          title,
          style: context.textTheme.titleMedium!.copyWith(
            color: Colors.white,
          )
        ),
      ),
        onOpen: () async {
        if(onOpen != null){
          onOpen();
        }else{
          return true;
        }
        return true;
        },
        onComplete: () async {
          return true;
        },
        onDismiss: ()async{
           FeatureDiscovery.completeCurrentStep(context);
           FeatureDiscovery.completeCurrentStep(context);
           FeatureDiscovery.completeCurrentStep(context);
           FeatureDiscovery.completeCurrentStep(context);
           FeatureDiscovery.completeCurrentStep(context);
           FeatureDiscovery.completeCurrentStep(context);
           FeatureDiscovery.completeCurrentStep(context);
           return true;
        },
      description: Padding(
        padding:  EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(10)
        ),
        child: Text(
          description,
          textAlign: TextAlign.end,
          style:  context.textTheme.bodyLarge!.copyWith(
            color: Colors.white,
          )
        ),
      ),
      child: child
    );
  }


}