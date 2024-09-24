
class DashBoardMsgOfflineMode {
  late int id;
  late String serverId;
  late int condition;
  late int status;
  late String text;

  DashBoardMsgOfflineMode.fromJson(Map<String,dynamic> parsedJson){
    id = parsedJson['id'];
    serverId = parsedJson['serverId'];
    condition = parsedJson['condition'];
    status = parsedJson['status'];
    text = parsedJson['text'];
  }

}

