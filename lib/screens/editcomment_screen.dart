import '../providers/comments.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditCommentScreen extends StatefulWidget {
  static const routeName = '/ediComment';

  @override
  _EditCommentScreenState createState() => _EditCommentScreenState();
}

class _EditCommentScreenState extends State<EditCommentScreen> {
  final _form = GlobalKey<FormState>();
  Comment _editedComment;
  Comment _newEditedComment =
      Comment(commentTitle: '', commentContent: '', status: 'active');
  var _isInit = true;
  var _isLoading = true;

  var commentId;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      commentId = ModalRoute.of(context).settings.arguments as int;
      Provider.of<Comments>(context).getComment(commentId).then((value) {
        setState(() {
          _editedComment = value;
          _isLoading = false;
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    _form.currentState.validate();
    _form.currentState.save();

    Provider.of<Comments>(context, listen: false)
        .editComment(_newEditedComment, commentId);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('تعديل التعليق'),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _editedComment.commentTitle,
                      decoration: InputDecoration(labelText: 'عنوان التعليق'),
                      textInputAction: TextInputAction.next,
                      
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'يرجى ادخال عنوان للمنشور';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _newEditedComment = Comment(
                          commentTitle: value,
                          commentContent: _newEditedComment.commentContent,
                          status: _newEditedComment.status,
                        );
                      },
                    ),

                    // content
                    TextFormField(
                      initialValue: _editedComment.commentContent,
                      decoration: InputDecoration(labelText: 'محتوى التعليق'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
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
                        _newEditedComment = Comment(
                          commentTitle: _newEditedComment.commentTitle,
                          commentContent: value,
                          status: _newEditedComment.status,
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
