import '../providers/categories.dart';
import '../providers/governators.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

import '../providers/posts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'holder_screen.dart';

class EditPostScreen extends StatefulWidget {
  static const routeName = '/editPost';
  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _form = GlobalKey<FormState>();
  final govController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    govController.dispose();
    super.dispose();
  }

  // parent cat
  String _myActivity = '';
  // son cat save in db
  String _myActivity1 = '';
  // governator
  String _myActivity2 = '';

  // list of category child
  List loadedChildCat = [];

  // post in dependencies
  Post _editedPost;

  // post after edited
  Post _newEditedPost = Post(
      governateId: 0, categoryId: 0, title: '', content: '', status: 'Active');

  var _isInit = true;
  var _isLoading = true;
  // very important
  var postId;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      //final
      final catProv = Provider.of<Categories>(context, listen: false);
      postId = ModalRoute.of(context).settings.arguments as int;

      Provider.of<Governators>(context, listen: false)
          .fetchGovernators()
          .then((value) {
        print('test 1');
        Provider.of<Posts>(context, listen: false)
            .getListTilePost(postId)
            .then((value) {
          setState(() {
            _myActivity2 = '${value.governateId}';
          });
        });
      });

      Provider.of<Categories>(context, listen: false)
          .fetchCategories()
          .then((value) {
        print('test 1');
        Provider.of<Posts>(context, listen: false)
            .getListTilePost(postId)
            .then((value) {
          print('test 2');
          setState(() {
            _editedPost = value;
            _myActivity = "${_editedPost.category['parent_cat_id']}";
            catProv.findChild(int.parse(_myActivity)).then((d) {
              loadedChildCat = [];
              _myActivity1 = '';
              loadedChildCat = catProv.subs;
              print("LCC: ${loadedChildCat.length}");
              print(value);
              _myActivity1 = "${_editedPost.categoryId}";
            });
            _isLoading = false;
          });
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    _form.currentState.validate();
    _form.currentState.save();

    Provider.of<Posts>(context, listen: false).editPost(_newEditedPost, postId);

    Navigator.of(context).pushNamed(HolderScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final catProv = Provider.of<Categories>(context, listen: false);
    final govProv = Provider.of<Governators>(context, listen: false);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('تعديل المنشور'),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(16),
                      child: DropDownFormField(
                        titleText: 'الاصناف',
                        hintText: 'اختر صنف من فضلك',
                        value: _myActivity,
                        onSaved: (value) {
                          _myActivity = value;
                        },
                        onChanged: (value) {
                          setState(() {
                            _myActivity1 = '';
                            _myActivity = "$value";
                            catProv.findChild(int.parse(_myActivity)).then((d) {
                              loadedChildCat = [];

                              loadedChildCat = catProv.subs;
                              print("LCC: ${loadedChildCat.length}");
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

                    // sub cat
                    // sub Category
                    loadedChildCat.length != 0
                        ? Container(
                            padding: EdgeInsets.all(16),
                            child: DropDownFormField(
                              titleText: 'صنف فرعي',
                              hintText: 'اختر صنف فرعي من فضلك',
                              value: _myActivity1,
                              onSaved: (value) {
                                setState(() {
                                  _myActivity1 = value;
                                  _newEditedPost = Post(
                                    governateId: _newEditedPost.governateId,
                                    categoryId: int.parse(_myActivity1),
                                    title: _newEditedPost.title,
                                    content: _newEditedPost.content,
                                    status: _newEditedPost.status,
                                  );
                                });
                              },
                              onChanged: (value) {
                                setState(() {
                                  _myActivity1 = value;
                                  _newEditedPost = Post(
                                    governateId: _newEditedPost.governateId,
                                    categoryId: int.parse(_myActivity1),
                                    title: _newEditedPost.title,
                                    content: _newEditedPost.content,
                                    status: _newEditedPost.status,
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
                      padding: EdgeInsets.all(16),
                      child: DropDownFormField(
                        titleText: 'المحافظة',
                        hintText: 'اختر المحافظة من فضلك',
                        value: _myActivity2,
                        onSaved: (value) {
                          setState(() {
                            _myActivity2 = '$value';
                            _newEditedPost = Post(
                              governateId: int.parse(_myActivity2),
                              categoryId: _newEditedPost.categoryId,
                              title: _newEditedPost.title,
                              content: _newEditedPost.content,
                              status: _newEditedPost.status,
                            );
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            _myActivity2 = "$value";
                            _newEditedPost = Post(
                              governateId: int.parse(_myActivity2),
                              categoryId: _newEditedPost.categoryId,
                              title: _newEditedPost.title,
                              content: _newEditedPost.content,
                              status: _newEditedPost.status,
                            );
                          });
                        },
                        dataSource: [
                          ...govProv.all.map((e) =>
                              {'display': "${e.name}", 'value': "${e.id}"})
                        ],
                        textField: 'display',
                        valueField: 'value',
                      ),
                    ),

                    TextFormField(
                      initialValue: _editedPost.title,
                      decoration: InputDecoration(labelText: 'عنوان المنشور'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        //  FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'يرجى ادخال عنوان للمنشور';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _newEditedPost = Post(
                          governateId: _newEditedPost.governateId,
                          categoryId: _newEditedPost.categoryId,
                          title: value,
                          content: _newEditedPost.content,
                          status: _newEditedPost.status,
                        );
                      },
                    ),

                    // content
                    TextFormField(
                      initialValue: _editedPost.content,
                      decoration: InputDecoration(labelText: 'محتوى المنشور'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
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
                        _newEditedPost = Post(
                          governateId: _newEditedPost.governateId,
                          categoryId: _newEditedPost.categoryId,
                          title: _newEditedPost.title,
                          content: value,
                          status: _newEditedPost.status,
                        );
                      },
                    ),

                    RaisedButton(
                      padding: const EdgeInsets.all(10),
                      color: Colors.blue[700],
                      child: Text(
                        'تعديل',
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
    );
  }
}
