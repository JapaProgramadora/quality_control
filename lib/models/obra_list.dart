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
  List<Obra> firebaseItems = [];
  List<Obra> newObras = [];
  int countObras = 0;
  int checkFirebase = 1;
  List<Obra> needUpdate = [];

  List<Obra> get items => [..._items];

  List<Obra> get andamentoItems => _items.where((prod) => prod.isComplete).toList();


  int get itemsCount {
    return _items.length;
  }

  addToFirebase() async {
    final List<Obra> loadedObra = await DB.getObrasFromDB('obras');
      checkFirebase = 1;
      countObras = 1;
      for(var item in loadedObra){
        if(item.isDeleted == false && item.needFirebase == true){
          item.needFirebase = false;
          await DB.updateInfo('obras', item.id, item.toMapSQL());
          await addProduct(item);
        }
      }
    countObras = 0;
  }

  onLoad() async {
    hasInternet = await hasInternetConnection();
  }


  Future<void> checkSQLData() async {
    hasInternet = true;
    final List<Obra> loadedObras = await DB.getObrasFromDB('obras');

    //adding if there's nothing on firebase;
    if(firebaseItems.isEmpty && loadedObras.isNotEmpty){
      countObras = 1;
      for(var obra in loadedObras){
        await addProduct(obra);
      }
      countObras = 0;
    }

    //adding if there's nothing on SQL;
    if(loadedObras.isEmpty && firebaseItems.isNotEmpty){
      for(var obra in firebaseItems){
        await DB.insert('obras', obra.toMapSQL());
      }
    }

    for(var item in firebaseItems){
      if(!loadedObras.contains(item)){
        await DB.insert('obras', item.toMapSQL());
      }
      if(item.isDeleted == true && loadedObras.contains(item)){
        await DB.deleteInfo('obras', item.id);
      }
    }
  }

  Future<void> checkUpdate() async {
    hasInternet = true;
    final List<Obra> loadedObra = await DB.getObrasFromDB('obras');
    if(firebaseItems.isEmpty){
      countObras = 1;
      for(var obra in loadedObra){
        await addProduct(obra);
      }
      countObras = 0;
    }
    for(var obraFirebase in firebaseItems){
      for(var obraSQL in loadedObra){
        if(obraSQL.id == obraFirebase.id){
          if((obraSQL.lastUpdated).isBefore(obraFirebase.lastUpdated)){
            //updating SQL information
            obraSQL.lastUpdated = DateTime.now();
            await DB.updateInfo('obras', obraSQL.id, obraSQL.toMapSQL());

            //setting lastUpdated to now in Firebase
            await http.patch(Uri.parse('${Constants.PRODUCT_BASE_URL}/${obraFirebase.id}.json'),
              body: jsonEncode({ "lastUpdated": DateTime.now().toIso8601String()}));
          }else{
            await http.patch(Uri.parse('${Constants.PRODUCT_BASE_URL}/${obraFirebase.id}.json'),
              body: jsonEncode(
                { 
                  "name": obraSQL.name,
                  "engineer": obraSQL.engineer,
                  "owner": obraSQL.owner,
                  "address": obraSQL.address,
                  "lastUpdated": DateTime.now().toIso8601String(),
                  "isComplete": obraSQL.isComplete,
                  "needFirebase": false,
                }
              ),
            );
          }
        }
      }
    }
  }

  Future<void> loadProducts() async {
    List<Obra> toRemove = [];
    await onLoad();
    _items.clear();
    firebaseItems.clear();

    if(hasInternet == true){
      final response = await http.get(
      Uri.parse('${Constants.PRODUCT_BASE_URL}.json'),
      );
      await addToFirebase();
      if (response.body == 'null') return;
      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((productId, productData) {
        firebaseItems.add(
          Obra(
            id: productId,
            lastUpdated: DateTime.parse(productData['lastUpdated']),
            name: productData['name'],
            engineer: productData['engineer'],
            address: productData['address'],
            owner: productData['owner'],
            isDeleted: checkBool(productData['isDeleted']),
            needFirebase: checkBool(productData['needFirebase']),
          ),
        );
      });
      
      for(var item in firebaseItems){
        if(item.isDeleted == true){
          toRemove.add(item);
        }
      }
      firebaseItems.removeWhere((element) => toRemove.contains(element));

    }
    final List<Obra> loadedObra = await DB.getObrasFromDB('obras');
    for(var item in loadedObra){
      _items.add(item);
    }
    
    notifyListeners();

  }

  Future<void> saveProduct(Map<String, Object> data) async {
    await onLoad();

    bool hasId = data['id'] != null;

    final product = Obra(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      lastUpdated: DateTime.now(),
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
      return await addProduct(product);
    }
  }


  Future<void> addProduct(Obra product) async {
    final lastUpdated = product.lastUpdated;
    String id;
    List<Obra> toRemove = [];
    bool needFirebase;
    if(hasInternet == true){
      needFirebase = false;
      final response = await http.post(
        Uri.parse('${Constants.PRODUCT_BASE_URL}.json'),
        body: jsonEncode(
          {
            "name": product.name,
            "engineer": product.engineer,
            "owner": product.owner,
            "address": product.address,
            "lastUpdated": product.lastUpdated.toIso8601String(),
            "isComplete": product.isComplete,
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

    Obra novaObra = Obra(
        id: id,
        lastUpdated: lastUpdated,
        name: product.name,
        engineer: product.engineer,
        owner: product.owner,
        address: product.address,
        needFirebase: needFirebase,
        isDeleted: product.isDeleted,
    );


    if(countObras == 0){
      await DB.insert('obras', novaObra.toMapSQL());
    }

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
    }
    await DB.updateInfo('obras', product.id, product.toMapSQL());
    await loadProducts();
    notifyListeners();
  }

  Future<void> removeProduct(Obra product) async {
    if(hasInternet == true){
      product.toggleDeletion();
    }

    await DB.deleteInfo("obras", product.id);
    await loadProducts();
    notifyListeners();
  }
}