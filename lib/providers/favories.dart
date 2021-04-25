import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;


class Favorite {
   int postId;
  final int userId;
   int categoryId;
  Favorite({this.postId, this.userId, this.categoryId});
}

class Favorites with ChangeNotifier {
  List<Favorite> _favorite = [];

  final String authToken ;
  Favorites(this.authToken);

  List<Favorite> get allFav {
    return _favorite;
  }

  Future fetchFavorite() async {
    
    final myUrl = 'https://thiqa-az.com/api/favorites';
    try {
      // , 'Authorization' : 'Bearer $authToken'
      final response =
          await http.get(myUrl, headers: {"Accept": "application/json" , 'Authorization' : 'Bearer $authToken'});
     
      return response;
    } catch (error) {
      print(error);
    }
  }

   Future<String> addFavorite(Favorite favorite) async {
    final url = 'http://thiqa-az.com/api/favorites';
    var data = {
      "post_id" : "${favorite.postId}",
      "category_id": "${favorite.categoryId}",
    };
    print(data);

    var response = await http.post(
      url,
      headers: {"Accept": "application/json" , 'Authorization' : 'Bearer $authToken' },
      body: data,
    );
    print('after post');
    print("response: ${response.body}");
    return "${response.body}";
  }
  
}
