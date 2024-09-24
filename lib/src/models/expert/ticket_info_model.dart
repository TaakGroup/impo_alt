import 'package:impo/src/models/expert/dr_info_model.dart';
import 'package:intl/intl.dart';

class TicketInfoAdviceModel{
  late bool isValid;
  late int type;
  late String text;
  late int currentValue;
  late  TicketInfoModel info;

  TicketInfoAdviceModel.fromJson(Map<String,dynamic> parsedJson){
    isValid = parsedJson['isValid'];
    type = parsedJson['type'];
    text = parsedJson['text'];
    currentValue = parsedJson['currentValue'];
    info = TicketInfoModel.fromJson(parsedJson['info']);
  }

}

class TicketInfoModel{
  late String info;
  late String infoHelper;
  late String submit;
  late String cta;
  late String currentValue;
  late String payPrice;
  late String price;
  late String priceUnit;
  late String discountCode;
  late String discountMessage;
  late String discountString;
  late int discountPercent;
  late String discountPrice;
  late int id;
  late String name;
  late bool visible;
  late String pdpDescription;
  late SupportModel support;
  List<DoctorInfoModel> dr = [];
  // ValueInfo valueInfo;
  late String description;

  final oCcy = new NumberFormat("#,##0", "en_US");

  TicketInfoModel.fromJson(Map<String,dynamic> parsedJson){
    info = parsedJson['info'];
    infoHelper = parsedJson['infoHelper'];
    submit = parsedJson['submit'];
    cta = parsedJson['cta'];
    currentValue = oCcy.format(parsedJson['currentValue']);
    payPrice = oCcy.format(parsedJson['payPrice']);
    price = oCcy.format(parsedJson['price']);
    priceUnit = parsedJson['priceUnit'];
    discountCode = parsedJson['discountCode'];
    discountMessage = parsedJson['discountMessage'];
    discountString = parsedJson['discountString'];
    discountPercent = parsedJson['discountPercent'];
    discountPrice = oCcy.format(parsedJson['discountPrice']);
    id = parsedJson['id'];
    name = parsedJson['name'];
    visible = parsedJson['visible'];
    pdpDescription = parsedJson['pdpDescription'];
    support = SupportModel.fromJson(parsedJson['support']);
    parsedJson['dr'] != [] ? parsedJson['dr'].forEach((item){
      dr.add(DoctorInfoModel.fromJson(item,false));
    }) : dr = [];
    // valueInfo = ValueInfo.fromJson(parsedJson['valueInfo']);
    description = parsedJson['description'];
  }

}


class SupportModel {
  late String title;
  late String helper;
  late String phone;

  SupportModel.fromJson(Map<String,dynamic> parsedJson){
    title = parsedJson['title'];
    helper = parsedJson['helper'];
    phone = parsedJson['phone'];
  }

}

class DoctorInfoModel {
  late bool isOnline;
  late String rate;
  late int rrCount;
  late String image;
  late String firstName;
  late String lastName;
  late String id;
  late String minTime;
  late String ticketCount;
  String? academicCertificate;
  late String resume;
  late String speciliaty;
  late String nezamNumber;
  late bool hasPrescription;
  late String prescriptionText;
  late CommentsInfoModel comments;
  bool selected = false;

  DoctorInfoModel.fromJson(Map<String,dynamic> parsedJson,isComments){
    isOnline = parsedJson['isOnline'];
    rate = parsedJson['rate'];
    rrCount = parsedJson['rrCount'];
    image = parsedJson['image'];
    firstName = parsedJson['firstName'];
    lastName = parsedJson['lastName'];
    id = parsedJson['id'];
    minTime = parsedJson['minTime'];
    ticketCount = parsedJson['ticketCount'];
    academicCertificate = parsedJson['academicCertificate'];
    resume = parsedJson['resume'];
    speciliaty = parsedJson['speciliaty'];
    nezamNumber = parsedJson['nezamNumber'];
    hasPrescription = parsedJson['hasPrescription'];
    prescriptionText = parsedJson['prescriptionText'];
    if(isComments){
      comments = CommentsInfoModel.fromJson(parsedJson['comments']);
    }
  }

}

// class ValueInfo{
//
//   String ticketCount;
//   String rate;
//   String minute;
//
//
//   ValueInfo.fromJson(Map<String,dynamic> parsedJson){
//     ticketCount = parsedJson['ticketCount'];
//     rate = parsedJson['rate'];
//     minute = parsedJson['minute'];
//   }
// }