
import 'package:intl/intl.dart';

class GetBackupCircleItem{

  late String periodStartDate;
  late String periodEndDate;
  late String cycleStartDate;
  late String cycleEndDate;
  late int status;
  late int cycleIndex;


  GetBackupCircleItem.fromJson(Map<String,dynamic> parsedJson){

    periodStartDate = parsedJson['periodStartDate'];

    periodEndDate = parsedJson['periodEndDate'];

    cycleStartDate = parsedJson['cycleStartDate'];

    cycleEndDate = parsedJson['cycleEndDate'];

    status = parsedJson['status'];

    cycleIndex = parsedJson['cycleIndex'];


  }

//  @JsonProperty("periodStartDate")
//  private String periodStartDate;
//  @JsonProperty("periodEndDate")
//  private String periodEndDate;
//  @JsonProperty("cycleStartDate")
//  private String cycleStartDate;
//  @JsonProperty("cycleEndDate")
//  private String cycleEndDate;
//  @JsonProperty("cycleIndex")
//  private long cycleIndex;

}