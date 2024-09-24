
class ChartTimingModel{
  late int largestCircleDay;
  late int totalDays;
  List<CirclesTimingModel> circles =  [];

ChartTimingModel.fomJson(Map<String,dynamic> parsedJson){
    largestCircleDay  = parsedJson['largestCircleDay'];
    totalDays = parsedJson['totalDays'];
    parsedJson['circles'].forEach((item){
      circles.add(item);
    });
  }
}

class CirclesTimingModel {
  int? circleDay;
  int? periodDay;
  int? startPeriodDay;
  int? endPeriodDay;
  String? startPeriodDate;
  String? endPeriodDate;
  String? dayStartCircle;
  String? dayEdnPeriod;
  List<int>? daysStartMonths;
  List<String>? monthsChartTiming;
  // bool isLargestCircleDay = false;
  String?  months;

  CirclesTimingModel.fromJson(Map<String,dynamic> parsedJson){
    // print(parsedJson['monthsChartTiming']);
    circleDay = parsedJson['circleDay'];
    periodDay = parsedJson['periodDay'];
    startPeriodDay = parsedJson['startPeriodDay'];
    endPeriodDay = parsedJson['endPeriodDay'];
    dayStartCircle = parsedJson['dayStartCircle'];
    dayEdnPeriod = parsedJson['dayEdnPeriod'];
    daysStartMonths = parsedJson['daysStartMonths'];
    monthsChartTiming = parsedJson['monthsChartTiming'];
    // isLargestCircleDay = parsedJson['isLargestCircleDay'];
    months = parsedJson['months'];
    startPeriodDate = parsedJson['startPeriodDate'];
    endPeriodDate = parsedJson['endPeriodDate'];

  }
}