import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:control/models/item.dart';
import 'package:control/models/method.dart';
import 'package:control/models/stage.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import '../data/base_data.dart';
import '../utils/constants.dart';
import '../utils/db.dart';
import '../validation/connectivity.dart';
import 'team_list.dart';

class BaseList with ChangeNotifier { 
  bool hasInternet = false; 
  int countStages = 0;
  int checkFirebase = 1;
  int hasCreatedBaseTeam = 0;

  onLoad() async {
    hasInternet = await hasInternetConnection();
    
  }

  
  Future<void> addBaseStage(Map<String, String> stage, String matchmakingId) async {
    String id;
    List<Stage> toRemove = [];
    bool needFirebase;
    await onLoad();
    if(hasInternet == true){
      needFirebase = false;
      final response = await http.post(
      Uri.parse('${Constants.STAGE_BASE_URL}.json'),
        body: jsonEncode(
          {
            "matchmakingId": matchmakingId,
            "stage": stage['stage'],
            "needFirebase": needFirebase,
            "lastUpdated": DateTime.now().toIso8601String(),
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
        stage: stage['stage']!,
        lastUpdated: DateTime.now(),
        isDeleted: false,
        matchmakingId: matchmakingId,
        needFirebase: needFirebase,
    );
    
    await DB.insert('stages', novoStage.toMapSQL());
  
    for(var item in baseItems){
      if(item['classStage'] == stage['class']){
        addBaseItem(item, id);
      }
    }

    notifyListeners();
  }

  Future<void> addBaseItem(Map<String, String> item, String matchmakingId) async {
    String id;
    bool needFirebase;
    if(hasInternet == true){
      needFirebase = false;
      final response = await http.post(
      Uri.parse('${Constants.ITEM_BASE_URL}.json'),
        body: jsonEncode(
          {
            "matchmakingId": matchmakingId,
            "item": item['item'],
            "lastUpdated": DateTime.now().toIso8601String(),
            "beginningDate": DateTime.now().toIso8601String(),
            "endingDate": DateTime.now().add(Duration(days: 7)).toIso8601String(),
            "description": '',
            "needFirebase": needFirebase,
          },
        ),
      );
      id = jsonDecode(response.body)['name'];
    }else{
      id = Random().nextDouble().toString();
      needFirebase = true;
      checkFirebase = 0;
    }

    Items newItem = Items(
        id: id,
        item: item['item']!,
        beginningDate: DateTime.now(),
        endingDate: DateTime.now().add(Duration(days: 7)),
        description: '',
        lastUpdated: DateTime.now(),
        matchmakingId: matchmakingId,
        needFirebase: needFirebase,
    );

    await DB.insert('items', newItem.toMapSQL());
    
    int start = int.parse(item['start']!);
    int end = int.parse(item['end']!);
    for(int i = start; i <= end; i++){
      addBaseMethod(baseMethods[i], newItem.id);
    }
    notifyListeners();
  }

  Future<void> addBaseMethod(Map<String, dynamic> method, String matchmakingId) async {
    String id;
    bool needFirebase;
    if(hasInternet == true){
      needFirebase = false;
      final response = await http.post(
      Uri.parse('${Constants.METHOD_BASE_URL}.json'),
        body: jsonEncode(
          {
            "matchmakingId": matchmakingId,
            "method": method['method'].cast<String>() as List<String>,
            "team": method['team'],
            "item": method['item'],
            "lastUpdated": DateTime.now().toIso8601String(),
            "isComplete": false,
            "isMethodGood": false,
            "isDeleted": false,
            "tolerance": method['tolerance'].cast<String>() as List<String>,
            "needFirebase": needFirebase,
          },
        ),
      );
      id = jsonDecode(response.body)['name'];
    }else{
      id = Random().nextDouble().toString();
      needFirebase = true;
      checkFirebase = 0;
    }

    Method newMethod = Method(
      id: id, 
      item: method['item']!,
      method: method['method'] as List<String>,
      lastUpdated: DateTime.now(),
      team: method['item']!,
      isMethodGood: false,
      tolerance: method['tolerance'] as List<String>,
      isDeleted: false,
      matchmakingId: matchmakingId,
      needFirebase: needFirebase,
    );

    await DB.insert('method', newMethod.toMapSQL());


    notifyListeners();
  }

  // List<Map<String, String>> baseItems = [
  //   //tipo 1
  //   {'class': '1','item': 'Fechamento em Tapume'},
  //   {'class': '1','item': 'Instalações Provisórias'},
  //   {'class': '1','item': 'Ligação de Energia'},
  //   {'class': '1','item': 'Locação de Obra'}
  // ];

  // List<Map<String, dynamic>> baseMethods = [
  //   {
  //     'class': '1',
  //     'item': 'item1',
  //     'tolerance': ['tolerance1'],
  //     'method': ['method1'],
  //     'team': 'team1',
  //   },
  //   {
  //     'class': '2',
  //     'item': 'item2',
  //     'tolerance': ['tolerance2'],
  //     'method': ['method2'],
  //     'team': 'team2',
  //   },
  //   {
  //     'class': '3',
  //     'item': 'item3',
  //     'tolerance': ['tolerance3'],
  //     'method': ['method3'],
  //     'team': 'team3',
  //   }
  // ];

  

} 