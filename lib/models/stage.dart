
import 'package:flutter/material.dart';

class Stage with ChangeNotifier{
  String id;
  String stage;
  String matchmakingId;

  Stage({
    required this.id,
    required this.stage,
    required this.matchmakingId,
  });
}