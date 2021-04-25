import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Comment {
  final int id;
  final int userId;
  int postId;
  final String commentTitle;
  final String commentContent;
  final String status;
  String createdAt; 
  Comment(
      {
      this.id,
      this.userId,
      this.postId,
      this.commentTitle,
      this.commentContent,
      this.status,
      this.createdAt,
      });
}


class Comments with ChangeNotifier {
  final String authToken ;
 List<dynamic> _comments = []; 
  Comments(this.authToken);

  get comments {
    return _comments;
  }
  Future getComments(String postId) async
  {
    var response = await http.get('http://thiqa-az.com/api/comments/$postId');
    List commentsData = json.decode(response.body);
    _comments=commentsData;
   // notifyListeners();
    return _comments;
  }
  Future<dynamic> addComment(Comment comment) async {
    const url = 'http://thiqa-az.com/api/comments';
    var data = {
      "post_id": "${comment.postId}",
      "comment_title": "${comment.commentTitle}",
      "comment_content": "${comment.commentContent}",
      "status": "${comment.status}",
    };
    

    var response = await http.post(
      url,
      headers: {"Accept": "application/json" , 'Authorization' : 'Bearer $authToken' },
      body: data,
    );
    
    print("response: ${response.body}");
    notifyListeners();
    return json.decode(response.body);
    
  }

  
  // ignore: missing_return
  Future<Comment> getComment(int id) async {
    final myUrl = "http://thiqa-az.com/api/comments/$id";
    try {
      final response =
          await http.get(myUrl, headers: {"Accept": "application/json"});
      final extractedData = json.decode(response.body);
      Comment loadedComment;
      loadedComment = Comment(
        id: extractedData['id'],
        commentTitle: extractedData['comment_title'].toString(),
        commentContent: extractedData['comment_content'].toString(),
        status: extractedData['status'].toString(),
        createdAt:extractedData['created_at']
      );
      return loadedComment;
    } catch (error) {
      print(error);
    }
  }


  Future<String> editComment(Comment comment , int commentId) async {
    final url = 'http://thiqa-az.com/api/comments/$commentId';
    var data = {
      "comment_title": "${comment.commentTitle}",
      "comment_content": "${comment.commentContent}",
    };
    print(data);
    //, 'Authorization' : 'Bearer $authToken'
    var response = await http.put(
      url,
      headers: {"Accept": "application/json"},
      body: data,
    );
    print("response: ${response.body}");
    return "${response.body}";
    
  }

  Future deleteComment(int commentId)async{
    _comments.removeWhere((element){ return "${element['id']}"=="$commentId";});
    
    final url = 'http://thiqa-az.com/api/comments/$commentId';
    
    var response = await http.delete(url);
    List commentsData = json.decode(response.body);
    _comments=commentsData;
    notifyListeners();
    
    
    
    
  }

}
