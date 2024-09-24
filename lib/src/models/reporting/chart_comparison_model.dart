
class ChartComparisonModel{

  late int circleDayRegister;
  late int periodDayRegister;
  late int largestCircleDay;
  late int totalDays;
  List<CirclesComparison> circles = [];

  ChartComparisonModel.fromJson(Map<String,dynamic> parsedJson){
    circleDayRegister = parsedJson['circleDayRegister'];
    periodDayRegister = parsedJson['periodDayRegister'];
    largestCircleDay = parsedJson['largestCircleDay'];
    totalDays = parsedJson['totalDays'];
    parsedJson['circles'].forEach((item){
      circles.add(item);
    });
  }

}

class CirclesComparison{

  late int circleDay;
  late int periodDay;
  late String months;
  late bool status;

  CirclesComparison.fromJson(Map<String,dynamic> parsedJson){
    circleDay = parsedJson['circleDay'];
    periodDay = parsedJson['periodDay'];
    months = parsedJson['months'];
    status = parsedJson['status'];
  }

}
