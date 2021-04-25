import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: 
        Center(child:  CircularProgressIndicator(),
        // Column(
        //   children: [
        //      // Image.asset('assets/img/logo.jpg'),
        //      // CircularProgressIndicator(),
        //       //Center(child: Text('Loading' , style: TextStyle(color: Colors.blue[700]),)),   
        //   ],
        ),
    );
  }
}