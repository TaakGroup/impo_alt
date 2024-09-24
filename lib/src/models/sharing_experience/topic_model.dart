

class TopicModel {
  late String image;
  late String name;
  late String inputText;
  late String coverImage;
  late String bio;
  late bool prohibtShareExp;
  late String id;
  bool selected = false;

  TopicModel.fromJson(Map<String,dynamic> parsedJson){
    image = parsedJson['image'];
    name = parsedJson['name'];
    inputText = parsedJson['inputText'];
    coverImage = parsedJson['coverImage'];
    bio = parsedJson['bio'];
    prohibtShareExp = parsedJson['prohibtShareExp'];
    id = parsedJson['id'];
  }

}