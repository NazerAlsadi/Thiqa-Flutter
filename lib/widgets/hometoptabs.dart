import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../screens/home_all.dart';
import '../screens/postdetail_screen.dart';
import '../providers/categories.dart';
import '../providers/posts.dart';



class HomeTopTabs extends StatefulWidget {
  final int id;

  HomeTopTabs(this.id);

  _HomeTopTabsState createState() => _HomeTopTabsState();
}

class _HomeTopTabsState extends State<HomeTopTabs> {
  TabController _tabController;
  // ignore: unused_field
  var _isInit = true;
  var _isLoading = false;
  var outputFormat = DateFormat("yyyy-MM-dd");
  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     setState(() {
  //       _isLoading = true;
  //     });

  //     Provider.of<Posts>(context).findPosts(widget.id).catchError((error) {
  //       return showDialog(
  //           context: context,
  //           builder: (ctx) => AlertDialog(
  //                 title: Text('an error occured !'),
  //                 content: Text('something wrong!'),
  //                 actions: [
  //                   FlatButton(
  //                       onPressed: () => Navigator.of(context).pop(),
  //                       child: Text('ok'))
  //                 ],
  //               ));
  //     }).then((value) {
  //       if (mounted)
  //         setState(() {
  //           _isLoading = false;
  //         });
  //     });
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List loadedList = [];
    final catProvider = Provider.of<Categories>(context, listen: false);
    loadedList = catProvider.childs(widget.id);

    final postProvider = Provider.of<Posts>(context);

   

    if (loadedList.length == 0) {
      if (widget.id == 1) {
        return ListView(children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: size.height - 200),
            child: HomeAll(),
          ),
        ]);
      } else {
        return _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            // : (loadedPost.length == 0)
            //     ? Container(
            //         child: Center(
            //             child: Text(
            //         'لا يوجد أي إعلان بعد!',
            //         style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            //       )))
            // : ListView.builder(
            //     itemCount: loadedPost.length,
            //     itemBuilder: (ctx, i) => loadedPost.length == 0 ?
            //     Container(
            //     child: Center(
            //         child: Text(
            //     'لا يوجد أي إعلان بعد!',
            //     style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            //   )))
            //     :CustomListtile(loadedPost[i].id),
            //   );
            : FutureBuilder(
                future: postProvider.findPosts(widget.id),
                // ignore: missing_return
                builder: (context, postData) {
                  if (postData.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (postData.connectionState == ConnectionState.done &&
                      postData.data == null) {
                    return Center(
                      child: Text('Empty Post!'),
                    );
                  }

                  if (postData.connectionState == ConnectionState.done &&
                      postData.data != null) {
                    print('here is ..' + postData.data.body.length.toString());
                    var post = json.decode(postData.data.body);
                    print(post.length);
                    return post.length == 0
                        ? Center(
                            child: Text(
                              'لا يوجد أي إعلان بعد!',
                              style: TextStyle(
                                  fontSize: 36, fontWeight: FontWeight.bold),
                            ),
                          )
                        : ListView.builder(
                            itemCount: post.length,
                            itemBuilder: (context, i) => Card(
                                  child: Container(
                                    height: 100,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(PostDetailScreen.routeName , arguments: post[i]['id']);
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.all(5),
                                            width: size.width * .3,
                                            child: FadeInImage(
                                                fit: BoxFit.cover,
                                                placeholder: AssetImage(
                                                    'assets/img/logo.jpg'),
                                                image: (post != null &&
                                                        post[i]['pictures']
                                                                .length >
                                                            0)
                                                    ? NetworkImage(
                                                        'http://thiqa-az.com/upload/post_imgs/${post[i]['pictures'][0]['picture_name']}')
                                                    : AssetImage(
                                                        'assets/img/logo.jpg')),
                                          ),
                                          Container(
                                            width: size.width * .6,
                                            child: ListTile(
                                              title: Text(
                                                post[i]['post_title'],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              subtitle: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Icon(Icons.person,
                                                          color:
                                                              Colors.blue[700]),
                                                      Container(
                                                        width: 50,
                                                        height: 25,
                                                        child: FittedBox(
                                                          fit: BoxFit.contain,
                                                          child: Text(post[i]
                                                                  ['users']
                                                              ['name']),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.location_on,
                                                            color: Colors
                                                                .blue[700],
                                                          ),
                                                          Container(
                                                            width: 40,
                                                            height: 20,
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .contain,
                                                              child: Text(
                                                                post[i]['governorates']
                                                                    [
                                                                    'governorate_name'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.timer,
                                                            color: Colors
                                                                .blue[700],
                                                          ),
                                                          Container(
                                                            width: 50,
                                                            height: 25,
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .contain,
                                                              child: Text(post[
                                                                          i][
                                                                      'created_at']
                                                                  .substring(
                                                                      0, 9)
                                                                  .toString()),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
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
                                )
                            // : Center(child: Text('hhh'),),
                            );
                  }
                });
      }
    } else
      return DefaultTabController(
        length: loadedList.length,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: AppBar(
              backgroundColor: Colors.grey[100],
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorWeight: 4.0,
                indicatorColor: Colors.blue[700],
                unselectedLabelColor: Colors.red,
                tabs: List<Widget>.generate(loadedList.length, (int index) {
                  return new Tab(
                    child: Text(
                      loadedList[index].categoryName,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }),
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: List<Widget>.generate(
                    loadedList.length,
                    (int index) {
                      return new HomeTopTabs(loadedList[index].id);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
