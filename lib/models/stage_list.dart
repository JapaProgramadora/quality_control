// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:math';

import 'package:control/models/stage.dart';
import 'package:flutter/material.dart';
import '../utils/db.dart';
import '../utils/util.dart';
import '../validation/obra_validation.dart' as obra_validation;
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import '../validation/connectivity.dart';

class StageList with ChangeNotifier {  
  final List<Stage> _items = [];
  bool hasInternet = false; 
  List<Stage> newStages = [];
  List<Stage> needUpdate = [];
  int countStages = 1;

  List<Stage> get items => [..._items];

  List<Stage> allMatchingStages(matchId){
    return _items.where((prod) => prod.matchmakingId == matchId).toList();
  }

  List<Stage> getSpecificStage(matchId){
    return _items.where((p) => p.id == matchId).toList();
  }

  int get itemsCount {
    return _items.length;
  }

  onLoad() async {
    hasInternet = await hasInternetConnection();
    
    if(hasInternet == true){
       newStages = await obra_validation.missingFirebaseStages();
       needUpdate = await obra_validation.stagesNeedingUpdate();
    }
  }


  Future<void> loadStage() async {
    List<Stage> toRemove = [];
    await onLoad();
    _items.clear();
    
    if(hasInternet == true){
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
              isDeleted: checkBool(stageData['isDeleted']),
            ),
        );
      });

      for(var item in _items){
        if(item.isDeleted == true){
          toRemove.add(item);
        }
      }

      _items.removeWhere((element) => toRemove.contains(element));

    }else{
      final List<Stage> loadedStage = await DB.getStagesFromDb('stages');
      for(var item in loadedStage){
        _items.add(item);
      }
    }
    notifyListeners();
  }

  Future<String> saveStage(Map<String, Object> data) async {
    await onLoad();
    bool hasId = data['id'] != null;

    final product = Stage(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      stage: data['stage'] as String,
      matchmakingId: data['matchmakingId'] as String,
    );

    if (hasId) {
      return updateStage(product);
    } else {
      countStages = 1;
      if(newStages.isNotEmpty && hasInternet == true){
        for(var element in newStages){
          await addStage(element);
        }
      }
      countStages = 0;
      newStages.clear();
      return addStage(product);
    }
  }

  Future<String> addStage(Stage product) async {
    String id;
    if(hasInternet == true){
      final response = await http.post(
      Uri.parse('${Constants.STAGE_BASE_URL}.json'),
        body: jsonEncode(
          {
            "matchmakingId": product.matchmakingId,
            "stage": product.stage,
            "isDeleted": product.isDeleted,
            "isUpdated": product.isUpdated,
          },
        ),
      );

      id = jsonDecode(response.body)['name'];
    }else{
      id = Random().nextDouble().toString();
    }

    Stage novoStage = Stage(
        id: id,
        stage: product.stage,
        matchmakingId: product.matchmakingId,
    );

    if(countStages == 0){
      await DB.insert('stages', novoStage.toMapSQL());
    } 

    await loadStage();
    notifyListeners();
    return id;
  }

 
  Future<String> updateStage(Stage product) async {
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
    return product.id;
    
  }

  Future<void> removeStage(Stage product) async {
    if(hasInternet == true){
      product.toggleDeletion();
    }

    await DB.deleteInfo("stages", product.id);
    loadStage();
    notifyListeners();

  }

}