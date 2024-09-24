

class FileNameModel{

  late String fileName;
  late String type;
  late String  fileSize;

  FileNameModel.fromJson(Map<String,dynamic> parsedJson){
    fileName = parsedJson['fileName'];
    type = parsedJson['type'];
    fileSize = '${parsedJson['fileSize']/1000}';
  }

}