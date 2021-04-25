import '../providers/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AgreementScreen extends StatefulWidget {
  static const routeName = '/agreement';

  @override
  _AgreementScreenState createState() => _AgreementScreenState();
}

class _AgreementScreenState extends State<AgreementScreen> {
  var _isInit = true;
  var _isloading = false;

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
    print(settingsProv.agrees);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('اتفاقية الاستخدام'),
        ),
        body: _isloading
            ? Center(child: CircularProgressIndicator(),)
            : Card(
                child: ListTile(
                  title: Text(settingsProv.agrees),
                ),
              ),
      ),
    );
  }
}
