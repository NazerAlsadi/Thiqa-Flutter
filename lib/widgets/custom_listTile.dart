import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/posts.dart';
import '../screens/postdetail_screen.dart';


class CustomListtile extends StatefulWidget {
  final int id;
  CustomListtile(this.id);

  @override
  _CustomListtileState createState() => _CustomListtileState();
}

class _CustomListtileState extends State<CustomListtile> {
  var outputFormat = DateFormat("yyyy-MM-dd");
  Post loadedPost;
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final postProvider = Provider.of<Posts>(context, listen: false);
      //Post loadedPost = postProvider.getPost(widget.id);
      postProvider.getListTilePost(widget.id).then((value) {
        if (mounted)
          setState(() {
            loadedPost = value;
            _isLoading = false;
          });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final postpv = Provider.of<Posts>(context);
    return _isLoading
        ? Center(
            child: Container(
              height: 5,
              child: LinearProgressIndicator(),
            ),
          )
        : Card(
            child: Container(
              height: 100,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(PostDetailScreen.routeName,
                      arguments: loadedPost.id).then((value){ postpv.emptyCurrentPost();});
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(5),
                      width: size.width * .3,
                      child: FadeInImage(
                          fit: BoxFit.cover,
                          placeholder: AssetImage('assets/img/logo.jpg'),
                          image: (loadedPost != null && loadedPost.pictures.length > 0)
                              ? NetworkImage(
                                  'http://thiqa-az.com/upload/post_imgs/${loadedPost.pictures[0]['picture_name']}')
                              : AssetImage('assets/img/logo.jpg')),
                    ),
                    Container(
                      width: size.width * .6,
                      child: ListTile(
                        title: loadedPost == null
                            ? Text('')
                            : Text(loadedPost.title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold)),
                        subtitle:  Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person, color: Colors.blue[700]),
                                  loadedPost == null
                                      ? Text('')
                                      : Container(
                                        width: 50,
                                        height: 25,
                                        child: FittedBox(
                                          fit:BoxFit.contain ,
                                          child: Text(loadedPost.userName)),
                                      ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.blue[700],
                                      ),
                                      loadedPost == null
                                          ? Text('')
                                          : Container(
                                              width: 40,
                                              height: 20,
                                              child: FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: Text(
                                                    loadedPost.governorateName,
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ))),
                                    ],
                                  ),
                                  Row(children: [
                                    Icon(
                                      Icons.timer,
                                      color: Colors.blue[700],
                                    ),
                                    loadedPost == null
                                        ? Text('')
                                        : Container(
                                          width: 50,
                                          height: 25,
                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                              child: Text(outputFormat
                                                  .format(loadedPost.createdAt)),
                                            ),
                                        ),
                                  ])
                                ],
                              ),
                            ],
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
