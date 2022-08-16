// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:math';

import 'package:control/models/stage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class StageList with ChangeNotifier {  
  final List<Stage> _items = [];

  List<Stage> get items => [..._items];

  //List<Obra> get testItems => _items.where((prod) => prod.matchmakingId.contains(other)).toList();

  //final categoriesMeal = meals.where((meal){
       //return meal.categories.contains(category.id);
   // }).toList();
  List<Stage> testItems(matchId){
    return _items.where((prod) => prod.matchmakingId == matchId).toList();
  }

  List<Stage> getSpecificStage(matchId){
    return _items.where((p) => p.id == matchId).toList();
  }

  int get itemsCount {
    return _items.length;
  }


  Future<void> loadStage() async {
    _items.clear();

    final response = await http.get(
      Uri.parse('${Constants.STAGE_BASE_URL}.json'),
    );
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((stageId, stageData) {
        _items.add(
          Stage(
            id: stageId,
            stage: stageData['stage'],
            matchmakingId: stageData['matchmakingId'],
          ),
        );
    });
    print(_items);
    notifyListeners();
  }

  Future<void> saveStage(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Stage(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      stage: data['stage'] as String,
      matchmakingId: data['matchmakingId'] as String,
    );

    if (hasId) {
      return updateStage(product);
    } else {
      return addStage(product);
    }
  }

  Future<void> addStage(Stage product) async {
    final response = await http.post(
      Uri.parse('${Constants.STAGE_BASE_URL}.json'),
      body: jsonEncode(
        {
          "matchmakingId": product.matchmakingId,
          "stage": product.stage,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    _items.add(Stage(
      id: id,
      stage: product.stage,
      matchmakingId: product.matchmakingId,
    ));
    notifyListeners();
  }

 
  Future<void> updateStage(Stage product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('${Constants.STAGE_BASE_URL}/${product.id}.json'),
        body: jsonEncode(
          {
            "stage": product.stage,
            "matchmakingId": product.matchmakingId,
          },
        ),
      );

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeStage(Stage product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('${Constants.STAGE_BASE_URL}/${product.id}.json'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
      }
    }
  }

}