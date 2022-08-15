import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import '../utils/constants.dart';
import 'stage_item.dart';

class StagesList with ChangeNotifier {
  final List<Items> _items = [];

  List<Items> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadItems(String matchmakingId) async {
    _items.clear();

    final response = await http.get(
      Uri.parse('${Constants.ITEM_BASE_URL}.json'),
    );
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      if (matchmakingId == productData['matchmakingId']){
        _items.add(
        Items(
          id: productId,
          item: productData['item'],
          method: productData['method'],
          tolerance: productData['tolerance'],
          isGood: productData['isGood'],
          matchmakingId: productData['matchmakingId'],
        ),
      );
      }
    });
    notifyListeners();
  }

  Future<void> saveItem(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Items(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      item: data['item'] as String,
      tolerance: data['tolerance'] as double,
      method: data['method'] as String,
      matchmakingId: data['matchmakingId'] as String,
    );

    if (hasId) {
      return updateItem(product);
    } else {
      return addItem(product);
    }
  }

  Future<void> addItem(Items product) async {
    final response = await http.post(
      Uri.parse('${Constants.ITEM_BASE_URL}.json'),
      body: jsonEncode(
        {
          "item": product.item,
          "tolerance": product.tolerance,
          "method": product.method,
          "isGood": product.isGood,
          "matchmakingId": product.matchmakingId,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    _items.add(Items(
      id: id,
      item: product.item,
      tolerance: product.tolerance,
      method: product.method,
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
            "method": product.method,
            "tolerance": product.tolerance,
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