import 'package:a_to_zApp/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../screens/aboutus_screen.dart';
import '../screens/agreement_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/contact_screen.dart';


class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  var _isInit = true;
  var name;
  @override
  void didChangeDependencies() {
    if(_isInit){
      Provider.of<Auth>(context).getUserName().then((value) {
      
      setState(() {
        name =value;
      });
    } );
    }
    _isInit = false;
    
    super.didChangeDependencies();
  }  

  @override
  Widget build(BuildContext context) {
    //name = Provider.of<Auth>(context).userName;
    
    
    
    return Drawer(
      child: ListView(
        children: <Widget>[
          // ignore: missing_required_param
          UserAccountsDrawerHeader(
            accountName: Text(
              '$name',
              style: TextStyle(color: Colors.blueGrey),
            ),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.person),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/img/user_back.jpg"),
                  fit: BoxFit.cover),
            ),
          ),
          ListTile(
            title: Text("اتفاقية الاستخدام"),
            leading: Icon(Icons.view_agenda),
            onTap: () {
              Navigator.of(context).pushNamed(AgreementScreen.routeName);
            },
          ),
          ListTile(
            title: Text("من نحن"),
            leading: Icon(Icons.people),
            onTap: () {
              Navigator.of(context).pushNamed(AboutusScreen.routeName);
            },
          ),
          ListTile(
            title: Text("اتصل بنا"),
            leading: Icon(Icons.phone),
            onTap: () {
              Navigator.of(context).pushNamed(ContactScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            title: Text("تسجيل خروج"),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              Provider.of<Auth>(context , listen:false).logout();
              Navigator.of(context).pushReplacementNamed(Login.routeName);
            },
          ),
        ],
      ),
    );
  }
}
