
import 'dart:convert';
import 'package:http/http.dart' as http;


import 'package:flutter/material.dart';

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

  void toggleEPI() {
    isEPI = !isEPI;
  }

  Future<void> changeEPI() async {
    try {
      toggleEPI();

      final response = await http.patch(
        Uri.parse('${Constants.PRODUCT_BASE_URL}/$id.json'),
        body: jsonEncode({"isEPI": isEPI}),
      );

      if (response.statusCode >= 400) {
        toggleEPI();
      }
    } catch (_) {
      toggleEPI();
    }
  }
}