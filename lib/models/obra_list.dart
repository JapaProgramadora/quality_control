// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:path/path.dart';

import 'obra.dart';
import '../utils/db.dart';
import 'package:control/utils/util.dart';
import '../validation/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class ObraList with ChangeNotifier {  
  bool hasInternet = false; 
  List<Obra> _items = [];
  final LinkedList<Obra> list = LinkedList();
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

  bool getSpecificObra(String id){
    if(_items.isEmpty){
      return true;
    }
    return _items.where((p) => p.id == id).toList().isEmpty ? false : true;
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


  Future<void> checkData() async {
    hasInternet = true;
    List<Obra> toRemove = [];
    List<Obra> localUpdates = [];
    List<Obra> fireUpdates = [];
    final List<Obra> loadedObras = await DB.getObrasFromDB('obras');

    //if there's nothing on each;
    if(firebaseItems.isEmpty && loadedObras.isEmpty){
      return;
    }

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
        if(obra.isDeleted == false){
          await DB.insert('obras', obra.toMapSQL());
        }
      }
    }else if(firebaseItems.isEmpty && loadedObras.isNotEmpty){
      countObras = 1;
      for(var obra in loadedObras){
        await addProduct(obra);
      }
      countObras = 0;
    }

    //if there's any obra needing firebase;
    for(var obra in loadedObras){
      countObras = 1;
      if(obra.needFirebase == true && obra.isDeleted == false){
        await addProduct(obra);
      }
      if(obra.isDeleted == true){
        await http.patch(Uri.parse('${Constants.PRODUCT_BASE_URL}/${obra.id}.json'),body: jsonEncode({"isDeleted": obra.isDeleted}),);
        await DB.deleteInfo('obras', obra.id);
      }
      if(obra.isUpdated == true && obra.isDeleted == false){
        localUpdates.add(obra);
      }
      countObras = 0;
    }
    
    
    //if there's any obra needing sql
    for(var item in firebaseItems){
      bool value = getSpecificObra(item.id);
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
    // for(var fire in fireUpdates){
    //   for(var obra in loadedObras){
    //     if(fire.id == obra.id){
    //       if((fire.lastUpdated).isAfter(obra.lastUpdated)){
    //         await DB.updateInfo('obras', obra.id, fire.toMapSQL());
    //          await http.patch(Uri.parse('${Constants.PRODUCT_BASE_URL}/${fire.id}.json'),
    //           body: jsonEncode({ 
    //             "lastUpdated": DateTime.now().toIso8601String(),
    //             "isUpdated": false,
    //             }
    //         ));
    //       }
    //     }
    //   }
    //   for(var obra in localUpdates){
    //     if(obra.id == fire.id){
    //       if((obra.lastUpdated).isAfter(fire.lastUpdated)){
    //         await http.patch(Uri.parse('${Constants.PRODUCT_BASE_URL}/${fire.id}.json'),
    //           body: jsonEncode(
    //             { 
    //               "name": obra.name,
    //               "engineer": obra.engineer,
    //               "owner": obra.owner,
    //               "address": obra.address,
    //               "lastUpdated": DateTime.now().toIso8601String(),
    //               "isComplete": obra.isComplete,
    //               "needFirebase": false,
    //             }
    //           ),
    //         );
    //       }
    //     }
    //     obra.isUpdated = false;
    //     await DB.updateInfo('obras', obra.id, obra.toMapSQL());
    //   }
    // }
  }

  Future<void> loadProducts() async {
    await onLoad();
    List<Obra> toRemove = [];
    _items.clear();

    if(hasInternet == true){
      final response = await http.get(
      Uri.parse('${Constants.PRODUCT_BASE_URL}.json'),
      );
      await addToFirebase();
      if (response.body == 'null') return;
      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((productId, productData) {
        _items.add(
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
      
      for(var item in _items){
        if(item.isDeleted == true){
          toRemove.add(item);
        }
      }

      _items.removeWhere((element) => toRemove.contains(element));

    }else{
      List<Obra> loadedObra = await DB.getObrasFromDB('obras');
        for(var obra in loadedObra){
          _items.add(obra);
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
            "isUpdated": product.isUpdated,
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
              "isUpdated": true,
              "lastUpdated": DateTime.now().toIso8601String(),
            },
          ),
        );
        _items[index] = product;
      }
    }else{
      product.isUpdated = true;
    }
    product.lastUpdated = DateTime.now();
    await DB.updateInfo('obras', product.id, product.toMapSQL());
    await loadProducts();
    notifyListeners();
  }

  Future<void> removeProduct(Obra product) async {
    if(hasInternet == true){
      product.toggleDeletion();
      await DB.deleteInfo("obras", product.id);
    }else{
      product.isDeleted = true;
      await DB.updateInfo('obras', product.id, product.toMapSQL());
    }
    _items.remove(product);
    notifyListeners();
  }
}