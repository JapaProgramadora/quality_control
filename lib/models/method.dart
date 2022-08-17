
import 'package:flutter/material.dart';

class Method with ChangeNotifier{
  String id;
  String method;
  String tolerance;
  String matchmakingId;

  Method({
    required this.id,
    required this.tolerance,
    required this.method,
    required this.matchmakingId,
  });
}