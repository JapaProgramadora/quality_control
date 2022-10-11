import 'dart:convert';
import 'dart:math';

import '../utils/db.dart';
import '../utils/util.dart';
import '../validation/obra_validation.dart' as obra_validation;


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import '../validation/connectivity.dart';
import 'item.dart';

class ItemList with ChangeNotifier {
  bool hasInternet = false;
  int countItems = 0;
  int checkFirebase = 1;
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

  addToFirebase() async {
    final List<Items> loadedObra = await DB.getItemsFromDB('items');
      checkFirebase = 1;
      countItems = 1;
      for(var item in loadedObra){
        if(item.isDeleted == false && item.needFirebase == true){
          item.needFirebase = false;
          await DB.updateInfo('items', item.id, item.toMapSQL());
          await addItem(item);
        }
      }
    countItems = 0;
  }

  onLoad() async {
    hasInternet = await hasInternetConnection();

  }

  Future<void> loadItems() async {
    List<Items> toRemove = [];
    await onLoad();
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
              isDeleted: checkBool(productData['isDeleted']),
              matchmakingId: productData['matchmakingId'],
              isGood: checkBool(productData['isGood']),
              description: productData['description'],
              needFirebase: checkBool(productData['needFirebase']),
            ),
          );
      });

      for(var item in _items){
        if(item.isDeleted == true){
          toRemove.add(item);
        }
      }
      _items.removeWhere((element) => toRemove.contains(element));

      if(checkFirebase == 0){
        await addToFirebase();
      }
    }else{
    final List<Items> loadedItems = await DB.getItemsFromDB('items');
      for(var item in loadedItems){
        _items.add(item);
      }
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
      return await addItem(product);
    }
  }

  Future<void> addItem(Items product) async {
    final beginningDate = product.beginningDate;
    final endingDate = product.endingDate;
    Items novoItems;
    String id;
    bool needFirebase;
    if(hasInternet == true){
      needFirebase = false;
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
              "isDeleted": product.isDeleted,
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

      novoItems = Items(
          id: id,
          item: product.item,
          description: product.description,
          matchmakingId: product.matchmakingId,
          isGood: product.isGood,
          needFirebase: needFirebase,
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

    if(hasInternet == true){
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
      }
    }
    await DB.updateInfo('items', product.id, product.toMapSQL());
    await loadItems();
    notifyListeners();
  }

  Future<void> removeItem(Items product) async {
    await DB.deleteInfo("items", product.id);
    if(hasInternet == true){
      product.toggleDeletion();
    }

    await loadItems();
    notifyListeners();
  }

}