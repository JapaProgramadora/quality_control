// ignore_for_file: file_names, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class ErrorMethod with ChangeNotifier{
  String id;
  String error;
  bool isEPI;
  bool isOrganized;
  bool isProductive;
  String matchmakingId;

  ErrorMethod({
    required this.id,
    this.isEPI = false,
    this.isOrganized = false,
    this.isProductive = false,
    required this.error,
    required this.matchmakingId,
  });

  Future<void> changeEPI(bool isOkay) async {
    if(isOkay == true){
        isEPI = true;
    }else{
        isEPI = false;
    }

    final response = await http.patch(
        Uri.parse('${Constants.ERROR_METHOD_URL}/$id.json'),
        body: jsonEncode({"isEPI": isEPI}),
    );

    notifyListeners();
  }

  Future<void> changeProductive(bool isOkay) async {
    if(isOkay == true){
        isProductive = true;
    }else{
        isProductive = false;
    }

    final response = await http.patch(
        Uri.parse('${Constants.ERROR_METHOD_URL}/$id.json'),
        body: jsonEncode({"isProductive": isProductive}),
    );
  }

  Future<void> changeOrganized(bool isOkay) async {
    if(isOkay == true){
        isOrganized = true;
    }else{
        isOrganized = false;
    }

    final response = await http.patch(
        Uri.parse('${Constants.ERROR_METHOD_URL}/$id.json'),
        body: jsonEncode({"isOrganized": isOrganized}),
    );
  }
}