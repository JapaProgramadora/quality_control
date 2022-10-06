// ignore_for_file: file_names, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import '../utils/db.dart';
import '../utils/util.dart';
import '../validation/connectivity.dart';

class Evaluation with ChangeNotifier{
  bool hasInternet = false;
  String id;
  String error;
  String matchmakingId;
  String locationId;
  bool isEPI;
  bool isOrganized;
  bool isProductive;
  bool isUpdated;
  bool isDeleted;
  bool needFirebase;

  Evaluation({
    required this.id,
    required this.error,
    required this.matchmakingId,
    required this.locationId,
    this.isEPI = false,
    this.isOrganized = false,
    this.isProductive = false,
    this.isDeleted = false,
    this.isUpdated = false,
    this.needFirebase = false,
  });

  onLoad() async {
    hasInternet = await hasInternetConnection();
  }

  Future<void> changeEPI(bool isOkay, Evaluation evaluation) async {
    await onLoad();
    if(isOkay == true){
        isEPI = true;
    }else{
        isEPI = false;
    }


    if(hasInternet == true){
      final response = await http.patch(
          Uri.parse('${Constants.ERROR_METHOD_URL}/$id.json'),
          body: jsonEncode({"isEPI": isEPI}),
      );
    }

    await DB.updateInfo('evaluation', evaluation.id, evaluation.toMapSQL());
    notifyListeners();
  }

  Future<void> changeProductive(bool isOkay, Evaluation evaluation) async {
    await onLoad();
    if(isOkay == true){
        isProductive = true;
    }else{
        isProductive = false;
    }

    if(hasInternet == true){
      final response = await http.patch(
          Uri.parse('${Constants.ERROR_METHOD_URL}/$id.json'),
          body: jsonEncode({"isProductive": isProductive}),
      );
    }
    await DB.updateInfo('evaluation', evaluation.id, evaluation.toMapSQL());
    notifyListeners();
  }

  Future<void> changeOrganized(bool isOkay, Evaluation evaluation) async {
    await onLoad();
    if(isOkay == true){
        isOrganized = true;
    }else{
        isOrganized = false;
    }

    if(hasInternet == true){
      final response = await http.patch(
        Uri.parse('${Constants.ERROR_METHOD_URL}/$id.json'),
        body: jsonEncode({"isOrganized": isOrganized}),
      );
    }
    await DB.updateInfo('evaluation', evaluation.id, evaluation.toMapSQL());
    notifyListeners();
  }

  void toggleDeleted(){
    isDeleted = !isDeleted;
    notifyListeners();
  }

  Future<void> toggleDeletion() async {
    try {
      toggleDeleted();

      final response = await http.patch(
        Uri.parse('${Constants.ERROR_METHOD_URL}/$id.json'),
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

  factory Evaluation.fromSQLMap(Map<String, dynamic> map) {
    return Evaluation(
      id: map['id'] as String,
      error: map['error'] as String,
      matchmakingId: map['matchmakingId'] as String,
      locationId: map['locationId'] as String,
      isOrganized: map['isOrganized'] != null ? checkBool(map['isOrganized']) : false,
      isEPI: map['isEPI'] != null ? checkBool(map['isEPI']) : false,
      isProductive: map['isProductive'] != null ? checkBool(map['isProductive']) : false,
      isUpdated: map['isUpdated'] != null ? checkBool(map['isUpdated']) : true,
      isDeleted: map['isDeleted'] != null? checkBool(map['isDeleted']) : true,
      needFirebase: map['needFirebase'] != null? checkBool(map['needFirebase']) : false,
    );
  }

  Map<String, dynamic> toMapSQL() {
    return {
      'id': id,
      'error': error,
      'matchmakingId': matchmakingId,
      'isUpdated': boolToSql(isUpdated),
      'isOrganized': boolToSql(isOrganized),
      'locationId': locationId,
      'isEPI': boolToSql(isEPI),
      'isDeleted': boolToSql(isDeleted),
      'isProductive': boolToSql(isProductive),
      'needFirebase': boolToSql(needFirebase),
    };
  }
}