

import 'package:impo/src/models/circle_model.dart';
import 'package:intl/intl.dart';


class CirclesSendServerMode{

  List<Map<String,dynamic>>?  cycleInfos = [];
  late String token;


CirclesSendServerMode();

CirclesSendServerMode.fromJson(List<CycleViewModel> _circleModel){

  for(int i=0 ; i<_circleModel.length ; i++){
    String periodEndDate;
    if(_circleModel[i].periodEnd != null){
      periodEndDate = DateFormat('yyyy/MM/dd').format(DateTime.parse(_circleModel[i].periodEnd!));
    }else{
      DateTime _periodStart = DateTime.parse(_circleModel[i].periodStart!);
      periodEndDate = DateTime(_periodStart.year,_periodStart.month,_periodStart.day + 3).toString();
    }
    cycleInfos!.add(
      {
        'periodStartDate' : DateFormat('yyyy/MM/dd').format(DateTime.parse(_circleModel[i].periodStart!)),
        'PeriodEndDate' : periodEndDate,
        'cycleStartDate' : DateFormat('yyyy/MM/dd').format(DateTime.parse(_circleModel[i].periodStart!)),
        'cycleEndDate' : DateFormat('yyyy/MM/dd').format(DateTime.parse(_circleModel[i].circleEnd!)),
        'status' : _circleModel[i].status,
        'cycleIndex' : i,
      }
    );
  }
  // _circleModel.forEach((item) {
  //   cycleInfos.add(
  //     {
  //       'periodStartDate' : DateFormat('yyyy/MM/dd').format(DateTime.parse(item.periodStart)),
  //       'periodEndDate' :  DateFormat('yyyy/MM/dd').format(DateTime.parse(item.periodEnd)),
  //       'cycleStartDate' : DateFormat('yyyy/MM/dd').format(DateTime.parse(item.periodStart)),
  //       'cycleEndDate' : DateFormat('yyyy/MM/dd').format(DateTime.parse(item.circleEnd)),
  //       'cycleIndex' : item,
  //       'remove' : false
  //     }
  //   );
  // });



}


  //  Ali Najafi, [Jun 30, 2020 at 10:50:22 AM]:
//  @JsonProperty("PeriodStartDate")
//  private String PeriodStartDate;
//  @JsonProperty("PeriodEndDate")
//  private String PeriodEndDate;
//  @JsonProperty("CycleStartDate")
//  private String CycleStartDate;
//  @JsonProperty("CycleEndDate")
//  private String CycleEndDate;
//  @JsonProperty("CycleIndex")
//  private String CycleIndex;
//
//  public reqCircle_Item(_Circle_Item item)
//  {
//    DateFormat df = new SimpleDateFormat("yyyy/MM/dd", Locale.US);
//    this.PeriodStartDate = df.format(item.getPeriodStartDate());
//    this.PeriodEndDate = df.format(item.getPeriodEndDate());
//    this.CycleStartDate = PeriodStartDate;
//    this.CycleEndDate = df.format(item.getCycleEndDate());
//    this.CycleIndex = item.getId()+"";
//  }
//
//  @JsonProperty("CycleInfos")
//  private List<reqCircle_Item> CycleInfos;
//  @JsonProperty("Token")
//  private String Token;

}


