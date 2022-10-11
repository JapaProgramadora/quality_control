
import 'dart:convert';

import 'package:control/models/evaluation.dart';
import 'package:control/models/item.dart';
import 'package:control/models/method.dart';
import 'package:control/models/stage.dart';

import '../utils/constants.dart';
import '../utils/db.dart';
import '../models/obra.dart';
import 'package:http/http.dart' as http;


List<Obra> _items = [];
List<Stage> _itemsStage = [];
List<Items> _itemsItens = [];
List<Method> _itemsMethod = [];
List<Evaluation> _itemsEvaluation = [];

Future<void> loadObras(List something) async {
    final response = await http.get(
      Uri.parse('${Constants.PRODUCT_BASE_URL}.json'),
    );

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      something.add(
        Obra(
          id: productId,
          name: productData['name'],
          engineer: productData['engineer'],
          address: productData['address'],
          owner: productData['owner'],
        ),
      );
    });
}

Future<void> loadStages() async {
    final response = await http.get(
      Uri.parse('${Constants.STAGE_BASE_URL}.json'),
    );

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      _itemsStage.add(
        Stage(
          id: productId,
          stage: productData['stage'],
          matchmakingId: productData['matchmakingId'],
        ),
      );
    });
}

Future<void> loadItems() async {
    final response = await http.get(
      Uri.parse('${Constants.ITEM_BASE_URL}.json'),
    );

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      _itemsItens.add(
        Items(
          id: productId,
          item: productData['item'],
          description: productData['description'],
          beginningDate: DateTime.parse(productData['beginningDate']),
          endingDate: DateTime.parse(productData['endingDate']),
          matchmakingId: productData['matchmakingId'],
        ),
      );
    });
}

Future<List<Obra>> missingFirebaseObras() async {
    final List<Obra> loadedObra = await DB.getObrasFromDB('obras');
    final List<Obra> matchingItems = [];
    final List<Obra> notMatchingItems = [];
    final List<Obra> toRemove = [];

    if(loadedObra.isEmpty){
      return [];
    }

    await loadObras(_items);

    if(_items.isEmpty){
      return loadedObra;
    }

    for(var item in _items){
      if(item.isDeleted == true){
        toRemove.add(item);
      }
    }

    _items.removeWhere((element) => toRemove.contains(element));

    for(var obra in loadedObra) {
      for(var item in _items) {        
        if(obra.id == item.id){
          if(!matchingItems.contains(obra)){
            matchingItems.add(obra);
          }
        }else{
          if(!notMatchingItems.contains(obra)){
            notMatchingItems.add(obra);
          }
        }
      }
    }

    notMatchingItems.removeWhere((element) => matchingItems.contains(element));

    return notMatchingItems;
}

Future<List<Obra>> obrasNeedingUpdateFirebase() async {
    final List<Obra> loadedObras = await DB.getObrasFromDB('obras');
    final List<Obra> needUpdateObras = [];

    if(loadedObras.isEmpty){
      return [];
    }

    for(var obra in loadedObras){
      if(obra.isUpdated == true){
        needUpdateObras.add(obra);
      }
    }
  
    return needUpdateObras;
}

Future<List<Stage>> stagesNeedingUpdate() async {
    final List<Stage> loadedStages = await DB.getStagesFromDb('stages');
    final List<Stage> needUpdateObras = [];

    if(loadedStages.isEmpty){
      return [];
    }

    for(var stage in loadedStages){
      if(stage.isUpdated == true){
        needUpdateObras.add(stage);
      }
    }
  
    return needUpdateObras;
}
