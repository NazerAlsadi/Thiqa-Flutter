import 'dart:async';
import 'dart:convert';
import 'package:localstorage/localstorage.dart';

import '../models/http_exception.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  String _name;
  DateTime _expiryDate;
  String _userId;
  dynamic _user;
  String _verifyCode;
  bool _code;
  String _smsVerify;
  final LocalStorage storage = new LocalStorage('Thiqa');
  
  String get userName {
    return _name;
  }

  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final x = prefs.getString('userData');
    var xData = json.decode(x);
    var userName = xData['userName'];
    return userName;
  }

  Future<String> getCode() async {
    final prefs = await SharedPreferences.getInstance();
    final x = prefs.getString('userData');
    var xData = json.decode(x);
    var code = xData['code'];
    print("the code from get code function ..." + code);
    return code;
  }

  Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final x = prefs.getString('userData');
    var xData = json.decode(x);
    var id = xData['userId'];
    return id;
  }

  Future getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final x = prefs.getString('userData');
    var xData = json.decode(x);
    var user = xData['user'];
    return user;
  }

  Future updateName(String name)  async{
    print(name);
    
    final url = 'http://thiqa-az.com/api/update-name';
    
     var pref = await SharedPreferences.getInstance();
     if(pref.getString('userData')!=null)
     {
       _token = json.decode(pref.getString('userData'))['token'];
      _expiryDate= DateTime.parse(json.decode(pref.getString('userData'))['expiryDate']);
     }
      print(_token);
      
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $token'
        },
        body: {
          "name":"$name"
        }
      );
      print(json.decode(response.body));
      if(response.body!="Not autherized")
      {
        final responseData = json.decode(response.body);
      
      _user = responseData;
      _userId = "${responseData['id']}";
      _name = responseData['name'];
      
      

      final userData = json.encode({
        'token': _token,
        'user': _user,
        'userId': _userId,
        'userName': _name,
        'expiryDate': _expiryDate.toIso8601String(),
        'code': _verifyCode,
        'sms': _smsVerify
      });
      print("userDataV: ${json.decode(userData)['token']}");
      pref.setString('userData', userData);
      storage.setItem('userData', userData);
      return true;
      }
      else{
        return false;
      }
      
  
  
  }
  
  String get verified {
    return _verifyCode;
  }

  bool get isAuth {
    return token != null;
  }

   get verifiedUser  async{
    
    if(storage.getItem('userData')!=null)
    {
      print("vu: ${json.decode(storage.getItem('userData'))['user']['sms_verified_at']}");
      return json.decode(storage.getItem('userData'))['user']['sms_verified_at'];
    }
    return null;
    
    
  }

  bool yes() {
    // var x;
    // isActive().then((value) { this.x = value;
    // print("the is active value is ..." +x.toString());
    // return x;
    // });

    // return x;
  }

 Future<bool> isActive() async {
    final prefs = await SharedPreferences.getInstance();

    var userData = prefs.getString('userData');
    
    userData!=null?_user = json.decode(userData)['user']:_user=null;
    if (_user != null && _user['sms_verified_at'] != null) return true;
    else
    return false;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> signup(String name, String phone, String password) async {
    const url = "http://thiqa-az.com/api/register";
    try {
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: json.encode(
          {
            'name': name,
            'phone': phone,
            'password': password,
          },
        ),
      );
      _verifyCode =
          (json.decode(response.body)['user']['verify_code']).toString();

      final responseData = json.decode(response.body);

      if (responseData['message'] != null) {
        throw HttpException('${responseData['errors']['phone'][0]}');
      }
      _user = json.decode(response.body)['user'];
      _token = json.decode(response.body)['accessToken'];
      _userId = "${json.decode(response.body)['user']['id']}";
      _name = json.decode(response.body)['user']['name'];
      _expiryDate = DateTime.now().add(Duration(days: 365));
      _smsVerify =
          (json.decode(response.body)['user']['sms_verified_at']).toString();

      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'user': _user,
        'userId': _userId,
        'userName': _name,
        'expiryDate': _expiryDate.toIso8601String(),
        'code': _verifyCode,
        'sms': _smsVerify
      });
      //final verCode = json.encode({'ver_code' : ''});
      prefs.setString('userData', userData);
      // prefs.setString('ver_code', verCode);
    } catch (error) {
      throw (error);
    }
  }

  Future<void> login(String phone) async {
    // ignore: unnecessary_statements
    storage.ready;
    const url = "http://thiqa-az.com/api/login";
    try {
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: json.encode(
          {
            'phone': "$phone",
          },
        ),
      );
      print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if (responseData['message'] != null) {
        throw (HttpException(responseData['message']));
      }

      _token = json.decode(response.body)['accessToken'];
      _userId = "${json.decode(response.body)['user']['id']}";
      _name = json.decode(response.body)['user']['name'];
      _user = json.decode(response.body)['user'];
      _expiryDate = DateTime.now().add(Duration(days: 365));
      _verifyCode =
          (json.decode(response.body)['user']['verify_code']).toString();
      _smsVerify =
          (json.decode(response.body)['user']['sms_verified_at']).toString();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'user': _user,
        'userId': _userId,
        'userName': _name,
        'expiryDate': _expiryDate.toIso8601String(),
        'code': _verifyCode,
        'sms': _smsVerify
      });
      prefs.setString('userData', userData);
      storage.setItem('userData', userData);
      print("userData: $userData");
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    storage.clear();
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    
    return true;
  }

  Future<void> verifiy() async {
    var url = "http://thiqa-az.com/api/verified";
    
    try {
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $token'
        },
      );
      print(json.decode(response.body));

      final responseData = json.decode(response.body);
      if (responseData['message'] != null) {
        throw (HttpException(responseData['message']));
      }
      _user = json.decode(response.body)['user'];
      _userId = "${json.decode(response.body)['user']['id']}";
      _name = json.decode(response.body)['user']['name'];
      _expiryDate = DateTime.now().add(Duration(days: 365));
      _verifyCode =
          (json.decode(response.body)['user']['verify_code']).toString();
      _smsVerify =
          (json.decode(response.body)['user']['sms_verified_at']).toString();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'user': _user,
        'userId': _userId,
        'userName': _name,
        'expiryDate': _expiryDate.toIso8601String(),
        'code': _verifyCode,
        'sms': _smsVerify
      });
      print("userDataV: $userData");
      prefs.setString('userData', userData);
      storage.ready.then((value){
      storage.setItem('userData', userData);
      });
      

      //var userName = xData['userName'];

    } catch (error) {
      print(error);
    }
  }
}
