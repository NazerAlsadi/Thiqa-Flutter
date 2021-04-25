import 'dart:convert';
import 'package:a_to_zApp/providers/posts.dart';
import 'package:a_to_zApp/widgets/custom_listTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  Widget build(BuildContext context) {
      return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          body: FutureBuilder(
        future: Provider.of<Posts>(context).fetchUserPosts(),
        // ignore: missing_return
        builder: (context, favData) {
          {
            if (favData.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (favData.connectionState == ConnectionState.done &&
                favData.data == null) {
              return Center(
                child: Text('Empty Post!'),
              );
            }
            if (favData.connectionState == ConnectionState.done &&
                favData.data != null) {
              print(favData.data.body);
              print((favData.data.body).length);
              var favorite = json.decode(favData.data.body);
              return ListView.builder(
                itemCount: favorite.length,
                itemBuilder: (context, i) => CustomListtile(favorite[i]['id']),
                
                // ListTile(
                //   title: Text( favorite[i]['pivot']['post_id'].toString()),
                // ),
              );
            }
          }
        },
      )),
    );
    }
}
