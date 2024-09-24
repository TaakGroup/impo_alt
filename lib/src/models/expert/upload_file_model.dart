

import 'package:image_picker/image_picker.dart';

class UploadFileModel{

  late String name;
  late int type;
  late String fileNameForSend;
  late int stateUpload;
  late PickedFile fileName;

  UploadFileModel.fromJson(Map<String,dynamic> parsedJson){
    name = parsedJson['name'];
    type = parsedJson['type'];
    fileNameForSend = parsedJson['fileNameForSend'];
    stateUpload = parsedJson['stateUpload'];
    fileName = parsedJson['fileName'];

  }

}