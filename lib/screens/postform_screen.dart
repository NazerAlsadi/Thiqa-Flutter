import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import '../screens/holder_screen.dart';
import '../providers/post_imgs.dart';
import '../providers/categories.dart';
import '../providers/governators.dart';
import '../providers/posts.dart';

/////////////////////////

import 'dart:convert';
import 'dart:io';

class PostFormScreen extends StatefulWidget {
  static const routeName = '/addNewPost';
  @override
  _PostFormScreenState createState() => _PostFormScreenState();
}

class _PostFormScreenState extends State<PostFormScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  Map<String, bool> validator = {};
  bool added = false;
  bool isAdding = false;
  bool allCorrect = true;
  FocusNode _focusNode = FocusNode();
  FocusNode _focusNode1 = FocusNode();
  List<Widget> fileListThumb;
  List<File> fileList = new List<File>();
  var imgProv;
  void showThumbs() {
    List<Widget> thumbs = new List<Widget>();
    fileList.forEach((element) {
      thumbs.insert(
          0,
          GestureDetector(
            onTap: () {
              fileList.remove(element);
              showThumbs();
            },
            child: Container(
                padding: EdgeInsets.all(1), child: new Image.file(element)),
          ));
    });
    setState(() {
      fileListThumb = thumbs;
    });
  }

  Future pickFiles() async {
    await FilePicker.getMultiFile(
      allowCompression: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'bmp', 'png', 'gif'],
    ).then((files) {
      if (files != null && files.length > 0) {
        files.forEach((element) {
          List<String> picExt = ['.jpg', '.jpeg', '.bmp', '.png', '.gif'];

          if (picExt.contains(path.extension(element.path)) &&
              fileList.indexWhere((e) => e.path == element.path) == -1) {
            fileList.add(element);
            showThumbs();
          }
        });
      }
    });
  }

  String _myActivity;
  String _myActivity1;
  String _myActivity2;
  // ignore: unused_field
  String _myActivityResult;
  List loadedChildCat = [];
  final _contentFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  Post _newPost = Post(
      governateId: 0, categoryId: 0, title: '', content: '', status: 'Active');

  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Governators>(context).fetchGovernators();
      setState(() {
        imgProv = Provider.of<PostImgs>(context);
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _contentFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 110.0, end: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    _focusNode1.addListener(() {
      if (_focusNode1.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });

    _myActivity = '';
    _myActivity1 = '';
    _myActivity2 = '';
    _myActivityResult = '';
  }

  Future<void> _saveForm() async {
    _form.currentState.validate();
    _form.currentState.save();
    setState(() {
      _myActivityResult = _myActivity;
    });
    _newPost.governateId == 0
        ? validator['governateId'] = false
        : validator['governateId'] = true;

    _newPost.categoryId == 0
        ? validator['categoryId'] = false
        : validator['categoryId'] = true;

    _newPost.title == ''
        ? validator['title'] = false
        : validator['title'] = true;
    _newPost.content == ''
        ? validator['content'] = false
        : validator['content'] = true;
    allCorrect = true;
    validator.forEach((key, value) {
      // ignore: unnecessary_statements
      value == false ? allCorrect = false : '';
    });

    if (allCorrect == true) {
      setState(() {
        isAdding = true;
      });
      Provider.of<Posts>(context, listen: false)
          .addPost(_newPost)
          .then((value) {
        final Map params = new Map();
        List<Map> attch = imgProv.toBase64(fileList);
        params["attachment"] = jsonEncode(attch);
        params["post_id"] = "$value";
        params["status"] = '${'active'}';
        imgProv.httpSend(params);
      }).then((value) {
        setState(() {
          isAdding = false;
          added = true;
        });

        var future = new Future.delayed(const Duration(seconds: 3));
        future.then((value) {
          Navigator.of(context).pushReplacementNamed(HolderScreen.routeName);
            
        });
      });
    } else {}

    // print('the id is ' + newPostId.toString());

    //Navigator.of(context).pushNamed(HolderScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final catProv = Provider.of<Categories>(context, listen: false);
    final govProv = Provider.of<Governators>(context);
    // ignore: unused_local_variable
    final size = MediaQuery.of(context).size;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: (added == false && isAdding == false)
            ?Scaffold(
        bottomNavigationBar: Container(
          width: double.infinity,
          child: RaisedButton(
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
        ),
        
        appBar: AppBar(
          title: Text('اضافة منشور جديد'),
          actions: [
            IconButton(icon: Icon(Icons.check),onPressed: (){
              _saveForm();
            },)
          ],
        ),
        body:SingleChildScrollView(
                child: Column(
                  children: [
                    _animation.value != 0.0
                        ? Container(
                            decoration: BoxDecoration(
                                border: Border.symmetric(
                                    vertical:
                                        BorderSide(color: Colors.black54))),
                            height: _animation.value,
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 10),
                                  child: IconButton(
                                    color: Theme.of(context).primaryColor,
                                    onPressed: () {
                                      pickFiles();
                                    },
                                    icon: Icon(
                                      Icons.add_photo_alternate,
                                      size: 50,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      ...fileListThumb != null
                                          ? fileListThumb
                                          : [],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _form,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            // category
                            Container(
                              height: _animation.value,
                              padding: EdgeInsets.all(2),
                              child: DropDownFormField(
                                titleText: 'الاصناف',
                                hintText: 'اختر صنف من فضلك',
                                value: _myActivity,
                                onSaved: (value) {
                                  _myActivity = value;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _myActivity = value;
                                    catProv
                                        .findChild(int.parse(_myActivity))
                                        .then((d) {
                                      loadedChildCat = [];
                                      _myActivity1 = '';
                                      loadedChildCat = catProv.subs;
                                      print("LCC: ${loadedChildCat.length}");
                                      print(value);
                                    });
                                  });
                                },
                                dataSource: [
                                  ...catProv.added.map((e) => {
                                        'display': "${e.categoryName}",
                                        'value': "${e.id}"
                                      })
                                ],
                                textField: 'display',
                                valueField: 'value',
                              ),
                            ),
                            validator['categoryId'] == false
                                ? Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'يرجى اختيار تنصيف',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 12),
                                    ))
                                : Container(),

                            // sub Category
                            loadedChildCat.length != 0
                                ? Container(
                                    height: _animation.value,
                                    padding: EdgeInsets.all(2),
                                    child: DropDownFormField(
                                      titleText: 'صنف فرعي',
                                      hintText: 'اختر صنف فرعي من فضلك',
                                      value: _myActivity1,
                                      onSaved: (value) {
                                        setState(() {
                                          _myActivity1 = value;
                                        });
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          _myActivity1 = value;
                                          _newPost = Post(
                                            governateId: _newPost.governateId,
                                            categoryId: int.parse(_myActivity1),
                                            title: _newPost.title,
                                            content: _newPost.content,
                                            status: _newPost.status,
                                          );
                                        });
                                      },
                                      dataSource: loadedChildCat
                                          .map((e) => {
                                                'display': "${e.categoryName}",
                                                'value': "${e.id}"
                                              })
                                          .toList(),
                                      textField: 'display',
                                      valueField: 'value',
                                    ),
                                  )
                                : Container(),

                            // governator
                            Container(
                              height: _animation.value,
                              padding: EdgeInsets.all(2),
                              child: DropDownFormField(
                                titleText: 'المحافظة',
                                hintText: 'اختر المحافظة من فضلك',
                                value: _myActivity2,
                                onSaved: (value) {
                                  _myActivity2 = value;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _myActivity2 = value;
                                    _newPost = Post(
                                      governateId: int.parse(_myActivity2),
                                      categoryId: _newPost.categoryId,
                                      title: _newPost.title,
                                      content: _newPost.content,
                                      status: _newPost.status,
                                    );
                                  });
                                },
                                dataSource: [
                                  ...govProv.all.map((e) => {
                                        'display': "${e.name}",
                                        'value': "${e.id}"
                                      })
                                ],
                                textField: 'display',
                                valueField: 'value',
                              ),
                            ),
                            validator['governateId'] == false
                                ? Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'يرجى اختيار محافظة',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 12),
                                    ))
                                : Container(),
                            // title
                            TextFormField(
                              focusNode: _focusNode,
                              decoration:
                                  InputDecoration(labelText: 'عنوان المنشور'),
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_contentFocusNode);
                              },
                              // ignore: missing_return
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'ادخل عنوان المنشور من فضلك ';
                                }
                              },
                              onSaved: (value) {
                                _newPost = Post(
                                  governateId: _newPost.governateId,
                                  categoryId: _newPost.categoryId,
                                  title: value,
                                  content: _newPost.content,
                                  status: _newPost.status,
                                );
                              },
                            ),

                            // content
                            TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'محتوى المنشور'),
                              maxLines: 3,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              focusNode: _focusNode1,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'ادخل المنشور من فضلك';
                                }
                                if (value.length < 15) {
                                  return 'يجب ادخال اكثر من 15 محرف';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _newPost = Post(
                                  governateId: _newPost.governateId,
                                  categoryId: _newPost.categoryId,
                                  title: _newPost.title,
                                  content: value,
                                  status: _newPost.status,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            
      ): (added == false && isAdding == true)
                ? Scaffold(
                  appBar: AppBar(),
                                  body: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.send,
                            size: 80,
                            color: Colors.deepOrange,
                          ),
                          Text(
                            'يتم إضافة الإعلان!',
                            style: TextStyle(fontSize: 26),
                          )
                        ],
                      ),
                    ),
                )
                : Scaffold(
                  appBar: AppBar(),
                                  body: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.done,
                            size: 80,
                            color: Colors.greenAccent,
                          ),
                          Text(
                            'تمت الإضافة بنجاح!',
                            style: TextStyle(fontSize: 26),
                          )
                        ],
                      ),
                    ),
                ),
    );
  }
}

@override
Widget build(BuildContext context) {
  
  throw UnimplementedError();
}
