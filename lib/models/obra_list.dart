import 'dart:convert';
import 'dart:math';

import 'package:control/models/obra.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class ObraList with ChangeNotifier {
  List<Obra> _items = [];

  List<Obra> get items => [..._items];

  List<Obra> get andamentoItems => _items.where((prod) => prod.isIncomplete).toList();


  int get itemsCount {
    return _items.length;
  }

  Future<void> loadProducts() async {
    _items.clear();

    final response = await http.get(
      Uri.parse('${Constants.PRODUCT_BASE_URL}.json'),
    );
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      _items.add(
        Obra(
          id: productId,
          name: productData['name'],
          engineer: productData['engineer'],
          team: productData['team'],
          address: productData['address'],
          owner: productData['owner'],
        ),
      );
    });
    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Obra(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      engineer: data['engineer'] as String,
      team: data['team'] as String,
      address: data['address'] as String,
      owner: data['owner'] as String,
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> addProduct(Obra product) async {
    final response = await http.post(
      Uri.parse('${Constants.PRODUCT_BASE_URL}.json'),
      body: jsonEncode(
        {
          "name": product.name,
          "engineer": product.engineer,
          "team": product.team,
          "owner": product.owner,
          "address": product.address,
          "isIncomplete": product.isIncomplete,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    _items.add(Obra(
      id: id,
      name: product.name,
      engineer: product.engineer,
      team: product.team,
      owner: product.owner,
      address: product.address,
    ));
    notifyListeners();
  }

 
  Future<void> updateProduct(Obra product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('${Constants.PRODUCT_BASE_URL}/${product.id}.json'),
        body: jsonEncode(
          {
            "name": product.name,
            "engineer": product.engineer,
            "address": product.address,
            "owner": product.owner,
            "team": product.team,
          },
        ),
      );

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(Obra product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('${Constants.PRODUCT_BASE_URL}/${product.id}.json'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
      }
    }
  }
}