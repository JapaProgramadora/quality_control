import 'dart:convert';
import 'package:control/utils/db.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../utils/util.dart';
import '../validation/connectivity.dart';

class Items with ChangeNotifier{
  final String id;
  final String item;
  final String matchmakingId;
  final DateTime beginningDate;
  final DateTime endingDate;
  final String description;
  DateTime lastUpdated;
  bool isGood;
  bool hasInternet = false;
  bool isDeleted;
  bool needFirebase;

  Items({
    required this.beginningDate,
    required this.id,
    required this.item,
    required this.endingDate,
    required this.matchmakingId,
    required this.description,
    required this.lastUpdated,
    this.isGood = false,
    this.isDeleted = false,
    this.needFirebase = false,
  });

  Map<String, dynamic> toMapSQL() {
    return {
      'id': id,
      'item': item,
      'matchmakingId': matchmakingId,
      'lastUpdated': lastUpdated.toIso8601String(),
      'isDeleted': boolToSql(isDeleted),
      'isGood': boolToSql(isGood),
      'description': description,
      'beginningDate': beginningDate.toIso8601String(),
      'endingDate': endingDate.toIso8601String(),
      'needFirebase': boolToSql(needFirebase),
    };
  }

  factory Items.fromSQLMap(Map<String, dynamic> map) {
    return Items(
      id: map['id'] as String,
      item: map['item'] as String,
      matchmakingId: map['matchmakingId'] as String,
      description: map['description'] != null? map['description'] as String: '',
      beginningDate: DateTime.parse(map['beginningDate']),
      endingDate: DateTime.parse(map['endingDate']),
      lastUpdated: DateTime.parse(map['lastUpdated']),
      isDeleted: map['isDeleted'] != null? checkBool(map['isDeleted']) : false,
      isGood: map['isGood'] != null? checkBool(map['isGood']) : false,
      needFirebase: map['needFirebase'] != null? checkBool(map['needFirebase']) : false,
    );
  }

  void toggleDeleted(){
    isDeleted = !isDeleted;
    notifyListeners();
  }

  Future<void> toggleDeletion() async {
    try {
      toggleDeleted();

      final response = await http.patch(
        Uri.parse('${Constants.ITEM_BASE_URL}/$id.json'),
        body: jsonEncode({"isDeleted": isDeleted}),
      );

      if (response.statusCode >= 400) {
        toggleDeleted();
      }
    } catch (_) {
      toggleDeleted();
    }

    notifyListeners();
  }

  onLoad() async {
    hasInternet = await hasInternetConnection();
  }

  Future<void> changeItemGood(bool isOkay, Items item) async {
    await onLoad();
    if(isOkay == true){
      isGood = true;
    }else{
      isGood = false;
    }

    if(hasInternet == true){
      final response = await http.patch(
        Uri.parse('${Constants.ITEM_BASE_URL}/$id.json'),
        body: jsonEncode({"isGood": isGood}),
      );
    }

    await DB.updateInfo('items', item.id, item.toMapSQL());
    notifyListeners();
  }


  
} 