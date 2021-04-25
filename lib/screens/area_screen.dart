import '../providers/governators.dart';
import '../providers/posts.dart';
import './holder_screen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AreaScreen extends StatefulWidget {
  @override
  _AreaScreenState createState() => _AreaScreenState();
}

class _AreaScreenState extends State<AreaScreen> {
  var _areas = [];
  var areas = [];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Governators>(context).fetchGovernators(),
      builder: (context, govData) {
        if (govData.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        _areas = Provider.of<Governators>(context).all;
        _areas.forEach((element) {
          areas.add(element);
        });
        _areas.insert(0, Governator(id: 0, name: 'كل المناطق'));
        return Scaffold(
            appBar: AppBar(
              title: Text('اختر المنطقة'),
            ),
            body: ListView.builder(
                itemCount: _areas.length,
                itemBuilder: (context, i) => ListTile(
                      leading: Container(
                        height: 50,
                        width: 50,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              color: Theme.of(context).primaryColor,
                              child: Icon(
                                Icons.add_location,
                                color: Colors.white,
                              ),
                            )),
                      ),
                      title: Text(_areas[i].name),
                      trailing: RaisedButton(
                        color: Theme.of(context).accentColor,
                        child: Text('اختيار',style: TextStyle(color: Colors.white),),
                        onPressed: (){
                          Provider.of<Posts>(context,listen: false).changeGov(_areas[i].id).then((value){
                            Navigator.of(context).pushReplacementNamed(HolderScreen.routeName);
                          });
                        },
                      ),
                    )));
      },
    );
  }
}
