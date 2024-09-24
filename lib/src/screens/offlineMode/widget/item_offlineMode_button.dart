

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';

class ItemOfflineModeButton extends StatefulWidget{

  final onPress;
  final title;
  final icon;

  ItemOfflineModeButton({Key? key,this.onPress,this.title,this.icon}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ItemOfflineModeButtonState();
}

class ItemOfflineModeButtonState extends State<ItemOfflineModeButton> with TickerProviderStateMixin{

  late AnimationController animationControllerScaleButton;

  Animations _animations =  Animations();


  @override
  void initState() {
    animationControllerScaleButton = _animations.pressButton(this);
    super.initState();
  }

  @override
  void dispose() {
    _animations.animationControllerScaleBackButton.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
      stream: _animations.squareScaleBackButtonObserve,
      builder: (context,AsyncSnapshot<double>snapshotScale){
        if(snapshotScale.data != null){
          return  Transform.scale(
            scale: snapshotScale.data,
            child:  GestureDetector(
              onTap: ()async{
                await animationControllerScaleButton.reverse();
                widget.onPress();
              },
              child:  Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(40),
                      vertical: ScreenUtil().setWidth(12)
                  ),
                  decoration:  BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Color(0xffCCCCCC)
                      ),
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: Center(
                      child :Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              widget.icon,
                              width: ScreenUtil().setWidth(45),
                              height: ScreenUtil().setWidth(45),
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: ScreenUtil().setWidth(20)),
                            Text(
                              widget.title,
                              textAlign: TextAlign.center,
                              style:  TextStyle(
                                color: ColorPallet().gray,
                                fontWeight: FontWeight.w400,
                                fontSize: ScreenUtil().setSp(30),
                              ),
                            ),
                          ]
                      )

                  )
              ),
            ),
          );
        }else{
          return  Container();
        }
      },

    );
  }

}