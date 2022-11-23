// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:control/utils/util.dart';

import '../utils/constants.dart';

class Obra with ChangeNotifier, LinkedListEntry<Obra> {
  final String id;
  final String name;
  final String engineer;
  final String owner;
  final String address;
  bool isDeleted;
  bool isUpdated;
  bool isComplete;
  DateTime lastUpdated;
  bool needFirebase;
  
  
  Obra({
    required this.id,
    required this.name,
    required this.engineer,
    required this.owner,
    required this.address,
    this.isDeleted = false,
    this.isUpdated = false,
    this.isComplete = false,
    required this.lastUpdated,
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
      isUpdated: map['isUpdated'] != null ? checkBool(map['isUpdated']) : false,
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
      'isUpdated': boolToSql(isUpdated),
      'isDeleted': boolToSql(isDeleted),
      'needFirebase': boolToSql(needFirebase),
    };
  }
  


  Obra copyWith({
    String? id,
    String? name,
    String? engineer,
    String? owner,
    String? address,
    bool? isDeleted,
    bool? isUpdated,
    bool? isComplete,
    DateTime? lastUpdated,
    bool? needFirebase,
  }) {
    return Obra(
      id: id ?? this.id,
      name: name ?? this.name,
      engineer: engineer ?? this.engineer,
      owner: owner ?? this.owner,
      address: address ?? this.address,
      isDeleted: isDeleted ?? this.isDeleted,
      isUpdated: isUpdated ?? this.isUpdated,
      isComplete: isComplete ?? this.isComplete,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      needFirebase: needFirebase ?? this.needFirebase,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'engineer': engineer,
      'owner': owner,
      'address': address,
      'isDeleted': isDeleted,
      'isUpdated': isUpdated,
      'isComplete': isComplete,
      'lastUpdated': lastUpdated.millisecondsSinceEpoch,
      'needFirebase': needFirebase,
    };
  }

  factory Obra.fromMap(Map<String, dynamic> map) {
    return Obra(
      id: map['id'] as String,
      name: map['name'] as String,
      engineer: map['engineer'] as String,
      owner: map['owner'] as String,
      address: map['address'] as String,
      isDeleted: map['isDeleted'] as bool,
      isUpdated: map['isUpdated'] as bool,
      isComplete: map['isComplete'] as bool,
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(map['lastUpdated'] as int),
      needFirebase: map['needFirebase'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Obra.fromJson(String source) => Obra.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Obra(id: $id, name: $name, engineer: $engineer, owner: $owner, address: $address, isDeleted: $isDeleted, isUpdated: $isUpdated, isComplete: $isComplete, lastUpdated: $lastUpdated, needFirebase: $needFirebase)';
  }

  @override
  bool operator ==(covariant Obra other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.engineer == engineer &&
      other.owner == owner &&
      other.address == address &&
      other.isDeleted == isDeleted &&
      other.isUpdated == isUpdated &&
      other.isComplete == isComplete &&
      other.lastUpdated == lastUpdated &&
      other.needFirebase == needFirebase;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      engineer.hashCode ^
      owner.hashCode ^
      address.hashCode ^
      isDeleted.hashCode ^
      isUpdated.hashCode ^
      isComplete.hashCode ^
      lastUpdated.hashCode ^
      needFirebase.hashCode;
  }
  
}
