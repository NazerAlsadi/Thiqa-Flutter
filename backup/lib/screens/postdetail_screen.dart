import 'package:a_to_zApp/providers/post_imgs.dart';
import 'package:a_to_zApp/screens/holder_screen.dart';

import '../providers/auth.dart';
import '../providers/comments.dart';
import '../providers/favories.dart';

import '../screens/editcomment_screen.dart';
import '../screens/editpost_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/posts.dart';

class PostDetailScreen extends StatefulWidget {
  static const routeName = '/details';

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen>
    with SingleTickerProviderStateMixin {
  // ignore: unused_field
  AnimationController _controller;
  // ignore: unused_field
  Animation _animation;
  // ignore: unused_field
  FocusNode _focusNode = FocusNode();
  BuildContext cxt;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose(); // You need to do this.

    super.dispose();
  }

  Comment _newComment = Comment(
      postId: 0,
      userId: 1,
      commentTitle: '',
      commentContent: '',
      status: 'temp');
  // ignore: unused_field
  var _isEditable;
  var user;
  var post;
  var userDetails;
  final _form = GlobalKey<FormState>();

  final _contentFocusNode = FocusNode();
  
  _comments(context, post) {
    final _formKey = GlobalKey<FormState>();
    final postpv = Provider.of<Posts>(context, listen: false);
    final postId = ModalRoute.of(context).settings.arguments as int;
    final commentPv = Provider.of<Comments>(context, listen: false);
  
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                height: MediaQuery.of(context).size.height * .8,
                child: Column(
                  children: [
                    Expanded(
                      child: FutureBuilder(
                          future: commentPv.getComments("$postId"),
                          builder: (context, postData) {
                            if (postData.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (postData.connectionState ==
                                    ConnectionState.done &&
                                postData.data == null) {
                              return Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.error,
                                      size: 60,
                                    ),
                                    Text(
                                      'حدث خطأ أثناء التحميل',
                                      style: TextStyle(
                                          fontSize: 40, color: Colors.grey),
                                    ),
                                    RaisedButton(
                                      child: Text('إعادة المحاولة'),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                EditPostScreen.routeName,
                                                arguments: postId);
                                      },
                                    )
                                  ],
                                ),
                              );
                            }
                            
                            var comments = commentPv.comments;
                      
                            return comments.length > 0
                                ? Container(
                                    padding: EdgeInsets.all(10),
                                    child: ListView.builder(
                                      itemCount: comments.length,
                                      itemBuilder: (context, i) => comments[i]['users']!=null && comments[i]['deleting']!=true
                                          ? Container(
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 40,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .only(top: 7),
                                                              width: 40,
                                                              height: 40,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              child: Icon(
                                                                  Icons.person,
                                                                  size: 40,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                  '${comments[i]['users']['name']}',
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor)),
                                                            ),
                                                            Text(
                                                              '${DateTime.parse(comments[i]['created_at']).year}-${DateTime.parse(comments[i]['created_at']).month}-${DateTime.parse(comments[i]['created_at']).day} ${DateTime.parse(comments[i]['created_at']).toLocal().hour}:${DateTime.parse(comments[i]['created_at']).toLocal().minute}',
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            )
                                                          ],
                                                        ),
                                                        "${Provider.of<Auth>(context).userId}" ==
                                                                "${comments[i]['user_id']}"
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            50),
                                                                child:
                                                                    IconButton(
                                                                  icon: Icon(
                                                                      Icons
                                                                          .edit,
                                                                      size: 20,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(context).pushNamed(
                                                                        EditCommentScreen
                                                                            .routeName,
                                                                        arguments:
                                                                            comments[i]['id']);
                                                                  },
                                                                ),
                                                              )
                                                            : Text(''),


                                                            "${Provider.of<Auth>(context).userId}" ==
                                                                "${comments[i]['user_id']}"
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            50),
                                                                child:
                                                                    IconButton(
                                                                  icon: Icon(
                                                                      Icons
                                                                          .delete,
                                                                      size: 20,
                                                                      color: Colors.redAccent),
                                                                  onPressed:
                                                                      () {
                                                                        
                                                                    commentPv.deleteComment(comments[i]['id']).then((value){
                                                                      Navigator.of(context).pop();
                                                                    });
                                                                  },
                                                                ),
                                                              )
                                                            : Text(''),












                                                      ],
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              20,
                                                      decoration: BoxDecoration(
                                                          color: Colors.black12,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .elliptical(
                                                                          10,
                                                                          10))),
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      margin:
                                                          EdgeInsets.all(10),
                                                      child: Text(
                                                        '${comments[i]['comment_content']}',
                                                        overflow: TextOverflow
                                                            .visible,
                                                      ),
                                                    ),
                                                  ]),
                                            )
                                          : Container(),
                                    ),
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          Icons.add_comment,
                                          color: Colors.grey[350],
                                          size: 50,
                                        ),
                                        Text('أكتب أول تعليق!',
                                            style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.grey[600]))
                                      ],
                                    ),
                                  );
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Container(
                        height: 80,
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.black12),
                        child: Row(
                          children: [
                            Container(
                                padding: EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width - 50,
                                child: Form(
                                  key: _formKey,
                                  child: TextField(
                                    textInputAction: TextInputAction.newline,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 2,
                                    controller: _commentController,
                                    decoration: InputDecoration(
                                        hintText: 'اضغط لكتابة تعليق'),
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                )),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.send, color: Colors.black54),
                                  onPressed: () {
                                    if (_commentController != null &&
                                        _commentController.text != '') {
                                      commentPv
                                          .addComment(Comment(
                                              postId: post['id'],
                                              commentContent:
                                                  _commentController.text,
                                              commentTitle: '',
                                              status: 'temp'))
                                          .then((value) =>
                                              _commentController.clear());
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    }
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

  // ignore: unused_element
  _buildModalComment() {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * .9,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Form(
              key: _form,
              child: Column(
                children: <Widget>[
                  // title
                  TextFormField(
                    decoration: InputDecoration(labelText: 'عنوان التعليق'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_contentFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'ادخل عنوان التعليق من فضلك ';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _newComment = Comment(
                          userId: _newComment.userId,
                          postId: _newComment.postId,
                          commentTitle: value,
                          commentContent: _newComment.commentContent);
                    },
                  ),

                  // content
                  TextFormField(
                    decoration: InputDecoration(labelText: 'التعليق'),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    focusNode: _contentFocusNode,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'ادخل التعليق من فضلك';
                      }
                      if (value.length < 15) {
                        return 'يجب ادخال اكثر من 15 محرف';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _newComment = Comment(
                          userId: _newComment.userId,
                          postId: _newComment.postId,
                          commentTitle: _newComment.commentTitle,
                          commentContent: value);
                    },
                  ),

                  RaisedButton(
                    padding: const EdgeInsets.all(10),
                    color: Colors.blue[700],
                    child: Text(
                      'نشر',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onPressed: () {
                      _saveForm();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveForm() {
    final postId = ModalRoute.of(context).settings.arguments as int;
    _form.currentState.validate();
    _form.currentState.save();
    Provider.of<Comments>(context, listen: false).addComment(_newComment);
    Navigator.of(context)
        .pushNamed(PostDetailScreen.routeName, arguments: postId);
  }

  Favorite newFav = Favorite(categoryId: 0, postId: 0);

  @override
  Widget build(BuildContext context) {
    cxt = context;
    // ignore: unused_local_variable
    final size = MediaQuery.of(context).size;
    final postId = ModalRoute.of(context).settings.arguments as int;
    _newComment.postId = postId;
    // ignore: unused_local_variable
    final user = Provider.of<Auth>(context, listen: false).getUser();
    final postpv = Provider.of<Posts>(context, listen: false);

    String userId = Provider.of<Auth>(context).userId;
    print("The UserId is " + userId);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: FutureBuilder(
          future: postpv.fetchPostDetails(postId),
          builder: (context, postData) {
            if (postData.connectionState == ConnectionState.done &&
                postData.data == null) {
              return Scaffold(
                appBar: AppBar(),
                body: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.error,
                        size: 60,
                      ),
                      Text(
                        'حدث خطأ أثناء التحميل',
                        style: TextStyle(fontSize: 40, color: Colors.grey),
                      ),
                      RaisedButton(
                        child: Text('إعادة المحاولة'),
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(
                              EditPostScreen.routeName,
                              arguments: postId);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
            post = Provider.of<Posts>(context, listen: false).currentPost;
           // print("The Post user id is " + '${post['user_id']}' );
            List<Widget> pictures = [];
            if (post != null &&
                post['pictures'] != null &&
                post['pictures'].length > 0) {
              post['pictures'].forEach((element) {
                pictures.add(GridTile(
                  child: Container(
                    margin: EdgeInsets.all(3),
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    width: double.infinity,
                    child: Stack(children: <Widget>[
                      FadeInImage(
                        fit: BoxFit.cover,
                        placeholder:
                            AssetImage('assets/img/img-placeholder.gif'),
                        image: NetworkImage(
                            'http://thiqa-az.com/upload/post_imgs/${element['picture_name']}'),
                      ),
                      '${userId}' == '${post['user_id']}'?
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red[300],
                              size: 32,
                            ),
                            onPressed: (){
                               Provider.of<PostImgs>(context , listen: false).deleteImg(
                                element['id']
                               );
                               Navigator.of(context).pushReplacementNamed(PostDetailScreen.routeName , arguments: post['id']);
                              
                            }
                            )
                      ):Container()
                    ]),
                  ),
                ));
              });
            }

            return (post != null && "${post['id']}" == "$postId")
                ? Scaffold(
                    bottomNavigationBar: BottomAppBar(
                      color: Colors.grey[300],
                      elevation: 100,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            post != null
                                ? Text(
                                    '${post["up_rating"]}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54),
                                  )
                                : Text('0'),
                            IconButton(
                              icon: Icon(
                                Icons.thumb_up,
                                size: 30,
                                color: Colors.black54,
                              ),
                              onPressed: () {
                                postpv.rate(postId, 1);
                              },
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            post != null
                                ? Text(
                                    '${post["down_rating"]}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54),
                                  )
                                : Text('0'),
                            IconButton(
                              icon: Icon(
                                Icons.thumb_down,
                                color: Colors.black54,
                                size: 30,
                              ),
                              onPressed: () {
                                postpv.rate(postId, -1);
                              },
                            ),
                            SizedBox(
                              width: 130,
                            ),
                            post != null
                                ? Text('${(post["comments"]).length}')
                                : Text('0'),
                            IconButton(
                              onPressed: () {
                                _comments(context, post);
                              },
                              icon: Icon(Icons.mode_comment,
                                  color: Colors.black54, size: 30),
                            ),
                          ],
                        ),
                      ),
                    ),
                    appBar: AppBar(
                      actions: [
                        (post != null &&
                                "${Provider.of<Auth>(context).userId}" ==
                                    "${post['user_id']}")
                            ? IconButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      EditPostScreen.routeName,
                                      arguments: postId);
                                },
                                icon: Icon(
                                  Icons.edit,
                                ),
                              )
                            : Container(),
                        
                        (post != null &&
                                "${Provider.of<Auth>(context).userId}" ==
                                    "${post['user_id']}")
                            ? IconButton(
                                onPressed: () {
                                  postpv.deletePost(postId);
                                  Navigator.of(context).pushReplacementNamed(HolderScreen.routeName);
                                },
                                icon: Icon(
                                  Icons.delete,
                                ),
                              )
                            : Container(),

                      ],
                    ),
                    body: SafeArea(
                      child: Card(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.all(10),
                                            width: 40,
                                            height: 40,
                                            child: ClipRRect(
                                              child: Container(
                                                  padding: EdgeInsets.only(
                                                      right: 0, top: 7),
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                      border: Border.all(
                                                          color: Colors.grey)),
                                                  child: Icon(
                                                    Icons.person,
                                                    color: Colors.white,
                                                    size: 40,
                                                  )),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${post['users']['name']}',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                '${DateTime.parse(post['created_at']).year}-${DateTime.parse(post['created_at']).month}-${DateTime.parse(post['created_at']).day} ${DateTime.parse(post['created_at']).toLocal().hour}:${DateTime.parse(post['created_at']).toLocal().minute}',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black54),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        (post != null &&
                                                post['favorite_list'].contains(
                                                    int.parse(Provider.of<Auth>(
                                                            context)
                                                        .userId)))
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: (post != null &&
                                                post['favorite_list'].contains(
                                                    int.parse(Provider.of<Auth>(
                                                            context)
                                                        .userId)))
                                            ? Colors.yellow[800]
                                            : Colors.grey,
                                        size: 35,
                                      ),
                                      onPressed: () {
                                        Provider.of<Posts>(context,
                                                listen: false)
                                            .addFavorite(Favorite(
                                                postId: postId,
                                                userId: int.parse(userId)));
                                      },
                                    )
                                  ]),
                              Divider(),
                              Container(
                                padding: EdgeInsets.only(right: 10),
                                alignment: Alignment.centerRight,
                                child: Hero(
                                  transitionOnUserGestures: true,
                                  tag: "${post['id']}",
                                  child: Text(
                                    '${post['post_title']}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 10),
                                alignment: Alignment.topRight,
                                child: Text('${post['post_content']}'),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 5),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.pin_drop,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        Text(
                                            '${post['governorates']['governorate_name']}')
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.category,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        Text(
                                            '${post['categories']['category_name']}'),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Divider(),
                              ...pictures
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Scaffold(
                    appBar: AppBar(),
                    body: Center(
                      child: CircularProgressIndicator(),
                    ));
          },),
    );
    // return SafeArea(
    //       child: Directionality(
    //     textDirection: TextDirection.rtl,
    //     child: DefaultTabController(
    //       length: 3,
    //       child: Scaffold(
    //         appBar: AppBar(
    //           //  title: Text('تعديل المنشور'),

    //           actions: [
    //             _isEditable == true
    //                 ? IconButton(
    //                     onPressed: () {
    //                       Navigator.of(context).pushNamed(
    //                           EditPostScreen.routeName,
    //                           arguments: postId);
    //                     },
    //                     icon: Icon(
    //                       Icons.edit,
    //                     ),
    //                   )
    //                 : Container(),
    //           ],
    //           bottom: TabBar(
    //             indicatorWeight: 4.0,
    //             indicatorColor: Colors.blue[700],
    //             tabs: [
    //               Tab(
    //                 child: Text(
    //                   'معلومات',
    //                   style: TextStyle(fontSize: 20),
    //                 ),
    //               ),
    //               Tab(
    //                 child: Text(
    //                   'الصور',
    //                   style: TextStyle(fontSize: 20),
    //                 ),
    //               ),
    //               Tab(
    //                 child: Text(
    //                   'التعليقات',
    //                   style: TextStyle(fontSize: 20),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         body: FutureBuilder(
    //           future: post.fetchPostDetails(postId),
    //           // ignore: missing_return
    //           builder: (context, postData) {
    //             if (postData.connectionState == ConnectionState.waiting) {
    //               return Center(child: CircularProgressIndicator());
    //             }
    //             if (postData.connectionState == ConnectionState.done &&
    //                 postData.data == null) {
    //               return Center(
    //                 child: Text('Empty Post!'),
    //               );
    //             }
    //             if (postData.connectionState == ConnectionState.done &&
    //                 postData.data != null) {
    //               print(postData.data.body);
    //               var post = json.decode(postData.data.body);
    //               if(_isEditable==null)
    //               user.then((value){
    //                 value['id']==post['user_id']?_isEditable=true:_isEditable=false;
    //                 setState(() {_isEditable=_isEditable;});
    //               });
    //               newFav.postId = post['id'];
    //               newFav.categoryId = post['category_id'];

    //               return TabBarView(
    //                 children: [
    //                   ListView(
    //                     children: [
    //                       Card(
    //                         child: Column(
    //                           children: [
    //                             ListTile(
    //                               title: Container(
    //                                 padding: EdgeInsets.all(10),
    //                                   child: Text(
    //                                 '${post['post_title']}',
    //                                 style: TextStyle(fontWeight: FontWeight.bold),
    //                               )),
    //                               trailing: IconButton(
    //                                   icon: Icon(Icons.favorite),
    //                                   onPressed: () {
    //                                     Provider.of<Favorites>(context,
    //                                             listen: false)
    //                                         .addFavorite(newFav);
    //                                   }),
    //                               subtitle: Padding(
    //                                 padding: const EdgeInsets.all(2),
    //                                 child: Column(
    //                                   children: <Widget>[
    //                                     Row(
    //                                       mainAxisAlignment:
    //                                           MainAxisAlignment.spaceBetween,
    //                                       children: [
    //                                         Row(
    //                                           children: [
    //                                             Icon(
    //                                               Icons.timer,
    //                                               color: Colors.blue[700],
    //                                             ),
    //                                             FittedBox(
    //                                                 fit: BoxFit.fitWidth,
    //                                                 child: Text(
    //                                                     '${DateTime.parse(post['created_at']).year}/${DateTime.parse(post['created_at']).month}/${DateTime.parse(post['created_at']).day} ${DateTime.parse(post['created_at']).toLocal().hour}:${DateTime.parse(post['created_at']).toLocal().minute}')),
    //                                           ],
    //                                         ),
    //                                       ],
    //                                     ),
    //                                     SizedBox(
    //                                       height: 13,
    //                                     ),
    //                                     Row(
    //                                       mainAxisAlignment:
    //                                           MainAxisAlignment.spaceBetween,
    //                                       children: [
    //                                         Row(
    //                                           children: [
    //                                             Icon(
    //                                               Icons.location_on,
    //                                               color: Colors.blue[700],
    //                                             ),
    //                                             Text(
    //                                                 '${post['governorates']['governorate_name']}'),
    //                                           ],
    //                                         ),
    //                                         Row(
    //                                           children: [
    //                                             Icon(
    //                                               Icons.person,
    //                                               color: Colors.blue[700],
    //                                             ),
    //                                             Text('${post['users']['name']}'),
    //                                           ],
    //                                         ),
    //                                       ],
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                             ),
    //                             Divider(
    //                               color: Theme.of(context).primaryColor,
    //                               indent: 5,
    //                               endIndent: 5,
    //                               height: 20,
    //                               thickness: 2,
    //                             ),
    //                             Container(
    //                               alignment: Alignment.topRight,
    //                               padding: const EdgeInsets.all(20.0),
    //                               child: Text(
    //                                 '${post['post_content']}',
    //                                 textAlign: TextAlign.right,
    //                                 style: TextStyle(fontSize: 18),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                   ListView.builder(
    //                     itemCount: post['pictures'].length,
    //                     itemBuilder: (context, i) => post['pictures'][i]
    //                                 ['deleted'] ==
    //                             null
    //                         ? Container(
    //                             width: size.width * .9,
    //                             height: size.height * .3,
    //                             padding: const EdgeInsets.all(15),
    //                             child: Row(
    //                               children: <Widget>[
    //                                 IconButton(
    //                                   icon: Icon(Icons.delete),
    //                                   onPressed: () {
    //                                     // post['pictures']['id];
    //                                     Provider.of<PostImgs>(context,
    //                                             listen: false)
    //                                         .deleteImg(post['pictures'][i]['id'])
    //                                         .then((value) {
    //                                       print("ttt:" + value);
    //                                       if (value == '"deleted successfully"') {
    //                                         setState(() {
    //                                           print('tttttf');
    //                                           post['pictures'][i]['deleted'] =
    //                                               true;
    //                                         });
    //                                       }
    //                                     });
    //                                     //Navigator.of(context).pop();
    //                                   },
    //                                 ),
    //                                 Expanded(
    //                                   child: FadeInImage(
    //                                     fit: BoxFit.cover,
    //                                     placeholder: AssetImage(
    //                                         'assets/img/img-placeholder.gif'),
    //                                     image: NetworkImage(
    //                                       'http://thiqa-az.com/upload/post_imgs/${post['pictures'][i]
    //                                                   ['picture_name']}'

    //                                     ),
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),
    //                           )
    //                         : Container(),
    //                   ),
    //                   Column(
    //                     children: [
    //                       Expanded(
    //                         child: ListView.builder(
    //                           itemCount: post['comments'].length,
    //                           itemBuilder: (context, i) => ListTile(
    //                             leading: Text(
    //                                 '${post['comments'][i]['users']['name']}'),
    //                             title: Text(
    //                                 '${post['comments'][i]['comment_title']}'),
    //                             subtitle: Text(
    //                                 '${post['comments'][i]['comment_content']}'),
    //                             trailing: IconButton(
    //                               icon: Icon(Icons.edit),
    //                               onPressed: () {
    //                                 Navigator.of(context).pushNamed(
    //                                     EditCommentScreen.routeName,
    //                                     arguments: post['comments'][i]['id']);
    //                               },
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                       RaisedButton(
    //                         padding: const EdgeInsets.all(10),
    //                         color: Colors.blue[700],
    //                         child: Text(
    //                           'اضافة تعليق جديد',
    //                           style: TextStyle(color: Colors.white),
    //                         ),
    //                         onPressed: () {
    //                           _buildModalComment();
    //                         },
    //                       )
    //                     ],
    //                   ),
    //                 ],
    //               );
    //             }
    //           },
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
