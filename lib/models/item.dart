import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../utils/util.dart';

class Items with ChangeNotifier{
  final String id;
  final String item;
  final String matchmakingId;
  final DateTime beginningDate;
  final DateTime endingDate;
  final String description;
  bool isUpdated;
  bool isGood;
  bool isDeleted;
  bool needFirebase;

  Items({
    required this.beginningDate,
    required this.id,
    required this.item,
    required this.endingDate,
    required this.matchmakingId,
    required this.description,
    this.isGood = false,
    this.isUpdated = false,
    this.isDeleted = false,
    this.needFirebase = false,
  });

  Map<String, dynamic> toMapSQL() {
    return {
      'id': id,
      'item': item,
      'matchmakingId': matchmakingId,
      'isUpdated': boolToSql(isUpdated),
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
      isUpdated: map['isUpdated'] != null ? checkBool(map['isUpdated']) : false,
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


  
} 