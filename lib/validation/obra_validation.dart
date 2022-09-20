
import 'package:control/utils/db.dart';
import 'package:flutter/material.dart';
import '../models/obra.dart';

  Future<void> addBetweenDatabases(List<Obra> itens) async {
    //print(itens);
    
    await DB.database();
    //carregar todas as obras do firebase
    //carregar todas as obras do sql
    //se tiver alguma obra que nao esteja em um deles, adicionar essa obra no respectivo banco
  }