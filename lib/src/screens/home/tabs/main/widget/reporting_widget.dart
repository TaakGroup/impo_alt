import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/dashboard_presenter.dart';
import 'package:impo/src/components/DateTime/my_datetime.dart';
import 'package:get/get.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:intl/intl.dart';
import 'package:impo/src/models/reporting/reporting_dashboard_model.dart';
import 'package:shamsi_date/shamsi_date.dart';

class ReportingWidget extends StatefulWidget{
  final DashboardPresenter? dashboardPresenter;

  ReportingWidget({Key? key,this.dashboardPresenter}):super(key: key);
  @override
  State<StatefulWidget> createState() => ReportingWidgetState();
}

class ReportingWidgetState extends State<ReportingWidget>{

  List<ReportingDashboardModel> reporting = [];

  @override
  void initState() {
    initItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.only(
          top: ScreenUtil().setWidth(25),
          right:ScreenUtil().setWidth(30),
          left: ScreenUtil().setWidth(30),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(30),
          vertical: ScreenUtil().setWidth(15)
        ),
        decoration: BoxDecoration(
          color: Color(0xfff9f9f9),
          borderRadius: BorderRadius.circular(12)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'گزارش قاعدگی من',
              style: context.textTheme.labelLargeProminent,
            ),
            SizedBox(height: ScreenUtil().setHeight(8)),
            Text(
              'این گزارش نشان‌دهنده طول دوره و طول پریودت در سه دوره آخره',
              style: context.textTheme.bodySmall,
            ),
            SizedBox(height: ScreenUtil().setHeight(12)),
            Row(
              children: [
                 Text(
                   'راهنما:',
                    style: context.textTheme.labelSmall!.copyWith(
                      color: Color(0xff938F94),
                    ),
                 ),
                SizedBox(width: ScreenUtil().setWidth(20)),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/humidity_high.svg',
                      width: ScreenUtil().setWidth(25),
                      height: ScreenUtil().setWidth(25),
                    ),
                    Text(
                      ' پریود',
                      style: context.textTheme.labelSmall!.copyWith(
                        color: Color(0xff5B595C),
                         fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
                SizedBox(width: ScreenUtil().setWidth(30)),
                Row(
                  children: [
                    Container(
                      width: ScreenUtil().setWidth(20),
                      height: ScreenUtil().setWidth(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffE3E3E3),
                      ),
                    ),
                    Text(
                      ' روز عادی',
                      style: context.textTheme.labelSmall!.copyWith(
                        color: Color(0xff5B595C),
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              color: Color(0xffEFEFEF),
              thickness: ScreenUtil().setWidth(3),
            ),
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              itemCount: reporting.length,
                separatorBuilder: (context,index){
                  return Divider(
                    color: Color(0xffEFEFEF),
                    thickness: ScreenUtil().setWidth(3),
                  );
                },
                itemBuilder: (context,index){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              Text(
                                'شروع پریود: ',
                                style: context.textTheme.labelSmall,
                              ),
                              Text(
                                reporting[index].startPeriod!,
                                style: context.textTheme.labelSmall!.copyWith(
                                    fontWeight: FontWeight.w500
                                ),
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(10)
                            ),
                            color: Color(0xffEFEFEF),
                            width: ScreenUtil().setWidth(2),
                            height: ScreenUtil().setWidth(40),
                          ),
                          Row(
                            children: [
                              Text(
                                'طول دوره: ',
                                style: context.textTheme.labelSmall,
                              ),
                              Text(
                                '${reporting[index].cycleLength} روزه',
                                style: context.textTheme.labelSmall!.copyWith(
                                  fontWeight: FontWeight.w500
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(60),
                        child: ListView.builder(
                          itemCount: reporting[index].cycleLength,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context,index1){
                            if(index1 <= reporting[index].periodLength!){
                              return SvgPicture.asset(
                                  'assets/images/humidity_high.svg',
                                width: ScreenUtil().setWidth(25),
                                height: ScreenUtil().setWidth(25),
                              );
                            }else{
                              return Container(
                                width: ScreenUtil().setWidth(20),
                                height: ScreenUtil().setWidth(20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffE3E3E3),
                                ),
                              );
                            }
                          },
                        ),
                      )
                    ],
                  );
                },
            )
          ],
        ),
      ),
    );
  }


  initItems(){
    List<CycleViewModel> cycles = widget.dashboardPresenter!.getAllCirlse().reversed.toList();
    if(cycles.length >= 3){
      for(int i=0 ; i<cycles.length ; i++){
        if(i==3) break;
        DateTime periodStart = DateTime.parse(cycles[i].periodStart!);
        DateTime periodEnd = DateTime.parse(cycles[i].periodEnd!);
        DateTime cycleEnd = DateTime.parse(cycles[i].circleEnd!);
        String startPeriod;
        if(widget.dashboardPresenter!.getRegisters().calendarType == 1){
          final DateFormat formatter = DateFormat('dd LLL','fa');
          startPeriod = formatter.format(periodStart);
        }else{
          startPeriod = _format1(Jalali.fromDateTime(periodStart));
        }
        int periodLength = MyDateTime().myDifferenceDays(periodStart,periodEnd);
        int cycleLength = MyDateTime().myDifferenceDays(periodStart, cycleEnd) + 1;
        reporting.add(
          ReportingDashboardModel(
            startPeriod: startPeriod,
            periodLength: periodLength,
            cycleLength: cycleLength
          )
        );
      }
    }
  }


  String _format1(Date d) {
    final f = d.formatter;
    if(widget.dashboardPresenter!.getRegisters().nationality == 'IR'){
      return "${f.d} ${f.mN}";
    }else{
      return "${f.d} ${f.mnAf}";
    }
  }

}