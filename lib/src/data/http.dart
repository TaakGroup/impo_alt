
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;


// String identityUrl = 'https://weareimpo.ir';
// String womanUrl = 'https://woman.weareimpo.ir';
// String mediaUrl = 'https://media.weareimpo.ir';

// String identityUrl = 'http://172.20.255.159:5224';
// String womanUrl = 'http://172.20.255.159:5224';
// String mediaUrl = 'http://172.20.255.159:5224';

String identityUrl = 'https://weareimpo.ir';
String womanUrl = 'https://weareimpo.ir';
String mediaUrl = 'https://media.weareimpo.ir';

// String identityUrl = 'http://195.88.208.143:8080';
// String womanUrl = 'http://195.88.208.143:8080';
// String mediaUrl = 'http://195.88.208.143:8080';

// String identityUrl = 'http://172.20.255.148:5224';
// String womanUrl = 'http://172.20.255.148:5224';
// String mediaUrl = 'http://172.20.255.148:5224';

// String identityUrl = 'http://172.20.255.159:5224';
// String womanUrl = 'http://172.20.255.159:5224';
// String mediaUrl = 'http://172.20.255.159:5224';



class Http{

  // int counter401 = 0;

  // Future<Map> post(String uri, body) async {
  //
  //    http.Response response;
  //
  //   try {
  //     response = await http.post('$apiUrl/$uri',
  //         headers: {
  //           'Content-type': 'application/json',
  //           'Accept': 'application/json',
  //         },
  //         body: json.encode(body)
  //     )
  //         .timeout(Duration(milliseconds: 12000));
  //
  //
  //   }catch(e){
  //     debugPrint('Errooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooor');
  //     return null;
  //   }
  //
  //
  //  if(response.statusCode == 200){
  //    var responseBody = json.decode(response.body);
  //    return responseBody;
  //  }else{
  //    return {};
  //  }
  //
  //
  // }

  // Future<Map> get(String uri) async {
  //   http.Response response;
  //
  //   try{
  //     response = await http.get(
  //       '$apiUrl/$uri',
  //       headers: {
  //         'Content-type': 'application/json',
  //         'Accept': 'application/json',
  //       },
  //     )
  //         .timeout(Duration(milliseconds: 12000));
  //
  //   }catch(e){
  //     debugPrint('Errooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooor');
  //     return null;
  //   }
  //
  //   var responseBody = json.decode(response.body);
  //
  //
  //   return responseBody;
  // }

   sendRequest(String apiUrl,String uri,type,body, String token) async {
    try{

      final url = Uri.parse('$apiUrl/$uri');
      final request = http.Request(type, url);
      request.headers.addAll(<String, String>{
        'Content-type': 'application/json',
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });
      request.body = json.encode(body);
      final response = await request.send().timeout(Duration(milliseconds: 12000));
      debugPrint('${response.statusCode}:${request.url.path}');
      if(response.statusCode == 401){
        return {};
      }else if(response.statusCode == 200){
        String s = await response.stream.bytesToString();
        Map<String,dynamic> responseBody = json.decode(s);
        return  responseBody;
      }else{
        return null;
      }

    }catch(e){
      print(e);
      debugPrint('Errooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooor');
      return null;
    }

    return null;
//    if (response.statusCode != 200){
//      return null;
//    }

  }


}