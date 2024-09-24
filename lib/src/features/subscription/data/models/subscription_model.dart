
import 'package:taakitecture/taakitecture.dart';

class SubscriptionModel extends BaseModel with ModelMixin{

  late bool isValid;
  late bool isValidDiscountCode;
  late bool hasSubscribtion;
  late String endTime;
  List<SubscriptionPackagesModel> packages = [];
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

  @override
  BaseModel getInstance() => SubscriptionModel();

  @override
  Map<String, dynamic> get properties => {
    "isValid" : isValid,
    "isValidDiscountCode" : isValidDiscountCode,
    "hasSubscribtion" : hasSubscribtion,
    "endTime" : endTime,
    "packages" : packages,
    "text" : text,
    "showCloseButton" : showCloseButton,
    "upText" : upText,
    "downText" : downText,
    "supportText" : supportText,
    "supportPhone" : supportPhone,
    "isShowOrganization" : isShowOrganization,
    "organizationText" : organizationText,
    "upTextOrganization" : upTextOrganization,
    "downTextOrganization" : downTextOrganization,
    "hintTextOrganization" : hintTextOrganization,
    "discountCodeHelper" : discountCodeHelper,
  };

  @override
  void setProp(String key, value) {
    switch (key) {
      case "isValidDiscountCode":
        isValidDiscountCode = value;
        break;
      case "isValid":
        isValid = value;
        break;
      case "hasSubscribtion":
        hasSubscribtion = value;
        break;
      case "endTime":
        endTime = value;
        break;
      case "packages":
        packages = [for (var mapJson in value) SubscriptionPackagesModel().fromJson(mapJson)];
        break;
      case "text":
        text = value;
        break;
      case "showCloseButton":
        showCloseButton = value;
        break;
      case "upText":
        upText = value;
        break;
      case "downText":
        downText = value;
        break;
      case "supportText":
        supportText = value;
        break;
      case "supportPhone":
        supportPhone = value;
        break;
      case "isShowOrganization":
        isShowOrganization = value;
        break;
      case "organizationText":
        organizationText = value;
        break;
      case "upTextOrganization":
        upTextOrganization = value;
        break;
      case "downTextOrganization":
        downTextOrganization = value;
        break;
      case "hintTextOrganization":
        hintTextOrganization = value;
        break;
      case "discountCodeHelper":
        discountCodeHelper = value;
        break;
    }
  }

}

class SubscriptionPackagesModel extends BaseModel with ModelMixin{
  late String id;
  late int realValue;
  late String realValueText;
  late int value;
  late String valueText;
  late String unit;
  late String text;
  late bool isFree;
  late bool isSpecific;
  late String specificText;
  late bool inAppPurchase;
  late String discountText;
  late int discount;
  late String vatText;
  late int vat;
  late String totalPayText;
  late int totalPay;
  late  String payButtonText;
  late String viewId;

  @override
  BaseModel getInstance() => SubscriptionPackagesModel();

  @override
  Map<String, dynamic> get properties =>{
    "id" : id,
    "realValue" : realValue,
    "realValueText" : realValueText,
    "value" : value,
    "valueText" : valueText,
    "unit" : unit,
    "text" : text,
    "isFree" : isFree,
    "isSpecific" : isSpecific,
    "specificText" : specificText,
    "inAppPurchase" : inAppPurchase,
    "discountText" : discountText,
    "discount" : discount,
    "vatText" : vatText,
    "vat" : vat,
    "totalPayText" : totalPayText,
    "totalPay" : totalPay,
    "payButtonText" : payButtonText,
    "viewId" : viewId,
  };

  @override
  void setProp(String key, _value) {
    switch (key) {
      case "id":
        id = _value;
        break;
      case "realValue":
        realValue = _value;
        break;
      case "realValueText":
        realValueText = _value;
        break;
      case "value":
        value = _value;
        break;
      case "valueText":
        valueText = _value;
        break;
      case "unit":
        unit = _value;
        break;
      case "text":
        text = _value;
        break;
      case "isFree":
        isFree = _value;
        break;
      case "isSpecific":
        isSpecific = _value;
        break;
      case "specificText":
        specificText = _value;
        break;
      case "inAppPurchase":
        inAppPurchase = _value;
        break;
      case "discountText":
        discountText = _value;
        break;
      case "discount":
        discount = _value;
        break;
      case "vatText":
        vatText = _value;
        break;
      case "vat":
        vat = _value;
        break;
      case "totalPayText":
        totalPayText = _value;
        break;
      case "totalPay":
        totalPay = _value;
        break;
      case "payButtonText":
        payButtonText = _value;
        break;
      case "viewId":
        viewId = _value;
        break;
    }
  }

}