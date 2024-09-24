import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

class MyDateTime{

  int myDifferenceDays(DateTime startDate,DateTime endDate){
    DateTime check = startDate;
    int diff = 0;
    while(check.millisecondsSinceEpoch < endDate.millisecondsSinceEpoch){
      check = DateTime(check.year,check.month,check.day,check.hour+24);
      diff++;
    }
    return diff;
  }

  RegisterParamViewModel _getRegister(){
    var registerInfo = locator<RegisterParamModel>();
    return registerInfo.register;
  }

  String _format1(Date d,RegisterParamViewModel register) {
    final f = d.formatter;

    if(register.nationality == 'IR'){
      return "${f.d} ${f.mN} ${f.yyyy}";
    }else{
      return "${f.d} ${f.mnAf} ${f.yyyy}";
    }
  }

  String getDateTimeFormat(DateTime dateTime){
    String formatDateTime = '';
    if(dateTime.year == DateTime.now().year && dateTime.month == DateTime.now().month && dateTime.day == DateTime.now().day){
      int diff = DateTime.now().difference(dateTime).inHours;
      if(diff == 0){
        diff = DateTime.now().difference(dateTime).inMinutes;
        if(diff <= 1){
          formatDateTime = 'دقایقی پیش';
        }else{
          formatDateTime = '${DateTime.now().difference(dateTime).inMinutes} دقیقه قبل';
        }
      }else{
        formatDateTime = '${DateTime.now().difference(dateTime).inHours} ساعت قبل';
      }
    }else{
      // String time = '${dateTime.hour}:${dateTime.minute}';
      if(_getRegister().calendarType == 1){
        final DateFormat formatter = DateFormat('d LLL yyyy  HH:mm','fa');
        formatDateTime = formatter.format(dateTime);
      }else{
        final DateFormat timeFormatter = DateFormat(' HH:mm','fa');
        Jalali shamsi = Jalali.fromDateTime(dateTime);
        formatDateTime = '${_format1(shamsi, _getRegister())}  ${timeFormatter.format(dateTime)}';
      }
    }
    return formatDateTime;
  }

  String getShamsiCycle(Date d,RegisterParamViewModel register) {
    final f = d.formatter;

    if(register.nationality == 'IR'){
      return "${f.d} ${f.mN}";
    }else{
      return "${f.d} ${f.mnAf}";
    }
  }

}