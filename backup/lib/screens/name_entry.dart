import 'package:a_to_zApp/providers/auth.dart';
import 'package:a_to_zApp/screens/holder_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

class NameEntry extends StatefulWidget {
  static const rountName = "name-entry";
  @override
  _NameEntryState createState() => _NameEntryState();
}

class _NameEntryState extends State<NameEntry> {
  final _nameControlller = TextEditingController();
  bool _isUpdating = false;
  @override
  Widget build(BuildContext context) {
    SharedPreferences.getInstance().then((value){
      print(value.getString('userDate'));
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('يرجى إدخال الاسم'),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(icon: Icon(Icons.person)),
                controller: _nameControlller,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
              height: 50,
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                child: !_isUpdating?Text('حفظ',
                    style: TextStyle(color: Colors.white, fontSize: 20)):
                    CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      strokeWidth: 2,
                    ),
                onPressed: () {
                  if (_nameControlller.text != '') {
                    setState(() {
                      _isUpdating=true;
                    });
                    Provider.of<Auth>(context, listen: false)
                        .updateName(_nameControlller.text)
                        .then((value){
                          if(value)
                          {
                            setState(() {
                          _isUpdating=false;  
                          });
                          Navigator.of(context).pushReplacementNamed(HolderScreen.routeName);
                          }
                          else
                          {
                            Navigator.of(context).pushReplacementNamed(Login.routeName);
                          }
                          
                          

                        });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
