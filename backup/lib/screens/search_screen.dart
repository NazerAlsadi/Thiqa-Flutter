import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/posts.dart';
import '../widgets/custom_listTile.dart';


class SearchScreen extends StatefulWidget {
  static const routeName = '/serach';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  var needed;
  bool res = false;
  Future<void> _saveForm() async {
    _formKey.currentState.validate();
    _formKey.currentState.save();
    Provider.of<Posts>(context, listen: false).search(needed);
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      res = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(''),
        ),
        body: Column(
          children: [
            Form(
              key: _formKey,
              child: Container(
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(right:5),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        
                        decoration: InputDecoration(labelText: 'البحث'),
                        textInputAction: TextInputAction.search,
                        onFieldSubmitted: (_){_saveForm();},
                        // ignore: missing_return
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'ما الذي تريد البحث عنه ؟';
                          }
                        },
                        onSaved: (value) {
                          needed = value;
                        },
                      ),
                    ),
                    IconButton(
                      padding: const EdgeInsets.all(10),
                      color: Colors.blue[700],
                      icon: Icon(Icons.search,size: 60),
                      onPressed: () {
                        _saveForm();
                      },
                    ),
                  ],
                ),
              ),
            ),
             
            needed!=''?Expanded(
              child: FutureBuilder(
                  future:
                      Provider.of<Posts>(context, listen: false).search(needed),
                  // ignore: missing_return
                  builder: (context, seatchData) {
                    if (seatchData.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (seatchData.connectionState == ConnectionState.done &&
                        seatchData.data == null) {
                      return Center(
                        child: Text('Empty Post!'),
                      );
                    }
                    if (seatchData.connectionState == ConnectionState.done &&
                        seatchData.data != null) {
                      print(seatchData.data.body);
                      
                      var favorite = json.decode(seatchData.data.body);
                      return ListView.builder(
                        itemCount: favorite.length,
                        itemBuilder: (context, i) => CustomListtile(favorite[i]['id']),

                      );
                    }
                  }),
            )
            :Container()
          ],
        ),
      ),
    );
  }
}
