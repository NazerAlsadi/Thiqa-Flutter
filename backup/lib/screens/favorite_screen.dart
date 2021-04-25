import 'dart:convert';

import '../providers/favories.dart';
import '../widgets/custom_listTile.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  var _isInit = true;
  // ignore: unused_field
  var _isLoading = false;
  var favProv;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final favProvider = Provider.of<Favorites>(context, listen: false);
      favProvider.fetchFavorite().then((value) {
        favProv = favProvider.allFav;
        if (mounted)
          setState(() {
            _isLoading = false;
          });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print(favProv);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          body: FutureBuilder(
        future: Provider.of<Favorites>(context).fetchFavorite(),
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
              print("t1: ${favData.data.body}");
              print((favData.data.body).length);
              var favorite = json.decode(favData.data.body);
              return ListView.builder(
                itemCount: favorite.length,
                itemBuilder: (context, i) => CustomListtile((favorite[i]['id'])),
                
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
