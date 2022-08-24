import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import '../utils/constants.dart';
import 'item.dart';

class ItemList with ChangeNotifier {
  final List<Items> _items = [];

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

  Future<void> loadItems() async {
    _items.clear();

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
            description: productData['description'],
          ),
      );
    });
    notifyListeners();
  }

  Future<void> saveItem(Map<String, Object> data) {
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
      return addItem(product);
    }
  }

  Future<void> addItem(Items product) async {
    final beginningDate = product.beginningDate;
    final endingDate = product.endingDate;
    final response = await http.post(
      Uri.parse('${Constants.ITEM_BASE_URL}.json'),
      body: jsonEncode(
        {
          "item": product.item,
          "description": product.description,
          "beginningDate": beginningDate.toIso8601String(),
          "endingDate": endingDate.toIso8601String(),
          "matchmakingId": product.matchmakingId,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    _items.add(Items(
      id: id,
      beginningDate: product.beginningDate,
      item: product.item,
      endingDate: product.endingDate,
      description: product.description,
      matchmakingId: product.matchmakingId,
    ));
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