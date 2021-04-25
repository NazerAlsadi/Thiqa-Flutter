import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Settings with ChangeNotifier{
  String _agree ;
  String _about;
  Map _contact  = {};

  String get agrees {
    return _agree;
  }

  String get abouts {
    return _about;
  }

  Map get contactUs{
    return _contact;
  }

  Future<void> agreement() async {
    final myUrl = 'http://thiqa-az.com/api/settings';
    try {
      final response =
          await http.get(myUrl, headers: {"Accept": "application/json"});
          final extractedData = json.decode(response.body);
          _agree = extractedData['agreement'];
          _about = extractedData['about_us'];
          _contact['address'] = extractedData['address'];
          _contact['phone'] = extractedData['phone'];
          _contact['email'] = extractedData['email'];
          _contact['facebook'] = extractedData['facebook'];
          _contact['twitter'] = extractedData['twitter'];
          print(extractedData);
          notifyListeners();
      return response;

    } catch (error) {
      print(error);
    }
  }

  Future<void> contact() async {
    final myUrl = 'http://thiqa-az.com/api/settings';
    try {
      final response =
          await http.get(myUrl, headers: {"Accept": "application/json"});
      return response;

    } catch (error) {
      print(error);
    }
  }


}