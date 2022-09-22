// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:control/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

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

  factory Obra.fromSQLMap(Map<String, dynamic> map) {
    return Obra(
      id: map['id'] as String,
      name: map['name'] as String,
      engineer: map['engineer'] as String,
      owner: map['owner'] as String,
      address: map['address'] as String,
      isIncomplete: map['isIncomplete'] != null ? checkBool(map['isIncomplete']) : true,
    );
  }

  Map<String, dynamic> toMapSQL() {
    return {
      'id': id,
      'name': name,
      'engineer': engineer,
      'owner': owner,
      'address': address,
      'isIncomplete': boolToSql(isIncomplete),
    };
  }
}
