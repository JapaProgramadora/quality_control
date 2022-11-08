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
  bool isDeleted;
  bool isComplete;
  DateTime lastUpdated;
  bool needFirebase;
  

  Obra({
    required this.id,
    required this.name,
    required this.engineer,
    required this.owner,
    required this.address,
    required this.lastUpdated,
    this.isComplete = true,
    this.isDeleted = false,
    this.needFirebase = false,
  });

  void toggleDone() {
    isComplete = !isComplete;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    try {
      toggleDone();

      final response = await http.patch(
        Uri.parse('${Constants.PRODUCT_BASE_URL}/$id.json'),
        body: jsonEncode({"isComplete": isComplete}),
      );

      if (response.statusCode >= 400) {
        toggleDone();
      }
    } catch (_) {
      toggleDone();
    }
  }

  void toggleDeleted(){
    isDeleted = !isDeleted;
    notifyListeners();
  }

  Future<void> toggleDeletion() async {
    try {
      toggleDeleted();

      final response = await http.patch(
        Uri.parse('${Constants.PRODUCT_BASE_URL}/$id.json'),
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

  factory Obra.fromSQLMap(Map<String, dynamic> map) {
    return Obra(
      id: map['id'] as String,
      name: map['name'] as String,
      engineer: map['engineer'] as String,
      owner: map['owner'] as String,
      address: map['address'] as String,
      lastUpdated: DateTime.parse(map['lastUpdated']),
      isComplete: map['isComplete'] != null ? checkBool(map['isComplete']) : false,
      isDeleted: map['isDeleted'] != null? checkBool(map['isDeleted']) : false,
      needFirebase: map['needFirebase'] != null? checkBool(map['needFirebase']) : false,
    );
  }

  Map<String, dynamic> toMapSQL() {
    return {
      'id': id,
      'name': name,
      'engineer': engineer,
      'owner': owner,
      'address': address,
      'lastUpdated': lastUpdated.toIso8601String(),
      'isComplete': boolToSql(isComplete),
      'needFirebase': boolToSql(needFirebase),
    };
  }

}
