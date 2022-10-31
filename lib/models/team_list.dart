// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:math';

import 'package:control/models/team.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import '../utils/db.dart';
import '../utils/util.dart';
import '../validation/connectivity.dart';

class TeamList with ChangeNotifier {  
  final List<Team> _items = [];
  bool hasInternet = false;
  int countTeams = 0;
  int checkFirebase = 1;

  List<Team> get items => [..._items];

  //List<Obra> get testItems => _items.where((prod) => prod.matchmakingId.contains(other)).toList();

  //final categoriesMeal = meals.where((meal){
       //return meal.categories.contains(category.id);
   // }).toList();
   

  Future<List<Team>> getAllTeams() async {
    await loadTeams();
    return _items;
  }

  List<Team> getSpecificTeams(matchId){
    return _items.where((p) => p.id == matchId).toList();
  }

  int get itemsCount {
    return _items.length;
  }

  onLoad() async {
    hasInternet = await hasInternetConnection();
  }

  addToFirebase() async {
    final List<Team> loadedStages = await DB.getTeamFromDB();
      checkFirebase = 1;
      countTeams = 1;
      for(var item in loadedStages){
        if(item.isDeleted == false && item.needFirebase == true){
          item.needFirebase = false;
          await DB.updateInfo('stages', item.id, item.toMapSQL());
          await addTeam(item);
        }
      }
    countTeams = 0;
  }


  Future<void> loadTeams() async {
    List<Team> toRemove = [];
    _items.clear();
    await onLoad();

    if(hasInternet == true){
        final response = await http.get(
          Uri.parse('${Constants.TEAM_URL}.json'),
        );
        if (response.body == 'null') return;
        Map<String, dynamic> data = jsonDecode(response.body);
        data.forEach((locationId, locationData) {
          _items.add(
            Team(
              id: locationId,
              team: locationData['team'],
              isDeleted: checkBool(locationData['isDeleted']),
              isUpdated: checkBool(locationData['isUpdated']),
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
       final List<Team> loadedTeams = await DB.getTeamFromDB();
      for(var item in loadedTeams){
        _items.add(item);
      }
    }
    notifyListeners();
  }

  Future<void> saveTeam(Map<String, Object> data) async {
    bool hasId = data['id'] != null;

    final product = Team(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      team: data['team'] as String,
    );

    if (hasId) {
      return updateLocation(product);
    } else {
      return addTeam(product);
    }
  }

  Future<void> addTeam(Team product) async {
    String id;
    List<Team> toRemove = [];
    bool needFirebase;
    if(hasInternet == true){
      needFirebase = false;
      final response = await http.post(Uri.parse('${Constants.TEAM_URL}.json'),
      body: jsonEncode(
          {
            "team": product.team,
            "isDeleted": product.isDeleted,
            "isUpdated": product.isUpdated,
          },
        ),
      );
      id = jsonDecode(response.body)['name']; 
    }else{
      id = Random().nextDouble().toString();
      needFirebase = true;
      checkFirebase = 0;
    }

    Team novoStage = Team(
        id: id,
        team: product.team,
        needFirebase: needFirebase,
        isDeleted: product.isDeleted,
        isUpdated: product.isUpdated,
    );

    if(countTeams == 0){
      await DB.insert('teams', novoStage.toMapSQL());
    } 
    
    await loadTeams();
    notifyListeners();
  }

 
  Future<void> updateLocation(Team product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if(hasInternet == true){
        if (index >= 0) {
        await http.patch(
          Uri.parse('${Constants.TEAM_URL}/${product.id}.json'),
          body: jsonEncode(
          {
            "team": product.team,
          },
        ),
        );

      _items[index] = product;
      }
    }
    await DB.updateInfo('teams', product.id, product.toMapSQL());
    await loadTeams();
    notifyListeners();
  }

  Future<void> removeTeam(Team product) async {
     if(hasInternet == true){
      product.toggleDeletion();
    }
    await loadTeams();
    notifyListeners();
  }

}