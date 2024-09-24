

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/packages/flutterCupertinoDatePicker-1.0.26/flutter_cupertino_date_picker.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:shamsi_date/extensions.dart';
import 'package:shamsi_date/shamsi_date.dart';


// ignore: must_be_immutable
class Calender extends StatelessWidget{

   dynamic dateTime;
  // final TextEditingController controller;
  // final typeCalendar;
  final onChange;
  final isBirthDate;
  final Jalali? maxDate;
  final Jalali? minDate;


  /// typeCalendar ==>> 0=birthDay , 1=givingBirth , 2=lastPeriod , 3=تاریخ زایمان برای ورود به فاز شروع مادری

  Calender({Key? key,this.dateTime,this.onChange,this.isBirthDate,this.maxDate,this.minDate}) : super(key : key);


  // Jalali _dateTime;

  bool isApi19 = false;

  var registerInfo = locator<RegisterParamModel>();

  // @override
  // void initState() {
  //   // if(widget.mode == 0){
  //   //   _dateTime = Jalali(
  //   //       Jalali.now().year - 25,
  //   //       Jalali.now().month,
  //   //       Jalali.now().day
  //   //   );
  //   //   // widget.RegisterParamViewModel['birthDay'] = _dateTime.toString().replaceAll('Jalali', '').replaceAll('(', '').replaceAll(')', '');
  //   //
  //   //
  //   //   registerInfo.setBirthDay(_dateTime.toString().replaceAll('Jalali', '').replaceAll('(', '').replaceAll(')', ''));
  //   //
  //   // }else{
  //   //
  //   //   List date = widget.controller.text.split('/');
  //   //
  //   //
  //   //   _dateTime = Jalali(
  //   //       int.parse(date[0]),
  //   //       int.parse(date[1]),
  //   //       int.parse(date[2])
  //   //   );
  //   //
  //   // }
  //   super.initState();
  // }



  String format1(Date d) {
    final f = d.formatter;

    return '${f.wN} ${f.d} ${f.mN} ${f.yy}';
  }

  // Future<int> checkAndroidVersion()async{
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //   if(androidInfo.version.sdkInt <= 19){
  //     setState(() {
  //       isApi19 = true;
  //     });
  //   }else{
  //     setState(() {
  //       isApi19 = false;
  //     });
  //   }
  //   return androidInfo.version.sdkInt;
  // }

  @override
  Widget build(BuildContext context) {

    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return  Directionality(
        textDirection: TextDirection.ltr,
         child : NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: !isBirthDate &&  registerInfo.register.calendarType == 1 ?
          DatePickerWidget(
            locale: DateTimePickerLocale.en_fa,
            statusRegister: true,
            dateFormat: 'yyyy,MMMM,dd',
            // initialJalaliTime: dateTime,
            // maxDateJalaliTime: maxDate,
            // minDateJalaliTime: minDate,
            initialDateTime: dateTime.toDateTime(),
            minDateTime: minDate!.toDateTime(),
            maxDateTime: maxDate!.toDateTime(),
            isJalali: false,
            // maxDateJalaliTime: typeCalendar == 1 ?
            //     Jalali.fromDateTime( DateTime(
            //         DateTime.now().year,
            //         DateTime.now().month,
            //         DateTime.now().day + 280
            //     ))
            //     : typeCalendar == 2 ?
            //     Jalali.fromDateTime(
            //         DateTime(
            //             DateTime.now().year,
            //             DateTime.now().month,
            //             DateTime.now().day
            //         )
            //     )
            //     :
            // Jalali(
            //     Jalali.now().year - 6,
            //     12,
            //     29
            // ),
            //
            // minDateJalaliTime:
            // typeCalendar == 1 ?
            //     Jalali.fromDateTime(  DateTime(
            //         DateTime.now().year,
            //         DateTime.now().month,
            //         DateTime.now().day + 1
            //     ))
            //     : typeCalendar == 2 ?
            // Jalali.fromDateTime(
            //     DateTime(
            //         DateTime.now().year,
            //         DateTime.now().month,
            //         DateTime.now().day - 279
            //     )
            // )
            //     :
            // Jalali(
            //     Jalali.now().year - 65,
            //     1,
            //     1
            // ),
            // onChangeJalali: (currentDateTime, selectedIndex){
            //   dateTime = currentDateTime;
            //   if(onChange != null){
            //     onChange();
            //   }
            //   // print(currentDateTime);
            //   // setState(() {
            //   //   widget.dateTime = currentDateTime;
            //   //   // if(widget.mode == 0){
            //   //   //   //widget.RegisterParamViewModel['birthDay'] = _dateTime.toString().replaceAll('Jalali', '').replaceAll('(', '').replaceAll(')', '');
            //   //   //   registerInfo.setBirthDay(_dateTime.toString().replaceAll('Jalali', '').replaceAll('(', '').replaceAll(')', ''));
            //   //   // }else{
            //   //   //
            //   //   //   widget.controller.text = _dateTime.toString().replaceAll('Jalali', '').replaceAll('(', '').replaceAll(')', '').replaceAll(',','/');
            //   //   //
            //   //   // }
            //   //
            //   // });
            // },
            onChange: (currentDateTime, selectedIndex){
              dateTime = currentDateTime;
              if(onChange != null){
                onChange();
              }
            },
            pickerTheme: DateTimePickerTheme(
                showTitle: false,
                itemHeight: ScreenUtil().setHeight(110),
                pickerHeight: ScreenUtil().setHeight(230),
                itemTextStyle:  context.textTheme.bodyLarge

            ),
          ) :
          DatePickerWidget(
            statusRegister: true,
            locale: registerInfo.register.nationality == 'IR' ? DateTimePickerLocale.fa : DateTimePickerLocale.af,
            dateFormat: 'yyyy,MMMM,dd',
            initialJalaliTime: dateTime,
            maxDateJalaliTime: maxDate!,
            minDateJalaliTime: minDate!,
            isJalali: true,
            // maxDateJalaliTime: typeCalendar == 1 ?
            //     Jalali.fromDateTime( DateTime(
            //         DateTime.now().year,
            //         DateTime.now().month,
            //         DateTime.now().day + 280
            //     ))
            //     : typeCalendar == 2 ?
            //     Jalali.fromDateTime(
            //         DateTime(
            //             DateTime.now().year,
            //             DateTime.now().month,
            //             DateTime.now().day
            //         )
            //     )
            //     :
            // Jalali(
            //     Jalali.now().year - 6,
            //     12,
            //     29
            // ),
            //
            // minDateJalaliTime:
            // typeCalendar == 1 ?
            //     Jalali.fromDateTime(  DateTime(
            //         DateTime.now().year,
            //         DateTime.now().month,
            //         DateTime.now().day + 1
            //     ))
            //     : typeCalendar == 2 ?
            // Jalali.fromDateTime(
            //     DateTime(
            //         DateTime.now().year,
            //         DateTime.now().month,
            //         DateTime.now().day - 279
            //     )
            // )
            //     :
            // Jalali(
            //     Jalali.now().year - 65,
            //     1,
            //     1
            // ),
            onChangeJalali: (currentDateTime, selectedIndex){
              dateTime = currentDateTime;
              if(onChange != null){
                onChange();
              }
              // print(currentDateTime);
              // setState(() {
              //   widget.dateTime = currentDateTime;
              //   // if(widget.mode == 0){
              //   //   //widget.RegisterParamViewModel['birthDay'] = _dateTime.toString().replaceAll('Jalali', '').replaceAll('(', '').replaceAll(')', '');
              //   //   registerInfo.setBirthDay(_dateTime.toString().replaceAll('Jalali', '').replaceAll('(', '').replaceAll(')', ''));
              //   // }else{
              //   //
              //   //   widget.controller.text = _dateTime.toString().replaceAll('Jalali', '').replaceAll('(', '').replaceAll(')', '').replaceAll(',','/');
              //   //
              //   // }
              //
              // });
            },
            pickerTheme: DateTimePickerTheme(
                showTitle: false,
                itemHeight: ScreenUtil().setHeight(110),
                pickerHeight: ScreenUtil().setHeight(230),
                itemTextStyle: context.textTheme.bodyLarge

            ),
          ),
        )
    );
  }

  // Future _selectDate() async {
  //   String picked = await jalaliCalendarPicker(
  //     customInitDateTime: _dateTime.toDateTime(),
  //     context: context,
  //     convertToGregorian: false,
  //     showTimePicker: false,
  //   );
  //   if (picked != null){
  //     Jalali birthday =  Jalali(
  //         DateTime.parse(picked).year,
  //         DateTime.parse(picked).month,
  //         DateTime.parse(picked).day
  //     );
  //     // print(birthday);
  //
  //     setState(() {
  //       _dateTime = Jalali(
  //           birthday.year,
  //           birthday.month,
  //           birthday.day
  //       );
  //
  //       if(widget.mode == 0){
  //         widget.RegisterParamViewModel['birthDay'] = _dateTime.toString().replaceAll('Jalali', '').replaceAll('(', '').replaceAll(')', '');
  //       }else{
  //
  //         widget.controller.text = _dateTime.toString().replaceAll('Jalali', '').replaceAll('(', '').replaceAll(')', '').replaceAll(',','/');
  //
  //       }
  //
  //     });
  //
  //   }
  // }

   getDateTime(){
    if(registerInfo.register.calendarType == 1 && !isBirthDate){
      if(dateTime.toString().contains('Jalali')){
        return dateTime.toDateTime();
      }else{
        return dateTime;
      }
    }else{
      return dateTime;
    }
  }


}