import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';


class StateInheritedWidget extends InheritedWidget{
  final String obraId;
  
  const StateInheritedWidget({
    required Widget child,
    required this.obraId,
  }) : super(child: child);

  
  static String of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<StateInheritedWidget>())!.obraId;
  }

  @override 
  bool updateShouldNotify(StateInheritedWidget oldWidget) => oldWidget.obraId != obraId;
}