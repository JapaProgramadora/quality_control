import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../utils/util.dart';

class Team with ChangeNotifier{
  String id;
  String team;
  DateTime lastUpdated;
  bool isDeleted;
  bool needFirebase;

  Team({
    required this.id,
    required this.team,
    this.isDeleted = false,
    required this.lastUpdated,
    this.needFirebase = false,
  });

  factory Team.fromSQLMap(Map<String, dynamic> map) {
    return Team(
      id: map['id'] as String,
      team: map['team'] as String,
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
        Uri.parse('${Constants.TEAM_URL}/$id.json'),
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
      'team': team,
      'lastUpdated': lastUpdated.toIso8601String(),
      'isDeleted': boolToSql(isDeleted),
      'needFirebase': boolToSql(needFirebase),
    };
  }

}