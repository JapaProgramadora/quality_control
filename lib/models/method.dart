
// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class Method with ChangeNotifier{
  String id;
  String method;
  String tolerance;
  String team;
  bool isMethodGood;
  String matchmakingId;

  Method({
    required this.id,
    required this.tolerance,
    required this.method,
    required this.team,
    this.isMethodGood = true,
    required this.matchmakingId,
  });

  Future<void> changeMethodGood(bool isOkay) async {
    if(isOkay == true){
      isMethodGood = true;
    }else{
      isMethodGood = false;
    }

    final response = await http.patch(
        Uri.parse('${Constants.METHOD_BASE_URL}/$id.json'),
        body: jsonEncode({"isMethodGood": isMethodGood}),
    );

    notifyListeners();
  }

}