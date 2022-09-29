
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
  String method;
  String tolerance;
  String team;
  bool isMethodGood;
  String matchmakingId;
  bool isDeleted;
  bool isUpdated;
  bool hasInternet = false;

  Method({
    required this.id,
    required this.tolerance,
    required this.method,
    required this.team,
    required this.matchmakingId,
    this.isMethodGood = true,
    this.isDeleted = false,
    this.isUpdated = false,
  });

  onLoad() async {
    hasInternet = await hasInternetConnection();
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
      'method': method,
      'matchmakingId': matchmakingId,
      'isUpdated': boolToSql(isUpdated),
      'isDeleted': boolToSql(isDeleted),
      'isMethodGood': boolToSql(isMethodGood),
      'tolerance': tolerance,
      'team': team,
    };
  }

  factory Method.fromSQLMap(Map<String, dynamic> map) {
    return Method(
      id: map['id'] as String,
      method: map['method'] as String,
      matchmakingId: map['matchmakingId'] as String,
      team: map['team'] as String,
      tolerance: map['tolerance'] != null? map['tolerance'] as String: '',
      isUpdated: map['isUpdated'] != null ? checkBool(map['isUpdated']) : false,
      isDeleted: map['isDeleted'] != null? checkBool(map['isDeleted']) : false,
      isMethodGood: map['isMethodGood'] != null? checkBool(map['isMethodGood']) : false,
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