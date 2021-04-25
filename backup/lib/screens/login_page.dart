import 'dart:async';
import 'dart:convert';

import 'package:a_to_zApp/providers/auth.dart';
import 'package:a_to_zApp/screens/auth_screen.dart';
import 'package:a_to_zApp/screens/holder_screen.dart';
import 'package:a_to_zApp/widgets/keypad.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'name_entry.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';  
  @override
  
  _LoginState createState() => _LoginState();
  
  static _LoginState of(BuildContext context) {
    final _LoginState navigator = context.findAncestorStateOfType();

    return navigator;
  }
  
}


class _LoginState extends State<Login> with SingleTickerProviderStateMixin{
    String _string = "";
  String _message = 'يرجى إدخال رقم موبايل';
  String _error = "رقم الموبايل يجب أن يبدأ بـ 0";
  bool _isSent = false;
  String type = "mobile";
  String _mobile="";
  bool isLoading=false;
  AnimationController _controller;
  Animation<double> _fadeAnimation;
  Animation<double> _scaleAnimation;
  Animation<double> _scaleAnimation1;

final prefs =  SharedPreferences.getInstance();

 void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _fadeAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _scaleAnimation = Tween(begin: 0.0, end: 1.01)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _scaleAnimation1 = Tween(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }
void _resent()
{
  Provider.of<Auth>(context,listen: false).login(_mobile).then((value){
    setState(() {
    _isSent=false;  
    });
    
  });
}
  get string {
    return _string;
  }
  set string(
    String value,
  ) =>
      setState(() {
        

        if (value != 'clear' && value != 'done' && type == "mobile" && _string.length<10) {
          _controller.forward();
          _string += value;

          if (string[0] == '0') {
            _error = "";
          } else {
            _error = 'رقم الموبايل يجب أن يبدأ بـ 0';
            _controller.forward();
          }
          if (_string.length>=2 && string[1] != '9') {
            _error = 'يرجى إدخال رقم موبايل صحيح';
          } else {
            _error ="";
            _controller.forward();
          }
        }
        
        if (value == 'clear') {
          _string = '';
          isLoading=false;
          _controller.reverse();
        }

        if (value == 'done' && type == 'mobile' && _string!='' && _string.length==10) {
          _controller.reverse();
          _mobile = _string.replaceAll('done', '');
          _string = '';
          _message = 'بانتظار رمز التحقق ...';

          Provider.of<Auth>(context,listen: false).login(_mobile).then((value) {
            setState(() {
            type = "token";
            });
            Timer(Duration(seconds: 10), () {
              setState(() {
                type = "token";
                _isSent=true;
                _message = 'يرجى إدخال رمز التحقق';
                
                _controller.reverse();
              });
            });
          });
        }
        else if(value=='done' &&type=="mobile"){
          _error="يرجى إدخال رقم الموبايل بشكل صحيح";
        }
        if (value == 'clear' && type == 'token') {
          _string = '';
          _controller.reverse();
        }
        if(value=='done' && type =='token')
        {
          isLoading=true;
          prefs.then((valu) {
            print(valu);
              var user = json.decode(valu.getString('userData'))['user'];
              print("$user");
              if('$string'=='${user['verify_code']}')
              {
                Provider.of<Auth>(context,listen: false).verifiy().then((value){
                  isLoading=false;
                  if(user['name']==null)
                  {
                    Navigator.of(context).pushReplacementNamed(NameEntry.rountName);
                  }
                  else
                  {
                    Navigator.of(context).pushReplacementNamed(HolderScreen.routeName);
                  }
                    
                });
                
              }
              else
              {
                _string="";
                _message="يرجى إدخال رمز تحقق صحيح";
                _error="يرجى إدخال رمز تحقق صحيح";
                isLoading=false;
                _controller.reverse();
              }
            });
        }
        if (value != 'done' && value != 'clear' && type == 'token' && _string.length<4) {
          _string += value;
          
          _controller.forward();
        }
      });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
          child: Scaffold(
          body: SingleChildScrollView(
            primary: true,
                      child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(height: 50,),
                  isLoading?CircularProgressIndicator()
                  :AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: string == '' ? 0 : 80,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 2, color: Theme.of(context).accentColor),
                            borderRadius: BorderRadius.circular(10)),
                        height: 60,
                        width: double.infinity,
                        padding: EdgeInsets.all(0),
                        child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Center(
                                child: Text(
                              '$_string',
                              style: TextStyle(
                                  fontSize: 40,
                                  color: Theme.of(context).primaryColor),
                            ))),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: string == '' ? 80 : 0,
                    child: ScaleTransition(
                      scale: _scaleAnimation1,
                      child: Container(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            _message,
                            style: TextStyle(
                                height: 3,
                                shadows: [
                                  Shadow(
                                      color: Theme.of(context).accentColor,
                                      blurRadius: 2,
                                      offset: Offset(1, 1))
                                ],
                                fontSize: 16,
                                color: Theme.of(context).primaryColor),
                          )),
                    ),
                  ),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      '$_error',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  // ignore: sdk_version_ui_as_code
                  if(_isSent)
                  RaisedButton(onPressed: _resent,
                  color: Theme.of(context).primaryColor,
                  child: Text('إعادة إرسال',style: TextStyle(color: Colors.white),),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  KeyPad(
                    callback: (val) {
                      _string = val;
                    },
                  ),
                  SizedBox(height: 20,)
                ],
              ),
            ),
          ),
        ),
    );
  }
}