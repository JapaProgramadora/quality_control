// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:math';

import 'package:control/models/location.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import '../utils/db.dart';
import '../utils/util.dart';
import '../validation/connectivity.dart';

class LocationList with ChangeNotifier {  
  final List<Location> _items = [];
  bool hasInternet = false;
  int countLocations = 0;
  int checkFirebase = 1;

  List<Location> get items => [..._items];

  //List<Obra> get testItems => _items.where((prod) => prod.matchmakingId.contains(other)).toList();

  //final categoriesMeal = meals.where((meal){
       //return meal.categories.contains(category.id);
   // }).toList();
  List<Location> getAllItems(matchId){
    return _items.where((prod) => prod.matchmakingId == matchId).toList();
  }

  List<Location> getSpecificLocation(matchId){
    return _items.where((p) => p.id == matchId).toList();
  }

  int get itemsCount {
    return _items.length;
  }

  addToFirebase() async {
    final List<Location> loadedObra = await DB.getObrasFromDB('obras');
      checkFirebase = 1;
      countLocations = 1;
      for(var item in loadedObra){
        if(item.isDeleted == false && item.needFirebase == true){
          item.needFirebase = false;
          await DB.updateInfo('location', item.id, item.toMapSQL());
          await addLocation(item);
        }
      }
    countLocations = 0;
  }

  onLoad() async {
    hasInternet = await hasInternetConnection();
  }

  Future<void> loadLocation() async {
    List<Location> toRemove = [];
    _items.clear();

    if(hasInternet == true){
      final response = await http.get(
        Uri.parse('${Constants.LOCATION_BASE_URL}.json'),
      );
      if (response.body == 'null') return;
      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((locationId, locationData) {
          _items.add(
            Location(
              id: locationId,
              location: locationData['location'],
              matchmakingId: locationData['matchmakingId'],
              needFirebase: checkBool(locationData['needFirebase']),
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
      final List<Location> loadedLocation = await DB.getLocationFromDB();
        for(var item in loadedLocation){
          _items.add(item);
      }
    }
    notifyListeners();
  }

  Future<void> saveLocation(Map<String, Object> data) async {
    await onLoad();
    bool hasId = data['id'] != null;

    final product = Location(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      location: data['location'] as String,
      matchmakingId: data['matchmakingId'] as String,
    );

    if (hasId) {
      return updateLocation(product);
    } else {
      return addLocation(product);
    }
  }

  Future<void> addLocation(Location product) async {
    String id;
    bool needFirebase;
    if(hasInternet == true){
      needFirebase = false;
      final response = await http.post(
      Uri.parse('${Constants.LOCATION_BASE_URL}.json'),
      body: jsonEncode(
          {
            "matchmakingId": product.matchmakingId,
            "location": product.location,
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

    Location newLocation = Location(
        id: id,
        location: product.location,
        isDeleted: product.isDeleted,
        matchmakingId: product.matchmakingId,
        needFirebase: needFirebase,
    );

    if(countLocations == 0){
      await DB.insert('location', newLocation.toMapSQL());
    } 

    _items.clear();
    await loadLocation();
    notifyListeners();
  }

 
  Future<void> updateLocation(Location product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('${Constants.LOCATION_BASE_URL}/${product.id}.json'),
        body: jsonEncode(
          {
            "location": product.location,
            "matchmakingId": product.matchmakingId,
          },
        ),
      );

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeLocation(Location product) async {
     if(hasInternet == true){
      product.toggleDeletion();
    }

    await DB.deleteInfo("stages", product.id);
    await loadLocation();
    notifyListeners();
  }

}