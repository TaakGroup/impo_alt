
class GetRequestsModel {
  late String id;
  late String createTime;
  late bool isRecv;
  late String name;
  late String birthdate;

  GetRequestsModel.fromJson(Map<String,dynamic> parsedJson){
    id = parsedJson['id'];
    createTime = parsedJson['createTime'];
    isRecv = parsedJson['isRecv'];
    name = parsedJson['name'];
    birthdate = parsedJson['birthdate'];
  }

}