import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Category {
  final int id;
  final String pictureId;
  final String countryId;
  final String parentCatId;
  final String categoryName;
  final String description;
  final String displayOrder;
  final String status;
  Category(
      {this.id,
      this.pictureId,
      this.countryId,
      this.parentCatId,
      this.categoryName,
      this.description,
      this.displayOrder,
      this.status});
}

class Categories with ChangeNotifier {
  List<Category> _categories = [];
  List<Category> _currentList = [];

  List<Category> get subs {
    return _currentList;
  }

  List<Category> get items {
    print('cat items');
    List<Category> currentList = [];
    for (var i = 0; i < _categories.length; i++) {
      if (int.parse(_categories[i].parentCatId) == 0) {
        currentList.add(_categories[i]);
      }
    }
    return currentList;
  }

  Future<void> findChild(id) async {
    _currentList = [];
    for (var i = 0; i < _categories.length; i++) {
      if (int.parse(_categories[i].parentCatId) == id)
        _currentList.add(_categories[i]);
    }
  }

  List<Category> childs(id) {
    List<Category> list = [];
    for (var i = 0; i < _categories.length; i++) {
      if (int.parse(_categories[i].parentCatId) == id) list.add(_categories[i]);
    }
    return list;
  }

  // in add form
  List<Category> get added {
    List<Category> currentList = [];
    for (var i = 0; i < _categories.length; i++) {
      if (int.parse(_categories[i].parentCatId) == 0) {
        currentList.add(_categories[i]);
      }

      if (_categories[i].id == 1) {
        currentList.remove(_categories[i]);
      }
    }
    return currentList;
  }

  Future<void> fetchCategories() async {
    const myUrl = "http://thiqa-az.com/api/categories";
    try {
      final response =
          await http.get(myUrl, headers: {"Accept": "application/json"});
      //print(response.statusCode);
      final extractedData = json.decode(response.body);
      //print(extractedData);

      final List<Category> loadedCategories = [];

      for (int i = 0; i < extractedData.length; i++) {
        loadedCategories.add(
          Category(
              id: extractedData[i]['id'],
              pictureId: extractedData[i]['picture_id'].toString(),
              countryId: extractedData[i]['country_id'].toString(),
              parentCatId: extractedData[i]['parent_cat_id'].toString(),
              categoryName: extractedData[i]['category_name'].toString(),
              description: extractedData[i]['description'].toString(),
              displayOrder: extractedData[i]['display_order'].toString(),
              status: extractedData[i]['status'].toString()),
        );
      }
      _categories = loadedCategories;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
