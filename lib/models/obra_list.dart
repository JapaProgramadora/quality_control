import 'dart:convert';
import 'dart:math';

import 'obra.dart';
import '../utils/db.dart';
import 'package:control/utils/util.dart';
import '../validation/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../validation/obra_validation.dart' as obra_validation;

import '../utils/constants.dart';

class ObraList with ChangeNotifier {  
  bool hasInternet = false; 
  List<Obra> _items = [];
  List<Obra> newObras = [];
  int countObras = 1;
  List<Obra> needUpdate = [];

  List<Obra> get items => [..._items];

  List<Obra> get andamentoItems => _items.where((prod) => prod.isIncomplete).toList();


  int get itemsCount {
    return _items.length;
  }

  onLoad() async {
    hasInternet = await hasInternetConnection();
    
    if(hasInternet == true){
       newObras = await obra_validation.missingFirebaseObras();
       needUpdate = await obra_validation.obrasNeedingUpdateFirebase();
    }
  }

  Future<void> loadProducts() async {
    List<Obra> toRemove = [];
    await onLoad();
    _items.clear();

    if(hasInternet == true){
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
            address: productData['address'],
            owner: productData['owner'],
            isDeleted: checkBool(productData['isDeleted']),
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
      final List<Obra> loadedObra = await DB.getObrasFromDB('obras');
      for(var item in loadedObra){
        _items.add(item);
      }
    }

    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> data) async {
    await onLoad();

    bool hasId = data['id'] != null;

    final product = Obra(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      engineer: data['engineer'] as String,
      address: data['address'] as String,
      owner: data['owner'] as String,
    );

    if (hasId) {
      if(hasInternet == true && needUpdate.isNotEmpty){
        for(var element in needUpdate){
          await updateProduct(element);
        }
      }
      return updateProduct(product);
    } else {
      countObras = 1;
      if(newObras.isNotEmpty && hasInternet == true){
        for (var element in newObras) {
          await addProduct(element);
        }
      }
      countObras = 0;
      newObras.clear();
      return await addProduct(product);
    }
  }


  Future<void> addProduct(Obra product) async {
    String id;
    Obra novaObra;
    List<Obra> toRemove = [];
    if(hasInternet == true){
      final response = await http.post(
        Uri.parse('${Constants.PRODUCT_BASE_URL}.json'),
        body: jsonEncode(
          {
            "name": product.name,
            "engineer": product.engineer,
            "owner": product.owner,
            "address": product.address,
            "isIncomplete": product.isIncomplete,
          },
        ),
      );

      id = jsonDecode(response.body)['name'];

    }else{
        id = Random().nextDouble().toString();
    }
    novaObra = Obra(
          id: id,
          name: product.name,
          engineer: product.engineer,
          owner: product.owner,
          address: product.address,
      );
    _items.add(novaObra);


    if(countObras == 0){
      await DB.insert('obras', novaObra.toMapSQL());
    }

    for(var item in _items){
      if(item.isDeleted == true){
        toRemove.add(item);
      }
    }

    _items.removeWhere((element) => toRemove.contains(element));


    _items = _items.toSet().toList();


    await loadProducts();
    notifyListeners();
  }

 
  Future<void> updateProduct(Obra product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if(hasInternet == true){
      if (index >= 0) {
        await http.patch(
          Uri.parse('${Constants.PRODUCT_BASE_URL}/${product.id}.json'),
          body: jsonEncode(
            {
              "name": product.name,
              "engineer": product.engineer,
              "address": product.address,
              "owner": product.owner,
            },
          ),
        );
        _items[index] = product;
      }
      DB.updateObra(product);
    }else{
      DB.updateObra(product);
    }
    notifyListeners();
  }

  Future<void> removeProduct(Obra product) async {
    if(hasInternet == true){
      int index = _items.indexWhere((p) => p.id == product.id);

      product.toggleDeletion();
    }

    await DB.deleteObra(product);
    await loadProducts();
    notifyListeners();
  }
}