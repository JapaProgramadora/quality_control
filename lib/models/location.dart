import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../utils/util.dart';

class Location with ChangeNotifier{
  String id;
  String location;
  String matchmakingId;
  DateTime lastUpdated;
  bool isDeleted;
  bool needFirebase;

  Location({
    required this.id,
    required this.location,
    required this.matchmakingId,
    this.isDeleted = false,
    required this.lastUpdated,
    this.needFirebase = false,
  });

  factory Location.fromSQLMap(Map<String, dynamic> map) {
    return Location(
      id: map['id'] as String,
      location: map['location'] as String,
      matchmakingId: map['matchmakingId'] as String,
      lastUpdated: DateTime.parse(map['lastUpdated']),
      isDeleted: map['isDeleted'] != null? checkBool(map['isDeleted']) : true,
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
        Uri.parse('${Constants.LOCATION_BASE_URL}/$id.json'),
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

  
  Map<String, dynamic> toMapSQL() {
    return {
      'id': id,
      'location': location,
      'matchmakingId': matchmakingId,
      'lastUpdated': lastUpdated.toIso8601String(),
      'isDeleted': boolToSql(isDeleted),
      'needFirebase': boolToSql(needFirebase),
    };
  }

}