import 'dart:convert';

import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'package:http/http.dart' as http;

class Items with ChangeNotifier{
  final String id;
  final String item;
  final String matchmakingId;
  final DateTime beginningDate;
  final DateTime endingDate;
  final String description;
  bool isGood;

  Items({
    required this.beginningDate,
    required this.id,
    required this.item,
    required this.endingDate,
    required this.matchmakingId,
    required this.description,
    this.isGood = false,
  });
  
} 