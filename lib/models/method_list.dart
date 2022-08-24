import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import 'method.dart';

class MethodList with ChangeNotifier {  
  final List<Method> _items = [];
  
  List<Method> get items => [..._items];

  //List<Obra> get testItems => _items.where((prod) => prod.matchmakingId.contains(other)).toList();

  //final categoriesMeal = meals.where((meal){
       //return meal.categories.contains(category.id);
   // }).toList();
  List<Method> getAllItems(matchId){
    return _items.where((prod) => prod.matchmakingId == matchId).toList();
  }

  List<Method> getSpecificMethod(matchId){
    return _items.where((p) => p.id == matchId).toList();
  }

  int get itemsCount {
    return _items.length;
  }


  Future<void> loadMethod() async {
    _items.clear();

    final response = await http.get(
      Uri.parse('${Constants.METHOD_BASE_URL}.json'),
    );
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((methodId, methodData) {
        _items.add(
          Method(
            id: methodId,
            method: methodData['method'],
            team: methodData['team'],
            errorDescription: methodData['errorDescription'],
            tolerance: methodData['tolerance'],
            isMethodGood: methodData['isMethodGood'],
            isTeamGood: methodData['isTeamGood'],
            matchmakingId: methodData['matchmakingId'],
          ),
        );
    });
    notifyListeners();
  }

  Future<void> saveMethod(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Method(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      method: data['method'] as String,
      team: data['team'] as String,
      tolerance: data['tolerance'] as String,
      errorDescription: data['errorDescription'] as String,
      matchmakingId: data['matchmakingId'] as String,
    );

    if (hasId) {
      return updateMethod(product);
    } else {
      return addMethod(product);
    }
  }

  Future<void> addMethod(Method product) async {
    final response = await http.post(
      Uri.parse('${Constants.METHOD_BASE_URL}.json'),
      body: jsonEncode(
        {
          "matchmakingId": product.matchmakingId,
          "method": product.method,
          "team": product.team,
          "isMethodGood": product.isMethodGood,
          "isTeamGood": product.isTeamGood,
          "errorDescription": product.errorDescription,
          "tolerance": product.tolerance,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    _items.add(Method(
      id: id,
      method: product.method,
      team: product.team,
      errorDescription: product.errorDescription,
      tolerance: product.tolerance,
      matchmakingId: product.matchmakingId,
    ));
    notifyListeners();
  }

 
  Future<void> updateMethod(Method product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('${Constants.METHOD_BASE_URL}/${product.id}.json'),
        body: jsonEncode(
          {
            "method": product.method,
            "team": product.team,
            "tolerance": product.tolerance,
            "errorDescription": product.errorDescription,
            "matchmakingId": product.matchmakingId,
          },
        ),
      );

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeMethod(Method product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('${Constants.METHOD_BASE_URL}/${product.id}.json'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
      }
    }
  }

}