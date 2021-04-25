import '../providers/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AboutusScreen extends StatefulWidget {
  static const routeName = '/aboutus';

  @override
  _AboutusScreenState createState() => _AboutusScreenState();
}

class _AboutusScreenState extends State<AboutusScreen> {
  var _isInit = true;
  var _isloading = false;
  var contact;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isloading = true;
      });
      Provider.of<Settings>(context, listen: false)
          .agreement()
          .then((value) => setState(() {
                _isloading = false;
              }));
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProv = Provider.of<Settings>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('من نحن'),
        ),
        body: _isloading
            ? Center(child: CircularProgressIndicator())
            : Card(
                child: ListTile(
                  contentPadding: EdgeInsets.all(20),
                  title: Text(settingsProv.abouts),
                ),
              ),
      ),
    );
  }
}
