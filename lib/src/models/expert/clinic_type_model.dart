


class ClinicTypeModel {
  late String title;
  late String description;
  List<ClinicTypeIdModel> types = [];

  ClinicTypeModel.fromJson(Map<String,dynamic> parsedJson){
    title = parsedJson['title'];
    description = parsedJson['description'];
    // polarMidwifery = parsedJson['polarMidwifery'];
    // polarNutritionist = parsedJson['polarNutritionist'];
    // polarPsycology = parsedJson['polarPsycology'];
    parsedJson['types'] != [] ? parsedJson['types'].forEach((item){
      if(item['visible']){
        types.add(ClinicTypeIdModel.fromJson(item));
      }
    }) : types = [];
  }

}

class ClinicTypeIdModel{
  late int id;
  late String name;
  late bool visible;
  late String description;
  late int price;
  late String info;
  late String infoHelper;
  late String submit;

  ClinicTypeIdModel.fromJson(Map<String,dynamic> parsedJson){
    id = parsedJson['id'];
    name = parsedJson['name'];
    visible = parsedJson['visible'];
    description = parsedJson['description'];
    price = parsedJson['price'];
    info = parsedJson['info'];
    infoHelper = parsedJson['infoHelper'];
    submit = parsedJson['submit'];
  }

}