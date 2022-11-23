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

  bool getSpecificStageBool(String id){
    if(_items.isEmpty){
      return true;
    }
    return _items.where((p) => p.id == id).toList().isEmpty ? false : true;
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

  Future<void> checkData() async {
    hasInternet = true;
    List<Stage> toRemove = [];
    List<Stage> localUpdates = [];
    List<Stage> fireUpdates = [];
    final List<Stage> loadedObras = await DB.getObrasFromDB('obras');

    //if there's nothing on each;
    if(firebaseItems.isEmpty && loadedObras.isEmpty){
      return;
    }

    //adding if there's nothing on firebase;
    if(firebaseItems.isEmpty && loadedObras.isNotEmpty){
      countStages = 1;
      for(var obra in loadedObras){
        await addStage(obra);
      }
      countStages = 0;
    }

    //adding if there's nothing on SQL;
    if(loadedObras.isEmpty && firebaseItems.isNotEmpty){
      for(var obra in firebaseItems){
        if(obra.isDeleted == false){
          await DB.insert('obras', obra.toMapSQL());
        }
      }
    }else if(firebaseItems.isEmpty && loadedObras.isNotEmpty){
      countStages = 1;
      for(var obra in loadedObras){
        await addStage(obra);
      }
      countStages = 0;
    }

    //if there's any obra needing firebase;
    for(var obra in loadedObras){
      countStages = 1;
      if(obra.needFirebase == true && obra.isDeleted == false){
        await addStage(obra);
      }
      if(obra.isDeleted == true){
        await http.patch(Uri.parse('${Constants.PRODUCT_BASE_URL}/${obra.id}.json'),body: jsonEncode({"isDeleted": obra.isDeleted}),);
        await DB.deleteInfo('obras', obra.id);
      }
      if(obra.isUpdated == true && obra.isDeleted == false){
        localUpdates.add(obra);
      }
      countStages = 0;
    }
    
    //if there's any obra needing sql
    for(var item in firebaseItems){
      bool value = getSpecificStageBool(item.id);
      if(value == false && item.isDeleted == false){
        await DB.insert('obras', item.toMapSQL());
      }
      //this should delete something from different devices
      if(item.isDeleted == true && value == true){
        await DB.deleteInfo('obras', item.id);
      }
      if(item.isUpdated == true && item.isDeleted == false){
        fireUpdates.add(item);
      }
    }

    //checking for updates on both firebase and sql and updating stuff
    for(var fire in fireUpdates){
      for(var obra in loadedObras){
        if(fire.id == obra.id){
          if((fire.lastUpdated).isAfter(obra.lastUpdated)){
            await DB.updateInfo('obras', obra.id, fire.toMapSQL());
             await http.patch(Uri.parse('${Constants.PRODUCT_BASE_URL}/${fire.id}.json'),
              body: jsonEncode({ 
                "lastUpdated": DateTime.now().toIso8601String(),
                "isUpdated": false,
                }
            ));
          }
        }
      }
      for(var obra in localUpdates){
        if(obra.id == fire.id){
          if((obra.lastUpdated).isAfter(fire.lastUpdated)){
            await http.patch(Uri.parse('${Constants.PRODUCT_BASE_URL}/${fire.id}.json'),
              body: jsonEncode(
                { 
                  "stage": obra.stage,
                  "lastUpdated": DateTime.now().toIso8601String(),
                  "isComplete": obra.isComplete,
                  "needFirebase": false,
                }
              ),
            );
          }
        }
        obra.isUpdated = false;
        await DB.updateInfo('obras', obra.id, obra.toMapSQL());
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
            "needFirebase": needFirebase,
            "isUpdated": false,
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