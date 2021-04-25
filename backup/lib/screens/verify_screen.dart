import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth.dart';
import 'auth_screen.dart';
import 'holder_screen.dart';

class VerifyScreen extends StatefulWidget {
  static const routeName = '/verify';
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  
  final _form = GlobalKey<FormState>();

  var _userVerify;
  
  // @override
  // Future<void> initState() async {
  //   final dbCode = Provider.of<Auth>(context , listen: false).verified;
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setString('ver_code', '$dbCode');
  //   super.initState();
  // }

  
  Future<void> _saveForm() async {
    _form.currentState.validate();
    _form.currentState.save();
    final dbCode = Provider.of<Auth>(context , listen: false).verified;
    Provider.of<Auth>(context,listen: false).verifiy();
    print(dbCode);
    
    print(_userVerify);


    final prefs = await SharedPreferences.getInstance();
    final x = prefs.getString('userData');
    final xData = json.decode(x);
    final code = xData['code'];
    
    final d = xData['sms'];
    print("the value is ......kk " + '$d');
    if('$code' == '$_userVerify'){
       print('$code');
       print('$_userVerify');

      

     
      Provider.of<Auth>(context , listen: false).verifiy();
      Navigator.of(context).pushReplacementNamed(HolderScreen.routeName);
    }else{
      print('The code is incorrect');
      Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification Code Screen'),
      ),
      body: 
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 30 , vertical:60),
           child: Form(
            key: _form,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'كود التحقق '),
                  keyboardType: TextInputType.number,
                  // ignore: missing_return
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'ادخل كود التحقق من فضلك ';
                    }
                  },
                  onSaved: (value) {
                    _userVerify = value;
                  },
                ),

                RaisedButton(
                        padding: const EdgeInsets.all(10),
                        color: Colors.blue[700],
                        child: Text(
                          'تحقق',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        onPressed: () {
                          _saveForm();
                        },
                      ),
              ],
            ),
        ),
         ),
      
    );
  }
}
