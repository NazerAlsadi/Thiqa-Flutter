import 'dart:convert';

import 'package:a_to_zApp/screens/name_entry.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
/*************************/
import './screens/editcomment_screen.dart';
import './screens/editpost_screen.dart';
import './screens/aboutus_screen.dart';
import './screens/agreement_screen.dart';
import './screens/contact_screen.dart';
import './screens/search_screen.dart';
import './screens/splash_screen.dart';
import './screens/verify_screen.dart';
import './screens/holder_screen.dart';
import './screens/home_screen.dart';
import './screens/postdetail_screen.dart';
import './screens/postform_screen.dart';
import './screens/login_page.dart';

/**************************************/
import './providers/auth.dart';
import './providers/settings.dart';
import './providers/advertises.dart';
import './providers/comments.dart';
import './providers/favories.dart';
import './providers/governators.dart';
import './providers/post_imgs.dart';
import './providers/categories.dart';
import './providers/posts.dart';



void main() {
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var x;
  bool isSet = false;
  var _user;
  var tryLogin=false;
  @override
  Widget build(BuildContext context) {
    
    final LocalStorage storage = new LocalStorage('Thiqa');
    storage.ready.then((value){
    if(storage.getItem('userData')!=null && !isSet)
      {
        setState(() {
          isSet=true;
        _user = json.decode(storage.getItem('userData'))['user'];  
        });
        
        print("nu$_user");
      }
      });
    SharedPreferences.getInstance().then((value){
      
      if(
        value.getString('userData')!=null && 
        json.decode(value.getString('userData'))['user']['sms_verified_at']!=null)
      {
       // Navigator.of(context).pushReplacementNamed(HolderScreen.routeName);
      }
    });
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Auth()),
          ChangeNotifierProvider.value(value: Categories()),
          //ChangeNotifierProvider.value(value: Posts()),
          // ignore: missing_required_param
          ChangeNotifierProxyProvider<Auth, Posts>(
            update: (ctx, auth, _) => Posts(auth.token),
          ),
          ChangeNotifierProvider.value(value: PostImgs()),
          // ignore: missing_required_param
          ChangeNotifierProxyProvider<Auth, Comments>(
            update: (ctx, auth, _) => Comments(auth.token),
          ),
          // ignore: missing_required_param
          ChangeNotifierProxyProvider<Auth, Favorites>(
            update: (ctx, auth, _) => Favorites(auth.token),
          ),
          
          ChangeNotifierProvider.value(value: Advertises()),
          ChangeNotifierProvider.value(value: Governators()),
          ChangeNotifierProvider.value(value: Settings()),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Thiq AZ',
            theme: ThemeData(primaryColor: Colors.blue[700],fontFamily: 'Amiri'),
            home:auth.tryAutoLogin()!=false?(_user!=null && _user['sms_verified_at']!=null  ?HolderScreen():Login()):Container(),
            routes: {
              Login.routeName: (ctx) => Login(),
              PostDetailScreen.routeName: (ctx) => PostDetailScreen(),
              PostFormScreen.routeName: (ctx) => PostFormScreen(),
              HomeScreen.routeName: (ctx) => HomeScreen(),
              NameEntry.rountName:(ctx)=>NameEntry(),
              HolderScreen.routeName: (ctx) => HolderScreen(),
              VerifyScreen.routeName: (ctx) => VerifyScreen(),
              SearchScreen.routeName : (ctx) => SearchScreen(),
              AgreementScreen.routeName: (ctx) => AgreementScreen(),
              AboutusScreen.routeName : (ctx) =>AboutusScreen(),
              ContactScreen.routeName : (ctx) =>ContactScreen(),
              EditPostScreen.routeName: (ctx) =>EditPostScreen(),
              EditCommentScreen.routeName : (ctx) =>EditCommentScreen(),
            },
          ),
        ));
        
  }
}
