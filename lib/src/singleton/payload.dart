


class Payload {

  static Payload? pay;
  static Payload getGlobal(){
    if(pay == null) {
//      print('create');
      pay = new Payload();
    }
    return pay!;
  }

  String _payload = '';

  setPayload(String pay){
    _payload = pay;
  }

  String? getPayload(){
    return _payload;
  }

}