import '../providers/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactScreen extends StatefulWidget {
  static const routeName = '/contact';

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  var _isInit = true;
  var _isloading = false;
  var _contact;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isloading = true;
      });
      Provider.of<Settings>(context, listen: false)
          .agreement()
          .then((value) => setState(() {
                _contact =
                    Provider.of<Settings>(context, listen: false).contactUs;
                _isloading = false;
              }));
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final settingsProv =Provider.of<Settings>(context);
    // print('the ....' + settingsProv.contactUs['email']);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('اتصل بنا'),
        ),
        body: Center(
          child: _isloading
              ? CircularProgressIndicator()
              : ListView(children: <Widget>[
                  Card(
                    child: ListTile(
                      title: Text(_contact['address']),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text(_contact['email']),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text(_contact['phone']),
                    ),
                  ),
                  _contact['facebook'] == null
                      ? Text('')
                      : Card(
                          child: ListTile(
                            title: Text(_contact['facebook']),
                          ),
                        ),
                  _contact['twitter'] == null
                      ? Text('')
                      : Card(
                          child: ListTile(
                            title: Text(_contact['twitter']),
                          ),
                        ),
                ]),
        ),
      ),
    );
  }
}
