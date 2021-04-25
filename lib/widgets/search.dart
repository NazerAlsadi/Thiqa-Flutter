import '../screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7),
      color: Colors.white,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(SearchScreen.routeName),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'البحث',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            Icon(
              FontAwesomeIcons.search,
              color: Colors.blueGrey,
            ),
          ],
        ),
      ),
    );
  }
}
