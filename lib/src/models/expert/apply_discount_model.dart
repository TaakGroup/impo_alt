import 'package:impo/src/models/expert/ticket_info_model.dart';
import 'package:intl/intl.dart';

class ApplyDiscountPrice{

  final oCcy = new NumberFormat("#,##0", "en_US");

  ApplyDiscountPrice.fromJson(Map<String,dynamic> parsedJson,TicketInfoAdviceModel ticketInfoAdviceModel){
    ticketInfoAdviceModel.info.discountCode = parsedJson['discountCode'];
    ticketInfoAdviceModel.info.discountMessage = parsedJson['discountMessage'];
    ticketInfoAdviceModel.info.discountString = parsedJson['discountString'];
    ticketInfoAdviceModel.info.discountPercent = parsedJson['discountPercent'];
    ticketInfoAdviceModel.info.discountPrice = oCcy.format(parsedJson['discountPrice']);
    ticketInfoAdviceModel.info.payPrice = oCcy.format(parsedJson['payPrice']);
    ticketInfoAdviceModel.info.price = oCcy.format(parsedJson['price']);
    ticketInfoAdviceModel.info.priceUnit = parsedJson['priceUnit'];
  }

}