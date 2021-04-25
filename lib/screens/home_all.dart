import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:listview_utils/listview_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/postdetail_screen.dart';
import '../widgets/carousal_img.dart';

class HomeAll extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomListView(
        initialOffset: 0,
        pageSize: 10,
        paginationMode: PaginationMode.page,
        loadingBuilder: CustomListLoading.defaultBuilder,
        header: Container(
          height: 150,
          child: CarousalImg(),
        ),
        footer: Container(
          height: 50,
          child: Center(
            child: Image.asset('assets/img/logo.jpg'),
          ),
        ),
        adapter: MyListAdapter(),
        // NetworkListAdapter(
        //   url: "http://thiqa-az.com/api/get-posts/0/$gov",
        //   limitParam: '_limit',
        //   offsetParam: '_start',
        // ),
        errorBuilder: (context, error, state) {
          print(error.toString());
          return Column(
            children: <Widget>[
              Text(error.toString()),
              RaisedButton(
                onPressed: () => state.loadMore(),
                child: Text('Retry'),
              ),
            ],
          );
        },
        separatorBuilder: (context, _) {
          return Divider(height: 1);
        },
        empty: Center(
          child:  Text('Empty'),
        ),
        itemBuilder: (context, _, item) {
          return Card(
            child: Container(
              height: 100,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(PostDetailScreen.routeName,
                      arguments: item['id']);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width * .3,
                      child: FadeInImage(
                          fit: BoxFit.cover,
                          placeholder: AssetImage('assets/img/logo.jpg'),
                          image: (item['pictures'].length > 0 && item['pictures'] !=null)
                              ? NetworkImage(
                                  'http://thiqa-az.com/upload/post_imgs/${item['pictures'][0]['picture_name']}' ,)
                              : AssetImage('assets/img/logo.jpg')),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .6,
                      child: ListTile(
                        title: Text(item['post_title'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person, color: Colors.blue[700]),
                                Container(
                                  width: 50,
                                  height: 25,
                                  child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(item['users']['name'])),
                                ),
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
                                    Container(
                                      width: 40,
                                      height: 20,
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          item['governorates']
                                              ['governorate_name'],
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.timer,
                                      color: Colors.blue[700],
                                    ),
                                    Container(
                                      width: 50,
                                      height: 25,
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(item['created_at']
                                            .substring(0, 9)
                                            .toString()),
                                      ),
                                    ),
                                  ],
                                )
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
        },
      ),
    );
  }
}

class MyListAdapter implements BaseListAdapter {
  var gov = 0;

  String x = "http://thiqa-az.com/api/get-posts/0/0";

  var page =0;
  @override
  // ignore: missing_return
  Future<ListItems> getItems(int offset, int limit) async {
    
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('gov') != null && page ==0) {
      this.gov = prefs.getInt('gov');
      this.x = "http://thiqa-az.com/api/get-posts/0/$gov";
    }
 
    try {
      final response = await http.get(x);
      print(json.decode(response.body)['data'].length);
      final data = json.decode(response.body)['data'];
      if (json.decode(response.body)['next_page_url'] != null) {
        page = page+1;
        this.x = json.decode(response.body)['next_page_url'];
        print('next page ... '+x);
      } else {
        x = "http://thiqa-az.com/api/get-posts/0/0";
      }
      return ListItems(data,
          reachedToEnd: json.decode(response.body)['next_page_url'] == null);
    } catch (e) {
      print(e);
    }
  }

  @override
  // ignore: missing_return
  bool shouldUpdate(MyListAdapter old) {
    // return old.url != url;
  }
}

// import 'dart:convert';
// import 'package:a_to_zApp/screens/postdetail_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../providers/posts.dart';

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;

// import 'package:listview_utils/listview_utils.dart';

// class HomeAll extends StatefulWidget {

//   @override
//   _HomeAllState createState() => _HomeAllState();
// }

// class _HomeAllState extends State<HomeAll> {
//   @override

//   // ignore: override_on_non_overriding_member
//   DateFormat dateFormat = DateFormat("yyyy-MM-dd");
//   bool _hasMore;
//   int _pageNumber;
//   bool _error;
//   bool _loading;
//   final int _defaultPhotosPerPageCount = 10;
//   List<Post> _posts;
//   final int _nextPageThreshold = 5;
//   //var size;
//   @override
//   void initState() {
//     //size = MediaQuery.of(context).size;
//     super.initState();
//     _hasMore = true;
//     _pageNumber = 1;
//     _error = false;
//     _loading = true;
//     _posts = [];
//     fetchPosts();
//   }

//   Future<void> fetchPosts() async {
//     var gov = 0;
//     final prefs = await SharedPreferences.getInstance();
//     if (prefs.getInt('gov') != null) {
//       gov = prefs.getInt('gov');
//     }
//     try {
//       final response = await http.get(
//           "http://thiqa-az.com/api/get-posts/0/$gov",
//           headers: {"Accept": "application/json"});
//       final extractedData = json.decode(response.body);
//       //print(extractedData);
//       List<Post> fetchedPosts = [];
//       for (int i = 0; i < extractedData.length; i++) {
//         fetchedPosts.add(
//           Post(
//             id: extractedData[i]['id'],
//             categoryId: extractedData[i]['category_id'],
//             governorateName:
//                 extractedData[i]['governorates']['governorate_name'].toString(),
//             userName: extractedData[i]['users']['name'].toString(),
//             title: extractedData[i]['post_title'].toString(),
//             content: extractedData[i]['post_content'].toString(),
//             status: extractedData[i]['status'].toString(),
//             createdAt: (extractedData[i]['created_at']),
//           ),
//         );
//       }
//       setState(() {
//         _hasMore = fetchedPosts.length == _defaultPhotosPerPageCount;
//         _loading = false;
//         _pageNumber = _pageNumber + 1;
//         _posts = fetchedPosts;
//       });
//     } catch (e) {
//       //  print(e);
//       if (mounted)
//         setState(() {
//           _loading = false;
//           _error = true;
//         });
//     }
//   }

//   Widget getBody() {
//     if (_posts.isEmpty) {
//       if (_loading) {
//         return Center(
//             child: Padding(
//           padding: const EdgeInsets.all(8),
//           child: CircularProgressIndicator(),
//         ));
//       } else if (_error) {
//         return Center(
//             child: InkWell(
//           onTap: () {
//             setState(() {
//               _loading = true;
//               _error = false;
//               fetchPosts();
//             });
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Text("Error while loading photos, tap to try again"),
//           ),
//         ));
//       }
//     } else {
//       // ....
//       return ListView.builder(
//           itemCount: _posts.length + (_hasMore ? 1 : 0),
//           itemBuilder: (context, index) {
//             if (index == _posts.length - _nextPageThreshold) {
//               fetchPosts();
//             }
//             if (index == _posts.length) {
//               if (_error) {
//                 return Center(
//                     child: InkWell(
//                   onTap: () {
//                     setState(() {
//                       _loading = true;
//                       _error = false;
//                       fetchPosts();
//                     });
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Text("Error while loading photos, tap to try agin"),
//                   ),
//                 ));
//               } else {
//                 return Center(
//                     child: Padding(
//                   padding: const EdgeInsets.all(8),
//                   child: CircularProgressIndicator(),
//                 ));
//               }
//             }
//             final Post post = _posts[index];
//             return Card(
//               child: Container(
//                 height: 100,
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.of(context).pushNamed(PostDetailScreen.routeName,
//                         arguments: post.id);
//                   },
//                   child: Row(
//                     children: [
//                       Container(
//                         margin: EdgeInsets.all(5),
//                         width: MediaQuery.of(context).size.width *.3,
//                         child: FadeInImage(
//                             fit: BoxFit.cover,
//                             placeholder: AssetImage('assets/img/logo.png'),
//                             image: AssetImage('assets/img/logo.png')),
//                       ),
//                       Container(
//                         width: MediaQuery.of(context).size.width *.6,
//                         child: ListTile(
//                           title: Text(
//                             post.title,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                                 fontSize: 18.0, fontWeight: FontWeight.bold),
//                           ),
//                           subtitle: Column(
//                             children: [
//                               Row(
//                                 children: [
//                                   Icon(Icons.person, color: Colors.blue[700]),
//                                   Container(
//                                     width: 50,
//                                     height: 25,
//                                     child: FittedBox(
//                                       fit: BoxFit.contain,
//                                       child: Text(post.userName),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: 5,
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Icon(
//                                         Icons.location_on,
//                                         color: Colors.blue[700],
//                                       ),
//                                       Container(
//                                         width: 40,
//                                         height: 20,
//                                         child: FittedBox(
//                                           fit: BoxFit.contain,
//                                           child: Text(
//                                             post.governorateName,
//                                             style: TextStyle(fontSize: 10),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     children: [
//                                       Icon(
//                                         Icons.timer,
//                                         color: Colors.blue[700],
//                                       ),
//                                       Container(
//                                           width: 50,
//                                           height: 25,
//                                           child: FittedBox(
//                                             fit: BoxFit.contain,
//                                               child: Text(post.createdAt.toString()),
//                                             ),
//                                         ),
//                                     ],
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           });
//     }
//     return Container();
//   }

//   Widget build(BuildContext context) {
//     return getBody();
//   }
// }
