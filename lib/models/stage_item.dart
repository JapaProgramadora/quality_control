import 'package:flutter/material.dart';

class Items with ChangeNotifier{
  final String id;
  final String item;
  final String method;
  final double tolerance;
  final String matchmakingId;
  bool isGood;

  Items({
    required this.id,
    required this.item,
    required this.method,
    this.tolerance = 0.0,
    required this.matchmakingId,
    this.isGood = false,
  });

  void toggleGood(){
    isGood = !isGood;
    notifyListeners();
  }
  
} 