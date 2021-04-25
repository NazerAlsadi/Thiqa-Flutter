import 'package:flutter/material.dart';
import '../screens/login_page.dart';

typedef void StringCallback(String val);

class KeyPad extends StatelessWidget {
  final StringCallback callback;

  KeyPad({this.callback});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    shape: CircleBorder(
                      side: BorderSide(
                          color: Theme.of(context).accentColor, width: 5),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Login.of(context).string = '1';
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        '1',
                        style: TextStyle(fontSize: 40,color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    shape: CircleBorder(
                      side: BorderSide(
                          color: Theme.of(context).accentColor, width: 5),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Login.of(context).string = '2';
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        '2',
                        style: TextStyle(fontSize: 40,color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    shape: CircleBorder(
                      side: BorderSide(
                          color: Theme.of(context).accentColor, width: 5),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Login.of(context).string = '3';
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        '3',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    shape: CircleBorder(
                      side: BorderSide(
                          color: Theme.of(context).accentColor, width: 5),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Login.of(context).string = '4';
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        '4',
                        style: TextStyle(fontSize: 40,color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    shape: CircleBorder(
                      side: BorderSide(
                          color: Theme.of(context).accentColor, width: 5),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Login.of(context).string = '5';
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        '5',
                        style: TextStyle(fontSize: 40,color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    shape: CircleBorder(
                      side: BorderSide(
                          color: Theme.of(context).accentColor, width: 5),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Login.of(context).string = '6';
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        '6',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    shape: CircleBorder(
                      side: BorderSide(
                          color: Theme.of(context).accentColor, width: 5),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Login.of(context).string = '7';
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        '7',
                        style: TextStyle(fontSize: 40,color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    shape: CircleBorder(
                      side: BorderSide(
                          color: Theme.of(context).accentColor, width: 5),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Login.of(context).string = '8';
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        '8',
                        style: TextStyle(fontSize: 40,color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    shape: CircleBorder(
                      side: BorderSide(
                          color: Theme.of(context).accentColor, width: 5),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Login.of(context).string = '9';
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        '9',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: IconButton(
                        iconSize: 40,
                        icon: Icon(Icons.clear),
                  
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                      Login.of(context).string = 'clear';
                  },
                ),
                    )),
                Container(
                  child: RaisedButton(
                    shape: CircleBorder(
                      side: BorderSide(
                          color: Theme.of(context).accentColor, width: 5),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Login.of(context).string = '0';
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        '0',
                        style: TextStyle(
                          fontSize: 40,
                          color:Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: IconButton(
                        
                        icon: Text("OK",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 26),),
                        iconSize: 40,
                  
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                      Login.of(context).string = 'done';
                  },
                  
                ),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
