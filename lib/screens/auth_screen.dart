import '../models/http_exception.dart';
import '../providers/auth.dart';
import '../screens/verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'holder_screen.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'name': '',
    'phone': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  // method for show dailog
  void _showErrorDailog(msg) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Accured'),
              content: Text(msg),
              actions: [
                FlatButton(
                  onPressed: () => Navigator.of(context).pushNamed('/auth'),
                  child: Text('Okey'),
                )
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // await Provider.of<Auth>(context, listen: false)
        //     .login(_authData['phone'], _authData['password']);
        Navigator.of(context).pushReplacementNamed(HolderScreen.routeName);
      } else {
        await Provider.of<Auth>(context, listen: false).signup(
            _authData['name'], _authData['phone'], _authData['password']);
        Navigator.of(context).pushReplacementNamed(VerifyScreen.routeName);
      }
    } on HttpException catch (e) {
      var errMsg = e.toString();
      _showErrorDailog(errMsg);
    } catch (error) {
      var errMsg = "could't authenticate you now. please try again";
      _showErrorDailog(errMsg);
    }

    setState(() {
      _isLoading = false;
    });
  }

  

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8.0,
        child: Container(
          height: _authMode == AuthMode.Signup ? 380 : 260,
          constraints: BoxConstraints(
              minHeight: _authMode == AuthMode.Signup ? 320 : 260),
          width: deviceSize.width * 0.75,
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  if (_authMode == AuthMode.Signup)
                    TextFormField(
                      decoration: InputDecoration(labelText: 'الاسم'),
                      keyboardType: TextInputType.text,
                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'يرجى ادخال الاسم!';
                        }
                      },
                      onSaved: (value) {
                        _authData['name'] = value;
                      },
                    ),
                  //
                  TextFormField(
                    decoration: InputDecoration(labelText: 'الرقم'),
                    keyboardType: TextInputType.number,
                    // ignore: missing_return
                    validator: (value) {
                      print(value);
                      if(value.isEmpty)
                        return 'enter num please';
                      // else if(value.length <= 10)
                      //   return 'should be min 10 digits';
                        else if(int.parse(value) < 920000000)
                          return 'please enter valid mobile phone';
                      
                    },
                    onSaved: (value) {
                      _authData['phone'] = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'كلمة المرور'),
                    obscureText: true,
                    controller: _passwordController,
                    // ignore: missing_return
                    validator: (value) {
                      if (value.isEmpty || value.length < 8) {
                        return 'كلمة المرور قصيرة جداَ!';
                      }
                    },
                    onSaved: (value) {
                      _authData['password'] = value;
                    },
                  ),
                  if (_authMode == AuthMode.Signup)
                    TextFormField(
                      enabled: _authMode == AuthMode.Signup,
                      decoration:
                          InputDecoration(labelText: 'تأكيد كلمة المرور'),
                      obscureText: true,
                      validator: _authMode == AuthMode.Signup
                          // ignore: missing_return
                          ? (value) {
                              if (value != _passwordController.text) {
                                return 'كلمة المرور المؤكدة غير مطابقة!';
                              }
                            }
                          : null,
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  if (_isLoading)
                    CircularProgressIndicator()
                  else
                    RaisedButton(
                      child: Text(
                          _authMode == AuthMode.Login ? 'دخول' : 'التسجيل'),
                      onPressed: _submit,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      color: Theme.of(context).primaryColor,
                      textColor:
                          Theme.of(context).primaryTextTheme.button.color,
                    ),
                  FlatButton(
                    child: Text(
                        '${_authMode == AuthMode.Login ? 'التسجيل' : 'دخول'} '),
                    onPressed: _switchAuthMode,
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
