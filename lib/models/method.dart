
import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class Method with ChangeNotifier{
  String id;
  String method;
  String tolerance;
  String team;
  bool isTeamGood;
  bool isMethodGood;
  String errorDescription;
  String matchmakingId;

  Method({
    required this.id,
    required this.tolerance,
    required this.method,
    required this.team,
    this.errorDescription = '',
    this.isMethodGood = true,
    this.isTeamGood = true,
    required this.matchmakingId,
  });

  void toggleMethodGood() {
    isMethodGood = !isMethodGood;
    notifyListeners();
  }

  Future<void> changeMethodGood() async {
    try {
      toggleMethodGood();

      final response = await http.patch(
        Uri.parse('${Constants.METHOD_BASE_URL}/$id.json'),
        body: jsonEncode({"isMethodGood": isMethodGood}),
      );

      if (response.statusCode >= 400) {
        toggleMethodGood();
      }
    } catch (_) {
      toggleMethodGood();
    }
  }

}