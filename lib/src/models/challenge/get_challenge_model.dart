
class GetChallengeModel{
  late bool valid;
  late String manName;
  late String manAvatar;
  late String womanName;
  late String womanAvatar;
  late String status;
  late ButtonChallengeModel button;
  late CardChallengeModel card;

  GetChallengeModel.fromJson(Map<String,dynamic> parsedJson){
    valid = parsedJson['valid'];
    manName = parsedJson['manName'];
    manAvatar = parsedJson['manAvatar'];
    womanName = parsedJson['womanName'];
    womanAvatar = parsedJson['womanAvatar'];
    status = parsedJson['status'];
    button = ButtonChallengeModel.fromJson(parsedJson['button']);
    card = CardChallengeModel.fromJson(parsedJson['card']);
  }


}

class ButtonChallengeModel{
  late String b1;
  late String b2;
  late String b3;

  ButtonChallengeModel.fromJson(Map<String,dynamic> parsedJson){
    b1 = parsedJson['b1'];
    b2 = parsedJson['b2'];
    b3 = parsedJson['b3'];
  }

}

class CardChallengeModel{
  late LinkCardChallengeModel link;
  late String id;
  late int state;
  late String btnText;
  late String text;
  late String rightIcon;
  late String leftIcon;

  CardChallengeModel.fromJson(Map<String,dynamic> parsedJson){
    link = LinkCardChallengeModel.fromJson(parsedJson['link']);
    id = parsedJson['id'];
    state = parsedJson['state'];
    btnText = parsedJson['btnText'];
    text = parsedJson['text'];
    rightIcon = parsedJson['rightIcon'];
    leftIcon = parsedJson['leftIcon'];
  }

}

class LinkCardChallengeModel{
  late int type;
  late String url;

  LinkCardChallengeModel.fromJson(Map<String,dynamic> parsedJson){
    type = parsedJson['type'];
    url = parsedJson['url'];
  }

}