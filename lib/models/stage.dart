
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../utils/db.dart';
import '../utils/util.dart';
import '../validation/connectivity.dart';

class Stage with ChangeNotifier{
  String id;
  String stage;
  String matchmakingId;
  bool isDeleted;
  DateTime lastUpdated;
  bool isComplete;
  bool needFirebase;
  bool hasInternet = false;

  Stage({
    required this.id,
    required this.stage,
    this.isComplete = false,
    required this.matchmakingId,
    this.isDeleted = false,
    required this.lastUpdated,
    this.needFirebase = false,
  });

  void toggleDeleted(){
    isDeleted = !isDeleted;
    notifyListeners();
  }

  Future<void> toggleDeletion() async {
    try {
      toggleDeleted();

      final response = await http.patch(
        Uri.parse('${Constants.STAGE_BASE_URL}/$id.json'),
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

  factory Stage.fromSQLMap(Map<String, dynamic> map) {
    return Stage(
      id: map['id'] as String,
      stage: map['stage'] as String,
      matchmakingId: map['matchmakingId'] as String,
      lastUpdated: DateTime.parse(map['lastUpdated']),
      isDeleted: map['isDeleted'] != null? checkBool(map['isDeleted']) : true,
      isComplete: map['isComplete'] != null? checkBool(map['isComplete']) : true,
      needFirebase: map['needFirebase'] != null? checkBool(map['needFirebase']) : true,
    );
  }

  Map<String, dynamic> toMapSQL() {
    return {
      'id': id,
      'stage': stage,
      'matchmakingId': matchmakingId,
      'lastUpdated': lastUpdated.toIso8601String(),
      'isDeleted': boolToSql(isDeleted),
      'isComplete': boolToSql(isComplete),
      'needFirebase': boolToSql(needFirebase),
    };
  }

  onLoad() async {
    hasInternet = await hasInternetConnection();
  }

  Future<void> changeStageGood(bool isOkay, Stage stage) async {
    await onLoad();
    if(isOkay == true){
      isComplete = true;
    }else{
      isComplete = false;
    }

    if(hasInternet == true){
      final response = await http.patch(
        Uri.parse('${Constants.STAGE_BASE_URL}/$id.json'),
        body: jsonEncode({"isComplete": isComplete}),
      );
    }

    await DB.updateInfo('stages', stage.id, stage.toMapSQL());
    notifyListeners();
  }
}