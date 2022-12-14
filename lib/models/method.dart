
// ignore_for_file: unused_local_variable

import 'package:control/validation/connectivity.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import '../utils/db.dart';
import '../utils/util.dart';

class Method with ChangeNotifier{
  String id;
  List<String> method;
  String item;
  List<String> tolerance;
  String team;
  bool isMethodGood;
  String matchmakingId;
  bool isDeleted;
  bool isComplete;
  bool isDependent;
  DateTime lastUpdated;
  bool hasInternet = false;
  bool needFirebase;

  Method({
    required this.id,
    required this.tolerance,
    required this.item,
    required this.method,
    required this.team,
    required this.matchmakingId,
    this.isMethodGood = true,
    this.isDeleted = false,
    required this.lastUpdated,
    this.isComplete = false,
    this.isDependent = false,
    this.needFirebase = false,
  });

  onLoad() async {
    hasInternet = await hasInternetConnection();
  }

  Future<void> changeDependent(bool isOkay, Method method) async {
    await onLoad();
    if(isOkay == true){
      isDependent = true;
    }else{
      isDependent = false;
    }

    if(hasInternet == true){
      final response = await http.patch(
        Uri.parse('${Constants.METHOD_BASE_URL}/$id.json'),
        body: jsonEncode({"isDependent": isDependent}),
      );
    }

    await DB.updateInfo('method', method.id, method.toMapSQL());
    notifyListeners();
  }

  Future<void> changeMethodGood(bool isOkay, Method method) async {
    await onLoad();
    if(isOkay == true){
      isMethodGood = true;
    }else{
      isMethodGood = false;
    }

    if(hasInternet == true){
      final response = await http.patch(
        Uri.parse('${Constants.METHOD_BASE_URL}/$id.json'),
        body: jsonEncode({"isMethodGood": isMethodGood}),
      );
    }

    await DB.updateInfo('method', method.id, method.toMapSQL());
    notifyListeners();
  }

  Map<String, dynamic> toMapSQL() {
    return {
      'id': id,
      'method': method.join(','),
      'item': item,
      'matchmakingId': matchmakingId,
      'lastUpdated': lastUpdated.toIso8601String(),
      'isDeleted': boolToSql(isDeleted),
      'isDependent': boolToSql(isDependent),
      'isMethodGood': boolToSql(isMethodGood),
      'isComplete': boolToSql(isComplete),
      'tolerance': tolerance.join(','),
      'team': team,
      'needFirebase': boolToSql(needFirebase),
    };
  }

  factory Method.fromSQLMap(Map<String, dynamic> map) {
    return Method(
      id: map['id'] as String,
      method: map['method'].split(',') as List<String>,
      item: map['item'] as String,
      matchmakingId: map['matchmakingId'] as String,
      team: map['team'] as String,
      tolerance: map['tolerance'].split(',') as List<String>,
      lastUpdated: DateTime.parse(map['lastUpdated']),
      isDeleted: map['isDeleted'] != null? checkBool(map['isDeleted']) : false,
      isDependent: map['isDependent'] != null? checkBool(map['isDependent']) : false,
      isComplete: map['isComplete'] != null? checkBool(map['isComplete']) : false,
      isMethodGood: map['isMethodGood'] != null? checkBool(map['isMethodGood']) : false,
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
        Uri.parse('${Constants.METHOD_BASE_URL}/$id.json'),
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