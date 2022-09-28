import 'dart:convert';
import 'dart:math';

import '../utils/db.dart';
import '../validation/obra_validation.dart' as obra_validation;


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import '../validation/connectivity.dart';
import 'item.dart';

class ItemList with ChangeNotifier {
  bool hasInternet = false;
  int countItems = 1;
  final List<Items> _items = [];
  List<Items> newItems = [];
  List<Items> needUpdate = [];

  List<Items> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }
  List<Items> loadMatchingItems(matchId){
    return _items.where((prod) => prod.matchmakingId == matchId).toList();
  }

  Items getSpecificItem(matchId){
    return _items.where((prod) => prod.id == matchId).toList().first;
  }

  onLoad() async {
    hasInternet = await hasInternetConnection();

    if(hasInternet == true){
      newItems = await obra_validation.missingFirebaseItems();
      //needUpdate = await obra_validation.stagesNeedingUpdate();
    }
  }

  Future<void> loadItems() async {
    _items.clear();
    if(hasInternet == true){
      final response = await http.get(
        Uri.parse('${Constants.ITEM_BASE_URL}.json'),
      );
      if (response.body == 'null') return;
      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((productId, productData) {
          _items.add(
            Items(
              id: productId,
              beginningDate: DateTime.parse(productData['beginningDate']),
              endingDate: DateTime.parse(productData['endingDate']),
              item: productData['item'],
              matchmakingId: productData['matchmakingId'],
              isGood: productData['isGood'],
              description: productData['description'],
            ),
          );
      });
    }

  }

  Future<void> saveItem(Map<String, Object> data) async {
    await onLoad();
    bool hasId = data['id'] != null;

    final product = Items(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      item: data['item'] as String,
      beginningDate: data['beginningDate'] == null ? DateTime.now() : data['beginningDate'] as DateTime,
      endingDate: data['endingDate'] == null ? DateTime.now() : data['endingDate'] as DateTime,
      description: data['description'] as String,
      matchmakingId: data['matchmakingId'] as String,
    );

    if (hasId) {
      return updateItem(product);
    } else {
      countItems = 1;
      if(newItems.isNotEmpty && hasInternet == true){
        for(var element in newItems){
          await addItem(element);
        }
      }
      countItems = 0;
      newItems.clear();
      return await addItem(product);
    }
  }

  Future<void> addItem(Items product) async {
    final beginningDate = product.beginningDate;
    final endingDate = product.endingDate;
    Items novoItems;
    String id;
    if(hasInternet == true){
        final response = await http.post(
          Uri.parse('${Constants.ITEM_BASE_URL}.json'),
          body: jsonEncode(
            {
              "item": product.item,
              "description": product.description,
              "beginningDate": beginningDate.toIso8601String(),
              "endingDate": endingDate.toIso8601String(), 
              "isGood": product.isGood,
              "matchmakingId": product.matchmakingId,
            },
          ),
        );
        id = jsonDecode(response.body)['name'];
      }else{
        id = Random().nextDouble().toString();
      }

      novoItems = Items(
          id: id,
          item: product.item,
          description: product.description,
          matchmakingId: product.matchmakingId,
          beginningDate: beginningDate,
          endingDate: endingDate,
      );

      if(countItems == 0){
        await DB.insert('items', novoItems.toMapSQL());
      } 

    await loadItems(); 
    notifyListeners();
  }

 
  Future<void> updateItem(Items product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('${Constants.ITEM_BASE_URL}/${product.id}.json'),
        body: jsonEncode(
          {
            "item": product.item,
            "beginningDate": product.beginningDate,
            "description": product.description,
            "endingDate": product.endingDate,
          },
        ),
      );

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeItem(Items product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('${Constants.ITEM_BASE_URL}/${product.id}.json'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
      }
    }
  }

}