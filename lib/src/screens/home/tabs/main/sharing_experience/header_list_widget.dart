import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/sharing_experience_presenter.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_button.dart';



class HeaderListWidget extends StatefulWidget{
  final SharingExperiencePresenter? sharingExperiencePresenter;
  final Function(int)? onPress;

  HeaderListWidget({Key? key,this.sharingExperiencePresenter,this.onPress}):super(key:key);

  @override
  State<StatefulWidget> createState() => HeaderListWidgetState();
}

class HeaderListWidgetState extends State<HeaderListWidget>{
  
  @override
  Widget build(BuildContext context) {
    return !widget.sharingExperiencePresenter!.headerItems[0].selected!
          && !widget.sharingExperiencePresenter!.headerItems[1].selected!?
    SizedBox.shrink()
    : Padding(
      padding:  EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(20)
      ),
      child: Row(
        children: List.generate(widget.sharingExperiencePresenter!.headerItems.length, (index) =>
            Padding(
              padding:  EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(10)
              ),
              child: CustomButton(
                title: widget.sharingExperiencePresenter!.headerItems[index].title,
                onPress: (){
                  widget.onPress!(index);
                },
                height: ScreenUtil().setWidth(70),
                colors: widget.sharingExperiencePresenter!.headerItems[index].selected! ?
                [ColorPallet().mainColor,ColorPallet().mainColor] :
                [Color(0xffF8F8F8),Color(0xffF8F8F8)],
                borderRadius: 20.0,
                textColor: widget.sharingExperiencePresenter!.headerItems[index].selected! ? Colors.white : Color(0xff4B454D),
                enableButton: true,
                isLoadingButton: false,
                margin: 0,
              ),
            ),
        ),
      ),
    );
  }

}