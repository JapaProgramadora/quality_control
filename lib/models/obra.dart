import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../utils/constants.dart';
import 'package:http/http.dart' as http;

class Obra with ChangeNotifier {
  final String id;
  final String name;
  final String engineer;
  final String owner;
  final String address;
  bool isIncomplete;

  Obra({
    required this.id,
    required this.name,
    required this.engineer,
    required this.owner,
    required this.address,
    this.isIncomplete = true,
  });

  Obra.fromDatabase(Map<String, Object?> row) : id = row['id'] as String, name = row['name'] as String, engineer = row['engineer'] as String, owner = row['owner'] as String, address = row['address'] as String, isIncomplete = row['isIncomplete'].toString() as bool;

  void toggleDone() {
    isIncomplete = !isIncomplete;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    try {
      toggleDone();

      final response = await http.patch(
        Uri.parse('${Constants.PRODUCT_BASE_URL}/$id.json'),
        body: jsonEncode({"isIncomplete": isIncomplete}),
      );

      if (response.statusCode >= 400) {
        toggleDone();
      }
    } catch (_) {
      toggleDone();
    }
  }

}
