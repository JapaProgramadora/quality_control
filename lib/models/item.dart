import 'package:flutter/material.dart';

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
    };
  }

  factory Items.fromSQLMap(Map<String, dynamic> map) {
    return Items(
      id: map['id'] as String,
      item: map['item'] as String,
      matchmakingId: map['matchmakingId'] as String,
      description: map['description'] as String,
      beginningDate: map['beginningDate'] as DateTime,
      endingDate: map['endingDate'] as DateTime,
      isUpdated: map['isUpdated'] != null ? checkBool(map['isUpdated']) : true,
      isDeleted: map['isDeleted'] != null? checkBool(map['isDeleted']) : true
    );
  }

  
} 