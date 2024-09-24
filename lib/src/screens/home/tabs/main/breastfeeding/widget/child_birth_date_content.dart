import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/dashboard_presenter.dart';
import 'package:impo/src/components/calender.dart';
import 'package:shamsi_date/extensions.dart';



class ChildBirthDateContent extends StatefulWidget {
  final DashboardPresenter? dashboardPresenter;

  const ChildBirthDateContent({this.dashboardPresenter});
  @override
  State<ChildBirthDateContent> createState() => ChildBirthDateContentState();
}

class ChildBirthDateContentState extends State<ChildBirthDateContent> {

  late AnimationController animationControllerScaleSendButton;
  late Calender calender;
  late Jalali maxDate;
  late Jalali minDate;

  @override
  void initState() {
    setMaxAndMinCalendar();
    super.initState();
  }

  setMaxAndMinCalendar(){
    DateTime today  = DateTime.now();
    minDate = Jalali.fromDateTime(
        DateTime(today.year,today.month,today.day - 175)
    );
    maxDate = Jalali.now();
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StreamBuilder(
                  stream:
                  widget.dashboardPresenter!.childBirthDateSelectedObserve,
                  builder: (context,
                      AsyncSnapshot<Jalali> snapshotChildBirthDateSelected) {
                    if (snapshotChildBirthDateSelected.data != null) {
                      return Container(
                          height: ScreenUtil().setWidth(350),
                          child: calender = Calender(
                              isBirthDate: false,
                              dateTime: snapshotChildBirthDateSelected.data,
                              onChange: () {
                                widget.dashboardPresenter!.onChangeChildBirthDateDate(calender.getDateTime());
                              },
                              // typeCalendar: 2,
                            minDate:  minDate,
                            maxDate: maxDate
                          ));
                    } else {
                      return Container();
                    }
                  }),
              SizedBox(
                height: ScreenUtil().setWidth(40),
              ),
            ],
          ),
        ));
  }


}
