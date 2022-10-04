import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';


class idGetter {
  String obraId = '';

  void changeObraId(String newId) {
    obraId = newId; 
  }  

  String getValue(){
    return obraId;
  }
}

class ObraIdHelper extends InheritedWidget{
  final idGetter state = idGetter();

  ObraIdHelper({
    required Widget child,
  }) : super(child: child);

  
  static ObraIdHelper? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ObraIdHelper>();
  }

  @override 
  bool updateShouldNotify(ObraIdHelper oldWidget) {
    return true;
  }
}