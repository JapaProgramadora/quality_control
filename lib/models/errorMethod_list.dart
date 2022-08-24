// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:math';

import 'package:control/models/errorMethod.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class ErrorMethodList with ChangeNotifier {  
  final List<ErrorMethod> _items = [];

  List<ErrorMethod> get items => [..._items];

  //List<Obra> get testItems => _items.where((prod) => prod.matchmakingId.contains(other)).toList();

  //final categoriesMeal = meals.where((meal){
       //return meal.categories.contains(category.id);
   // }).toList();
  List<ErrorMethod> testItems(matchId){
    return _items.where((prod) => prod.matchmakingId == matchId).toList();
  }

  List<ErrorMethod> getSpecificErrorMethod(matchId){
    return _items.where((p) => p.id == matchId).toList();
  }

  int get itemsCount {
    return _items.length;
  }


  Future<void> loadErrorMethod() async {
    _items.clear();

    final response = await http.get(
      Uri.parse('${Constants.ERROR_METHOD_URL}.json'),
    );
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((stageId, stageData) {
        _items.add(
          ErrorMethod(
            id: stageId,
            error: stageData['error'],
            matchmakingId: stageData['matchmakingId'],
          ),
        );
    });
    print(_items);
    notifyListeners();
  }

  Future<String> saveErrorMethod(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = ErrorMethod(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      error: data['error'] as String,
      matchmakingId: data['matchmakingId'] as String,
    );
    
    return addErrorMethod(product);
  
  }

  Future<String> addErrorMethod(ErrorMethod product) async {
    final response = await http.post(
      Uri.parse('${Constants.ERROR_METHOD_URL}.json'),
      body: jsonEncode(
        {
          "matchmakingId": product.matchmakingId,
          "isEPI": product.isEPI,
          "isOrganized": product.isOrganized,
          "isProductive": product.isProductive,
          "error": product.error,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    _items.add(ErrorMethod(
      id: id,
      error: product.error,
      isEPI: product.isEPI,
      isProductive: product.isProductive,
      isOrganized: product.isOrganized,
      matchmakingId: product.matchmakingId,
    ));
    notifyListeners();

    return id;
  }

  Future<void> removeErrorMethod(ErrorMethod product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('${Constants.ERROR_METHOD_URL}/${product.id}.json'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
      }
    }
  }

}