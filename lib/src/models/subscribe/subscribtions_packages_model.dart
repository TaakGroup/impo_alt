
class SubscribtionsPackagesModel{
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
  bool selected = false;


  SubscribtionsPackagesModel.fromJson(Map<String,dynamic> parsedJson){
   id = parsedJson['id'];
   realValue = parsedJson['realValue'];
   realValueText = parsedJson['realValueText'];
   value = parsedJson['value'];
   valueText= parsedJson['valueText'];
   unit = parsedJson['unit'];
   text = parsedJson['text'];
   isFree = parsedJson['isFree'];
   isSpecific = parsedJson['isSpecific'];
   specificText = parsedJson['specificText'];
   inAppPurchase = parsedJson['inAppPurchase'];
   discountText = parsedJson['discountText'];
   discount = parsedJson['discount'];
   vatText = parsedJson['vatText'];
   vat = parsedJson['vat'];
   totalPayText = parsedJson['totalPayText'];
   totalPay = parsedJson['totalPay'];
   payButtonText = parsedJson['payButtonText'];
   viewId = parsedJson['viewId'];
 }
}