

class RemoveAlarmsModel {
  late int id;
  late int mode;
  late String serverId;

  RemoveAlarmsModel.fromJson(Map<String,dynamic> parsedJson){

    id = parsedJson['id'];
    mode = parsedJson['mode'];
    serverId = parsedJson['serverId'] != null ? parsedJson['serverId'] : '';

  }

}