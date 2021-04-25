import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Governator {
  final int id;
  final String name;

  Governator({this.id, this.name});
}

class Governators with ChangeNotifier {
  List<Governator> _govers = [];

  List<Governator> get all {
    return _govers;
  }

  Future<void> fetchGovernators() async {
    const myUrl = "http://thiqa-az.com/api/governorates";
    try {
      final response =
          await http.get(myUrl, headers: {"Accept": "application/json"});
      //print(response.statusCode);
      final extractedData = json.decode(response.body);
      //print(extractedData);

      final List<Governator> loadedGovernators = [];

      for (int i = 0; i < extractedData.length; i++) {
        loadedGovernators.add(
          Governator(
            id: extractedData[i]['id'],
            name: extractedData[i]['governorate_name'].toString(),
          ),
        );
      }
      _govers = loadedGovernators;
      
      return response;
    } catch (error) {
      print(error);
    }
  }
}
