

class PartnerCodeModel {
  late String code;
  late String shareText;
  late String userName;
  late bool hasPartner;

  PartnerCodeModel.fromJson(Map<String,dynamic> parsedJson){
    code = parsedJson['code'];
    shareText = parsedJson['shareText'];
    userName = parsedJson['userName'];
    hasPartner = parsedJson['hasPartner'];
  }

}