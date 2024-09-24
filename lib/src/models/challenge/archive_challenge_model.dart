
class ArchiveChallengeModel {
  late String title;
  late int totalCount;
  late List<ItemsArchiveChallengeModel> items = [];

  ArchiveChallengeModel.fromJson(Map<String,dynamic> parsedJson){
    title = parsedJson['title'];
    totalCount = parsedJson['totalCount'];
    parsedJson['items'] != [] ? parsedJson['items'].forEach((item){
      items.add(ItemsArchiveChallengeModel.fromJson(item));
    }) : items = [];
  }

}

class ItemsArchiveChallengeModel{
  late String text;
  late String id;
  late String manAvatar;
  late String womanAvatar;
  late String title;
  bool selected = false;

  ItemsArchiveChallengeModel.fromJson(Map<String,dynamic> parsedJson){
    text = parsedJson['text'];
    id = parsedJson['id'];
    manAvatar = parsedJson['manAvatar'];
    womanAvatar = parsedJson['womanAvatar'];
    title = parsedJson['title'];
  }

}