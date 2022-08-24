
import 'package:flutter/material.dart';


class Items with ChangeNotifier{
  final String id;
  final String item;
  final String matchmakingId;
  final String description;
  final DateTime beginningDate;
  final DateTime endingDate;

  Items({
    required this.beginningDate,
    required this.endingDate,
    required this.id,
    required this.item,
    required this.matchmakingId,
    this.description = '',
  });
  
} 