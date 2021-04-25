import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert';
import 'dart:io';

class PostImgs with ChangeNotifier {

  List<Map> toBase64(List<File> fileList) {
    List<Map> s = new List<Map>();
    if (fileList.length > 0)
      fileList.forEach((element) {
        element.readAsBytesSync();
        Map a = {
          'fileName': basename(element.path),
          'encoded': base64Encode(element.readAsBytesSync())
        };
        s.add(a);
        print('addddd');
      });
    return s;
  }

  Future<bool> httpSend(Map params) async {
    String endpoint = 'http://thiqa-az.com/api/imgs';
    return await http
        .post(
      endpoint,
      headers: {"Accept": "application/json"},
      body: params,
    )
        // ignore: missing_return
        .then((response) {
      var x = json.decode(response.body);
      print(x
          // '${json.decode(x['attachment']).length}'
          // x['attachment'].length
          // '${json.decode(x['attachment'])[0]['fileName']}' +
          //   ' mmmm ' +
          //   '${json.decode(x['attachment'])[1]['fileName']}' +
          //   ' mmmm ' +
          //   '${json.decode(x['attachment']).length}'
          );
      if (response.statusCode == 201) {
        Map<String, dynamic> body = jsonDecode(response.body);
        if (body['status'] == 'OK') return true;
      } else
        return true;
    });
  }


  Future deleteImg(int imgId)async{
    final url = 'http://thiqa-az.com/api/imgs/$imgId';
    
    var response = await http.delete(url,);

    print("response: ${response.body}");
    return "${response.body}";
    
  }
}
