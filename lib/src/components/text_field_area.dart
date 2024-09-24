

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:characters/characters.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TextFieldArea extends StatefulWidget{

  final label;
  final textController;
  final readOnly;
  final editBox;
  final onPressEdit;
  final icon;
  final maxLength;
  final topMargin;
  final bottomMargin;
  final obscureText;
  final keyboardType;
  final notFlex;
  final focusNode;
  final inputFormatters;
  final inputReminder;
  final onChanged;
  final textColor;
  final isActivePass;
  final isEmail;
  final color;
  final onHoldObscureText;

  TextFieldArea({Key? key,this.label,this.textController,this.readOnly,this.editBox,this.onPressEdit,this.icon,
    this.maxLength,this.topMargin,this.bottomMargin,this.obscureText,this.keyboardType,this.notFlex,this.focusNode,
    this.inputFormatters,this.inputReminder,this.onChanged,this.textColor,this.isActivePass,this.isEmail,this.color,this.onHoldObscureText}):super(key:key);

  @override
  State<StatefulWidget> createState() => TextFieldAreaState();

}

class TextFieldAreaState extends State<TextFieldArea> with TickerProviderStateMixin{

  late AnimationController animationControllerScaleButton;
  Animations _animations =  Animations();

  @override
  void initState() {
    animationControllerScaleButton = _animations.pressButton(this);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return widget.notFlex == null
        ? Flexible(
        child:  Padding(
            padding: EdgeInsets.only(
              right: ScreenUtil().setWidth(30),
              left: ScreenUtil().setWidth(30),
              bottom: ScreenUtil().setWidth(widget.bottomMargin),
              top: ScreenUtil().setWidth(widget.topMargin),
            ),
            child:  Container(
                height: ScreenUtil().setWidth(90),
                child:  Stack(
                  alignment: Alignment.centerLeft,
                  children: <Widget>[
                    Theme(
                      data: Theme.of(context).copyWith(
                        textSelectionTheme: TextSelectionThemeData(
                            selectionColor: Color(0xffaaaaaa),
                            cursorColor: ColorPallet().mainColor
                        ),
                      ),
                      child:  TextField(
                        inputFormatters: widget.inputFormatters,
                        focusNode: widget.focusNode,
                        keyboardType: widget.keyboardType,
                        maxLength: widget.maxLength,
                        readOnly: widget.readOnly,
                        controller: widget.textController,
                        obscureText: widget.obscureText,
                        style:  context.textTheme.bodySmall!.copyWith(
                          color: ColorPallet().mainColor
                        ),
                        decoration:  InputDecoration(
                          counterText: '',
                          labelText: widget.label,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorPallet().gray.withOpacity(0.3)
                            ),
                          ),
                          labelStyle: context.textTheme.labelMedium!.copyWith(
                              color: ColorPallet().mainColor
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorPallet().gray.withOpacity(0.3)
                            ),
                          ),
                          hintStyle: context.textTheme.labelSmall,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorPallet().gray.withOpacity(0.3)
                            ),
                          ),
                          contentPadding: EdgeInsets.only(
                              bottom: ScreenUtil().setWidth(25),
                              top: ScreenUtil().setWidth(35),
                              right: ScreenUtil().setWidth(20),
                              left: widget.icon != null ? ScreenUtil().setWidth(190) : ScreenUtil().setWidth(20)
                          ),
                        ),
                      ),
                    ),
                    widget.editBox ?
                    StreamBuilder(
                      stream: _animations.squareScaleBackButtonObserve,
                      builder: (context,AsyncSnapshot<double> snapshotScale){
                        if(snapshotScale.data!= null){
                          return Transform.scale(
                            scale: snapshotScale.data,
                            child:  GestureDetector(
                              onTap: ()async{
                                await animationControllerScaleButton.reverse();
                                widget.onPressEdit();
                              },
                              child:   Container(
                                margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(15)
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: ScreenUtil().setWidth(8)
                                ),
                                width: MediaQuery.of(context).size.width/4.5,
                                decoration:  BoxDecoration(
                                    color: ColorPallet().gray.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child:  Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SvgPicture.asset(
                                      'assets/images/ic_edit.svg',
                                      width: ScreenUtil().setWidth(35),
                                      height: ScreenUtil().setWidth(35),
                                    ),
                                    SizedBox(width: ScreenUtil().setWidth(10)),
                                    Text(
                                      'ویرایش',
                                      style:  context.textTheme.labelMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }else{
                          return  Container();
                        }
                      },
                    )
                        :
                    widget.icon != null
                        ?
                    Container(
                      margin: EdgeInsets.only(
                          left: ScreenUtil().setWidth(30)
                      ),
                      height: ScreenUtil().setWidth(45),
                      width: ScreenUtil().setWidth(45),
                      child:   SvgPicture.asset(
                        widget.icon,
                        color: widget.color != null ? widget.color : null,
                      ),
                    )
                        :
                    widget.isActivePass != null
                        ?
                    widget.isActivePass :
                    Container()
                  ],
                )
            )
        )
    )  :
    Padding(
        padding: EdgeInsets.only(
          right: widget.inputReminder != null ? 0 : ScreenUtil().setWidth(55),
          left: widget.inputReminder != null ? 0 : ScreenUtil().setWidth(55),
          bottom: ScreenUtil().setWidth(widget.bottomMargin),
          top: ScreenUtil().setWidth(widget.topMargin),
        ),
        child:  Container(
            height: ScreenUtil().setWidth(90),
            child:  Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
                Theme(
                  data: Theme.of(context).copyWith(
                    textSelectionTheme: TextSelectionThemeData(
                        selectionColor: Color(0xffaaaaaa),
                        cursorColor: ColorPallet().mainColor
                    ),
                  ),
                  child:  TextField(
                    autocorrect: false,
                    onChanged: (value){
                      widget.inputReminder != null ? widget.onChanged(value) : value;
                    },
                    maxLines: widget.isEmail != null ? null : 1,
                    minLines: widget.isEmail != null ? 1 : null,
                    textAlign: TextAlign.right,
                    inputFormatters: widget.inputFormatters,
                    focusNode: widget.focusNode,
                    keyboardType: widget.keyboardType,
                    maxLength: widget.maxLength,
                    readOnly: widget.readOnly,
                    controller: widget.textController,
                    obscureText: widget.obscureText,
                    style:  context.textTheme.bodySmall!.copyWith(
                        color: ColorPallet().mainColor
                    ),
                    decoration:  InputDecoration(
                      counterText: '',
                      labelText: widget.label,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: ColorPallet().gray.withOpacity(0.3)
                        ),
                      ),
                      labelStyle: context.textTheme.labelMedium!.copyWith(
                        color: ColorPallet().mainColor
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: ColorPallet().gray.withOpacity(0.3)
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: ColorPallet().gray.withOpacity(0.3)
                        ),
                      ),
                      contentPadding: EdgeInsets.only(
                          bottom: ScreenUtil().setWidth(25),
                          top: ScreenUtil().setWidth(35),
                          right: ScreenUtil().setWidth(20),
                          left: widget.icon != null ? ScreenUtil().setWidth(190) : ScreenUtil().setWidth(20)
                      ),
                    ),
                  ),
                ),
                widget.editBox ?
                StreamBuilder(
                  stream: _animations.squareScaleBackButtonObserve,
                  builder: (context,AsyncSnapshot<double> snapshotScale){
                    if(snapshotScale.data!= null){
                      return Transform.scale(
                        scale: snapshotScale.data,
                        child:  GestureDetector(
                          onTap: ()async{
                            await animationControllerScaleButton.reverse();
                            widget.onPressEdit();
                          },
                          child:   Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(15)
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setWidth(8)
                            ),
                            width: MediaQuery.of(context).size.width/4.5,
                            decoration:  BoxDecoration(
                                color: ColorPallet().gray.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  'assets/images/ic_edit.svg',
                                  width: ScreenUtil().setWidth(35),
                                  height: ScreenUtil().setWidth(35),
                                ),
                                SizedBox(width: ScreenUtil().setWidth(10)),
                                Text(
                                  'ویرایش',
                                    style: context.textTheme.labelMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }else{
                      return  Container();
                    }
                  },
                )
                    :
                widget.icon != null
                    ?
                    GestureDetector(
                      onTap: (){
                        widget.onHoldObscureText();
                      },
                      child:  Container(
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(30)
                        ),
                        height: ScreenUtil().setWidth(45),
                        width: ScreenUtil().setWidth(45),
                        child:   SvgPicture.asset(
                          widget.icon,
                          color: widget.color != null ? widget.color : null,
                        ),
                      )
                    )
                    :
                widget.isActivePass != null
                    ?
                widget.isActivePass :
                Container()
              ],
            )
        )
    );
  }

}

class LengthLimitingTextFieldFormatterFixed
    extends LengthLimitingTextInputFormatter {
  LengthLimitingTextFieldFormatterFixed(int maxLength) : super(maxLength);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue Value,
      ) {
    if (maxLength != null &&
        maxLength! > 0 &&
        Value.text.characters.length > maxLength!) {
      // If already at the maximum and tried to enter even more, keep the old
      // value.
      if (oldValue.text.characters.length == maxLength) {
        return oldValue;
      }
      // ignore: invalid_use_of_visible_for_testing_member
      return LengthLimitingTextInputFormatter.truncate(Value, maxLength!);
    }
    return Value;
  }
}
