import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../screens/postdetail_screen.dart';


// ignore: must_be_immutable
class FavListTile extends StatelessWidget {
 // var outputFormat = DateFormat("yyyy-MM-dd");
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  final favPost;
  FavListTile(this.favPost);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
   
    return Card(
      child: Container(
        height: 130,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(PostDetailScreen.routeName,
                arguments: favPost['pivot']['post_id']);
          },
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(5),
                width: size.width * .3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: new DecorationImage(
                      image: new AssetImage('assets/img/1.jpg'),
                      fit: BoxFit.fill),
                ),
              ),
              Container(
                width: size.width * .6,
                child: ListTile(
                  title: Text(favPost['post_title'],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person, color: Colors.blue[700]),
                            Text(favPost['users']['name']),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.blue[700],
                                ),
                                Text(favPost['governorates']
                                    ['governorate_name']),
                              ],
                            ),
                            Row(children: [
                              Icon(
                                Icons.timer,
                                color: Colors.blue[700],
                              ),
                              Text( favPost['created_at'].substring(0,10)
                                //favPost['created_at']
                                ),
                            ])
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
