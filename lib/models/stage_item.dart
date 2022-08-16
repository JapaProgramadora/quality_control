import 'dart:convert';

import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'package:http/http.dart' as http;

class Items with ChangeNotifier{
  final String id;
  final String item;
  final String method;
  final double tolerance;
  final String matchmakingId;
  final String description;
  final DateTime date;
  bool isGood;

  Items({
    required this.date,
    required this.id,
    required this.item,
    required this.method,
    this.tolerance = 0.0,
    required this.matchmakingId,
    this.description = '',
    this.isGood = false,
  });

  void toggleGood() {
    isGood = !isGood;
    notifyListeners();
  }

  Future<void> toggleSatisfaction() async {
    try {
      toggleGood();

      final response = await http.patch(
        Uri.parse('${Constants.ITEM_BASE_URL}/$id.json'),
        body: jsonEncode({"isGood": isGood}),
      );

      if (response.statusCode >= 400) {
        toggleGood();
      }
    } catch (_) {
      toggleGood();
    }
  }
  
} 