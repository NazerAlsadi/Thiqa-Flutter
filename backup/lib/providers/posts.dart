import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'favories.dart';

class Post {
  final int id;
  final int categoryId;
  final int governateId;
  final int userId;
  final String governorateName;
  final String userName;
  final String title;
  final String content;
  final String status;
  final DateTime createdAt;
  final category;
  final pictures;

  Post(
      {this.id,
      this.categoryId,
      this.category,
      this.governateId,
      this.userId,
      this.governorateName,
      this.userName,
      this.title,
      this.content,
      this.status,
      this.createdAt,
      this.pictures});
}

class Posts with ChangeNotifier {
  final String authToken;

  Posts(this.authToken);
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  // get posts by category id in home top tab
  List<Post> _currentList = [];
  var _currentPost;

  List<Post> get currentList {
    return _currentList;
  }

  get currentPost {
    return _currentPost;
  }

  Future<void> changeGov(id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('gov', id);
  }


  // home top tap widget
  Future<void> findPosts(id) async {
    var gov = 0;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('gov') != null) {
      gov = prefs.getInt('gov');
    }

    final myUrl = "http://thiqa-az.com/api/posts-category/$id/$gov";
    try {
      final response =
          await http.get(myUrl, headers: {"Accept": "application/json"});

      return response;
    } catch (error) {
      print(error);
    }
  }

  // post detail screen
  Future fetchPostDetails(int id) async {
  
    final myUrl = "http://thiqa-az.com/api/posts/$id";
    try {
      final response =
          await http.get(myUrl, headers: {"Accept": "application/json"});
      _currentPost = json.decode(response.body);

      return response;
    } catch (error) {
      print(error);
    }
  }

  void emptyCurrentPost() {
    _currentPost = null;
    notifyListeners();
  }

  Future<void> rate(postId, rating) async {
    if (rating == 1) {
      _currentPost['up_rating'] += 1;
      _currentPost['down_rating'] < 0
          ? _currentPost['down_rating'] -= 1
          : _currentPost['down_rating'] = 0;
    } else {
      _currentPost['up_rating'] < 0
          ? _currentPost['up_rating'] -= 1
          : _currentPost['up_rating'] = 0;
      _currentPost['down_rating'] += 1;
    }

    final response = await http.post('https://thiqa-az.com/api/make-rating',
        body: {
          "rate": "$rating",
          "post_id": "$postId"
        },
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $authToken'
        });
    print(response.body);
    notifyListeners();
  }

  // ignore: missing_return
  Future<String> addFavorite(Favorite favorite) async {
    final url = 'http://thiqa-az.com/api/favorites';
    var data = {
      "post_id": "${favorite.postId}",
      "category_id": "${favorite.categoryId}",
    };
    if (_currentPost['favorite_list'].contains(favorite.userId))
      _currentPost['favorite_list']
          .removeWhere((element) => element == favorite.userId);
    else
      _currentPost['favorite_list'].add(favorite.userId);
    // ignore: unused_local_variable
    var response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $authToken'
      },
      body: data,
    );
    notifyListeners();
  }

  // custom List Tile
  // ignore: missing_return
  Future<Post> getListTilePost(int id) async {
    final myUrl = "http://thiqa-az.com/api/posts/$id";
    try {
      final response =
          await http.get(myUrl, headers: {"Accept": "application/json"});
      final extractedData = json.decode(response.body);

      Post loadedPost;
      loadedPost = Post(
        id: extractedData['id'],
        categoryId: extractedData['category_id'],
        category: extractedData['categories'],
        governateId: extractedData['governorate_id'],
        governorateName:
            extractedData['governorates']['governorate_name'].toString(),
        userName: extractedData['users']['name'].toString(),
        title: extractedData['post_title'].toString(),
        content: extractedData['post_content'].toString(),
        status: extractedData['status'].toString(),
        pictures: extractedData['pictures'],
        createdAt: dateFormat.parse(extractedData['created_at']),
      );
      //notifyListeners();
      return loadedPost;
    } catch (error) {
      print(error);
    }
  }

  // add new post (post form screen in screens)
  Future<String> addPost(Post post) async {
    final url = 'http://thiqa-az.com/api/posts';
    var data = {
      "governorate_id": "${post.governateId}",
      "category_id": "${post.categoryId}",
      //"user_id": "${post.userId}",
      "post_title": "${post.title}",
      "post_content": "${post.content}",
      "status": "${post.status}",
    };
    print(data);
    //, 'Authorization' : 'Bearer $authToken'
    var response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $authToken'
      },
      body: data,
    );
    print('after post');
    print("response: ${response.body}");
    return "${response.body}";
  }

  // add new post (post form screen in screens)
  Future<String> editPost(Post post, int postId) async {
    final url = 'http://thiqa-az.com/api/posts/$postId';
    var data = {
      "governorate_id": "${post.governateId}",
      "category_id": "${post.categoryId}",
      "post_title": "${post.title}",
      "post_content": "${post.content}",
      "status": "${post.status}",
    };
    print(data);
    //, 'Authorization' : 'Bearer $authToken'
    var response = await http.put(
      url,
      headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $authToken'
      },
      body: data,
    );
    print('after post');
    print("response: ${response.body}");
    return "${response.body}";
  }

  Future search(String needed) async {
    // ignore: unnecessary_brace_in_string_interps
    final myUrl = 'http://thiqa-az.com/api/search-posts/${needed}';
    try {
      // , 'Authorization' : 'Bearer $authToken'
      final response =
          await http.get(myUrl, headers: {"Accept": "application/json"});
      print(response.body);
      return response;
    } catch (error) {
      print(error);
    }
  }

  Future fetchUserPosts() async {
    final myUrl = 'http://thiqa-az.com/api/user-posts';
    try {
      // , 'Authorization' : 'Bearer $authToken'
      final response = await http.get(myUrl, headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $authToken'
      });
      return response;
    } catch (error) {
      print(error);
    }
  }

  Future deletePost(int postId)async{
    final url = 'http://thiqa-az.com/api/posts/$postId';
    
    var response = await http.delete(url);

    print("response: ${response.body}");
    
    return "${response.body}";
    
  }

}
