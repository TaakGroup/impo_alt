
class CancelNotify{
  late int id;
  late int notifyId;

  CancelNotify.fromJson(Map<String,dynamic> parsedJson){
    id = parsedJson['id'];
    notifyId = parsedJson['notifyId'];
  }
}