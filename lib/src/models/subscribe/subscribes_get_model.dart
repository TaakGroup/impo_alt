import 'package:impo/src/models/subscribe/subscribtions_packages_model.dart';
import 'package:intl/intl.dart';


class SubscribesGetModel{
  late bool isValid;
  late bool hasSubscribtion;
  late String endTime;
  List<SubscribtionsPackagesModel> packages = [];
  late String text ;
  late bool showCloseButton;
  late String upText;
  late String downText;
  late String supportText;
  late String supportPhone;
  late bool isShowOrganization;
  late String organizationText;
  late String upTextOrganization;
  late String downTextOrganization;
  late String hintTextOrganization;
  late String discountCodeHelper;

  // String text1;
  // String text2;
  // String text3;

  final oCcy = new NumberFormat("#,##0", "en_US");

  SubscribesGetModel.fromJson(Map<String,dynamic> parsedJson){
    isValid = parsedJson['isValid'];
    hasSubscribtion = parsedJson['hasSubscribtion'];
    parsedJson['packages'].forEach((item){
      packages.add(SubscribtionsPackagesModel.fromJson(item));
    });
    text = parsedJson['text'];
    showCloseButton = parsedJson['showCloseButton'];
    upText = parsedJson['upText'];
    downText = parsedJson['downText'];
    supportText = parsedJson['supportText'];
    supportPhone = parsedJson['supportPhone'];
    isShowOrganization = parsedJson['isShowOrganization'];
    organizationText = parsedJson['organizationText'];
    upTextOrganization = parsedJson['upTextOrganization'];
    downTextOrganization = parsedJson['downTextOrganization'];
    hintTextOrganization= parsedJson['hintTextOrganization'];
    discountCodeHelper = parsedJson['discountCodeHelper'];
    // text1 = parsedJson['text1'];
    // text2 = parsedJson['text2'];
    // text3 = parsedJson['text3'];
  }

}