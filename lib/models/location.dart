import 'package:flutter/material.dart';

class Location with ChangeNotifier{
  String id;
  String location;
  String matchmakingId;

  Location({
    required this.id,
    required this.location,
    required this.matchmakingId,
  });
}