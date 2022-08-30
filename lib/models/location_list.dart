// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:math';

import 'package:control/models/location.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class LocationList with ChangeNotifier {  
  final List<Location> _items = [];

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

  Future<void> loadLocation() async {
    _items.clear();

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
          ),
        );
    });
    print(_items);
    notifyListeners();
  }

  Future<void> saveLocation(Map<String, Object> data) {
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
    final response = await http.post(
      Uri.parse('${Constants.LOCATION_BASE_URL}.json'),
      body: jsonEncode(
        {
          "matchmakingId": product.matchmakingId,
          "location": product.location,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    _items.add(Location(
      id: id,
      location: product.location,
      matchmakingId: product.matchmakingId,
    ));
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
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('${Constants.LOCATION_BASE_URL}/${product.id}.json'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
      }
    }
  }

}