// ignore_for_file: avoid_print, file_names
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/db.dart';
import '../validation/obra_validation.dart' as obra_validation;

import '../utils/constants.dart';
import '../validation/connectivity.dart';
import 'evaluation.dart';

class EvaluationList with ChangeNotifier {  
  final List<Evaluation> _items = [];
  List<Evaluation> newEvaluations = [];
  int countStages = 1;
  List<Evaluation> get items => [..._items];

  bool hasInternet = false;

  //List<Obra> get testItems => _items.where((prod) => prod.matchmakingId.contains(other)).toList();

  //final categoriesMeal = meals.where((meal){
       //return meal.categories.contains(category.id);
   // }).toList();
  List<Evaluation> testItems(matchId){
    return _items.where((prod) => prod.matchmakingId == matchId).toList();
  }

  List<Evaluation> getSpecificEvaluation(matchId){
    return _items.where((p) => p.id == matchId).toList();
  }

  int get itemsCount {
    return _items.length;
  }

  onLoad() async {
    hasInternet = await hasInternetConnection();
    
    if(hasInternet == true){
      newEvaluations = await obra_validation.missingFirebaseEvaluations();
      // needUpdate = await obra_validation.stagesNeedingUpdate();
    }
  }


  Future<void> loadEvaluation() async {
    _items.clear();

    if(hasInternet == true){
      final response = await http.get(
        Uri.parse('${Constants.ERROR_METHOD_URL}.json'),
      );
      if (response.body == 'null') return;
      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((stageId, stageData) {
          _items.add(
            Evaluation(
              id: stageId,
              locationId: stageData['locationId'],
              error: stageData['error'],
              matchmakingId: stageData['matchmakingId'],
            ),
          );
      });
    }else{
      final List<Evaluation> loadedEvaluations = await DB.getEvaluationsFromDB();
      for(var method in loadedEvaluations){
        _items.add(method);
      }
    }
    notifyListeners();
  }

  Future<String> saveEvaluation(Map<String, Object> data) async {
    await onLoad();
    bool hasId = data['id'] != null;

    final product = Evaluation(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      error: data['error'] as String,
      locationId: data['locationId'] as String,
      matchmakingId: data['matchmakingId'] as String,
    );
    
    countStages = 1;
      if(newEvaluations.isNotEmpty && hasInternet == true){
        for(var element in newEvaluations){
          await addEvaluation(element);
        }
      }
    countStages = 0;
    newEvaluations.clear();
    return addEvaluation(product);
  
  }

  Future<String> addEvaluation(Evaluation product) async {
    String id;

    if(hasInternet == true){
      final response = await http.post(
      Uri.parse('${Constants.ERROR_METHOD_URL}.json'),
      body: jsonEncode(
          {
            "matchmakingId": product.matchmakingId,
            "isEPI": product.isEPI,
            "isOrganized": product.isOrganized,
            "isProductive": product.isProductive,
            "error": product.error,
            "isDeleted": product.isDeleted,
            "locationId": product.locationId,
          },
        ),
     );

      id = jsonDecode(response.body)['name'];
    }else{
      id = Random().nextDouble().toString();
    }

    Evaluation evaluation = Evaluation(
      id: id,
      error: product.error,
      locationId: product.locationId,
      isEPI: product.isEPI,
      isOrganized: product.isOrganized,
      isProductive: product.isProductive,
      matchmakingId: product.matchmakingId,
    );

    if(countStages == 0){
      await DB.insert('evaluation', evaluation.toMapSQL());
    } 
    
    await loadEvaluation();
    notifyListeners();
    return id;
  }

  Future<void> removeEvaluation(Evaluation product) async {
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