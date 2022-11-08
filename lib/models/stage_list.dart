// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:math';

import 'package:control/models/stage.dart';
import 'package:flutter/material.dart';
import '../utils/db.dart';
import '../utils/util.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import '../validation/connectivity.dart';

class StageList with ChangeNotifier {  
  final List<Stage> _items = [];
  bool hasInternet = false; 
  List<Stage> firebaseItems = [];
  int countStages = 0;
  int checkFirebase = 1;

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

  addToFirebase() async {
    final List<Stage> loadedStages= await DB.getStagesFromDb('stages');
      checkFirebase = 1;
      countStages = 1;
      for(var item in loadedStages){
        if(item.isDeleted == false && item.needFirebase == true){
          item.needFirebase = false;
          await DB.updateInfo('stages', item.id, item.toMapSQL());
          await addStage(item);
        }
      }
    countStages = 0;
  }

  onLoad() async {
    hasInternet = await hasInternetConnection();
    
  }


  Future<void> loadStage() async {
    List<Stage> toRemove = [];
    await onLoad();
    _items.clear();
    firebaseItems.clear();
    
    if(hasInternet == true){
      await addToFirebase();
      final response = await http.get(
        Uri.parse('${Constants.STAGE_BASE_URL}.json'),
      );
      if (response.body == 'null') return;
      Map<String, dynamic> data = jsonDecode(response.body);
      
      data.forEach((stageId, stageData) {
          _items.add(
            Stage(
              id: stageId,
              lastUpdated: DateTime.parse(stageData['lastUpdated']),
              stage: stageData['stage'],
              matchmakingId: stageData['matchmakingId'],
              isDeleted: checkBool(stageData['isDeleted']),
              isComplete: checkBool(stageData['isComplete']),
              needFirebase: checkBool(stageData['needFirebase']),
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
      lastUpdated: DateTime.now(),
      matchmakingId: data['matchmakingId'] as String,
    );

    if (hasId) {
      return updateStage(product);
    } else {
      return addStage(product);
    }
  }

  Future<void> checkSQLData() async {
    hasInternet = true;
    final List<Stage> loadedStages = await DB.getStagesFromDb('stages');

    //adding if there's nothing on firebase;
    if(firebaseItems.isEmpty && loadedStages.isNotEmpty){
      countStages = 1;
      for(var obra in loadedStages){
        await addStage(obra);
      }
      countStages = 0;
    }

    //adding if there's nothing on SQL;
    if(loadedStages.isEmpty && firebaseItems.isNotEmpty){
      for(var obra in firebaseItems){
        await DB.insert('stages', obra.toMapSQL());
      }
    }

    for(var item in firebaseItems){
      if(!loadedStages.contains(item)){
        await DB.insert('stages', item.toMapSQL());
      }
      if(item.isDeleted == true && loadedStages.contains(item)){
        await DB.deleteInfo('stages', item.id);
      }
    }
  }

  Future<void> checkUpdate() async {
    hasInternet = true;
    final List<Stage> loadedStages = await DB.getStagesFromDb('stages');
    if(firebaseItems.isEmpty){
      countStages = 1;
      for(var item in loadedStages){
        await addStage(item);
      }
      countStages = 0;
    }
    for(var stageFirebase in firebaseItems){
      for(var stageSQL in loadedStages){
        if(stageSQL.id == stageFirebase.id){
          if((stageSQL.lastUpdated).isBefore(stageFirebase.lastUpdated)){
            //updating SQL information
            stageSQL.lastUpdated = DateTime.now();
            await DB.updateInfo('stages', stageSQL.id, stageSQL.toMapSQL());

            //setting lastUpdated to now in Firebase
            await http.patch(Uri.parse('${Constants.PRODUCT_BASE_URL}/${stageFirebase.id}.json'),
              body: jsonEncode({ "lastUpdated": DateTime.now().toIso8601String()}));
          }else{
            await http.patch(Uri.parse('${Constants.PRODUCT_BASE_URL}/${stageFirebase.id}.json'),
              body: jsonEncode(
                { 
                  "matchmakingId": stageSQL.matchmakingId,
                  "stage": stageSQL.stage,
                  "lastUpdated": DateTime.now().toIso8601String(),
                  "needFirebase": false,
                }
              ),
            );
          }
        }
      }
    }
  }

  Future<String> addStage(Stage product) async {
    String id;
    bool needFirebase;
    if(hasInternet == true){
      needFirebase = false;
      final response = await http.post(
      Uri.parse('${Constants.STAGE_BASE_URL}.json'),
        body: jsonEncode(
          {
            "matchmakingId": product.matchmakingId,
            "stage": product.stage,
            "lastUpdated": DateTime.now().toIso8601String(),
            "needFirebase": needFirebase
          },
        ),
      );
      id = jsonDecode(response.body)['name'];
    }else{
      id = Random().nextDouble().toString();
      needFirebase = true;
      checkFirebase = 0;
    }

    Stage novoStage = Stage(
        id: id,
        lastUpdated: DateTime.now(),
        stage: product.stage,
        matchmakingId: product.matchmakingId,
        needFirebase: needFirebase,
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

    if(hasInternet == true){
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
      }
    }
    await DB.updateInfo('obras', product.id, product.toMapSQL());
    await loadStage();
    notifyListeners();
    return product.id;
    
  }

  Future<void> removeStage(Stage product) async {
    await DB.deleteInfo("stages", product.id);

    if(hasInternet == true){
      product.toggleDeletion();
    }

    await loadStage();
    notifyListeners();

  }


}