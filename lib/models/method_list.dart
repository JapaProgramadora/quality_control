import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/db.dart';
import '../utils/util.dart';
import '../validation/connectivity.dart';
import '../validation/obra_validation.dart' as obra_validation;

import '../utils/constants.dart';
import 'method.dart';

class MethodList with ChangeNotifier {  
  final List<Method> _items = [];
  bool hasInternet = false;
  List<Method> newMethods = [];
  int countItems = 0;
  int checkFirebase = 1;
  
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

  addToFirebase() async {
    final List<Method> loadedMethods = await DB.getMethodsFromDB();
      checkFirebase = 1;
      countItems = 1;
      for(var item in loadedMethods){
        if(item.isDeleted == false && item.needFirebase == true){
          item.needFirebase = false;
          await DB.updateInfo('method', item.id, item.toMapSQL());
          await addMethod(item);
        }
      }
    countItems = 0;
  }

  onLoad() async {
    hasInternet = await hasInternetConnection();
  }


  Future<void> loadMethod() async {
    List<Method> toRemove = [];
    await onLoad();
    _items.clear();

    if(hasInternet == true){
      final response = await http.get(
        Uri.parse('${Constants.METHOD_BASE_URL}.json'),
      );
      await addToFirebase();
      if (response.body == 'null') return;
      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((methodId, methodData) {
          _items.add(
            Method(
              id: methodId,
              item: methodData['item'],
              method: methodData['method'].cast<String>() as List<String>,
              team: methodData['team'],
              isMethodGood: methodData['isMethodGood'],
              isDeleted: methodData['isDeleted'],
              isComplete: checkBool(methodData['isComplete']),
              tolerance: methodData['tolerance'].cast<String>() as List<String>,
              matchmakingId: methodData['matchmakingId'],
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
      final List<Method> loadedMethods = await DB.getMethodsFromDB();
      for(var method in loadedMethods){
          _items.add(method);
      }
    }
    notifyListeners();
  }

  Future<void> saveMethod(Map<String, Object> data) async {
    await onLoad();
    bool hasId = data['id'] != null;

    final product = Method(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      method: data['method'] as List<String>,
      team: data['team'] as String,
      item: data['item'] as String,
      tolerance: data['tolerance'] as List<String>,
      matchmakingId: data['matchmakingId'] as String,
    );

    if (hasId) {
      return updateMethod(product);
    } else {
      return await addMethod(product);
    }
  }

  Future<void> addMethod(Method product) async {
    String id; 
    bool needFirebase;
    if(hasInternet == true){
      needFirebase = false;
      final response = await http.post(
      Uri.parse('${Constants.METHOD_BASE_URL}.json'),
      body: jsonEncode(
          {
            "matchmakingId": product.matchmakingId,
            "method": product.method,
            "team": product.team,
            "item": product.item,
            "isComplete": product.isComplete,
            "isMethodGood": product.isMethodGood,
            "isDeleted": product.isDeleted,
            "tolerance": product.tolerance,
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
      item: product.item,
      method: product.method,
      team: product.team,
      isMethodGood: product.isMethodGood,
      tolerance: product.tolerance,
      isDeleted: product.isDeleted,
      matchmakingId: product.matchmakingId,
      needFirebase: needFirebase,
    );

    if(countItems == 0){
      await DB.insert('method', newMethod.toMapSQL());
    } 

    await loadMethod();
    notifyListeners();
  }

 
  Future<void> updateMethod(Method product) async {
    int index = _items.indexWhere((p) => p.id == product.id);


    if(hasInternet == true){
      if (index >= 0) {
      await http.patch(
        Uri.parse('${Constants.METHOD_BASE_URL}/${product.id}.json'),
          body: jsonEncode(
            {
              "method": product.method,
              "team": product.team,
              "tolerance": product.tolerance,
              "isMethodGood": product.isMethodGood,
              "matchmakingId": product.matchmakingId,
            },
          ),
        );

        _items[index] = product;

      }
    }

    await DB.updateInfo('method', product.id, product.toMapSQL());
    await loadMethod();
    notifyListeners();
  
  }

  Future<void> removeMethod(Method product) async {
    if(hasInternet == true){
      product.toggleDeletion();
    }

    await DB.deleteInfo("method", product.id);
    await loadMethod();
    notifyListeners();
  }
}