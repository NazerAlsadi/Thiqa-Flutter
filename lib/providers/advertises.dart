import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Advertise {
  final int id;
  final int categoryId;
  final String pictureUrl;
  final String title;
  final String link;
  final String status;
  final String startAt;
  final String endAt;

  Advertise(
      {this.id,
      this.categoryId,
      this.pictureUrl,
      this.title,
      this.link,
      this.status,
      this.startAt,
      this.endAt});
}

class Advertises with ChangeNotifier {
  List<Advertise> _advertises = [];

  List<Advertise> get advertises {
    return _advertises;
  }

  Future<void> fetchAdvertises() async {
    const myUrl = "http://thiqa-az.com/api/advertises";
    try {
      final response =
          await http.get(myUrl, headers: {"Accept": "application/json"});

      final extractedData = json.decode(response.body);

      final List<Advertise> loadedAdvertises = [];

      for (int i = 0; i < extractedData.length; i++) {
        loadedAdvertises.add(Advertise(
          id: extractedData[i]['id'],
          categoryId: extractedData[i]['category_id'],
          pictureUrl: extractedData[i]['picture_id'].toString(),
          title: extractedData[i]['title'],
          link: extractedData[i]['link'],
          status: extractedData[i]['status'],
          startAt: extractedData[i]['start_at'].toString(),
          endAt: extractedData[i]['end_at'].toString(),
        ));
      }
      _advertises = loadedAdvertises;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
