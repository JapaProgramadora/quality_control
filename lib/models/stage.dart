
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../utils/util.dart';

class Stage with ChangeNotifier{
  String id;
  String stage;
  String matchmakingId;
  bool isDeleted;
  bool isUpdated;
  bool isComplete;
  bool needFirebase;

  Stage({
    required this.id,
    required this.stage,
    this.isComplete = false,
    required this.matchmakingId,
    this.isDeleted = false,
    this.isUpdated = false,
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
      isUpdated: map['isUpdated'] != null ? checkBool(map['isUpdated']) : true,
      isDeleted: map['isDeleted'] != null? checkBool(map['isDeleted']) : true,
      isComplete: map['isComplete'] != null? checkBool(map['isComplete']) : true,
      needFirebase: map['needFirebase'] != null? checkBool(map['needFirebase']) : false,
    );
  }

  Map<String, dynamic> toMapSQL() {
    return {
      'id': id,
      'stage': stage,
      'matchmakingId': matchmakingId,
      'isUpdated': boolToSql(isUpdated),
      'isDeleted': boolToSql(isDeleted),
      'isComplete': boolToSql(isComplete),
      'needFirebase': boolToSql(needFirebase),
    };
  }
}