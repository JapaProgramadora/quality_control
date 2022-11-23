// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
import 'package:control/models/obra.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/obra_list.dart';
import 'obra_item.dart';

class ObraGrid extends StatelessWidget {
  
  ObraGrid();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ObraList>(context);
    final List<Obra> loadedObras = provider.items;
    
    return SizedBox(
      height: 450,
      child: ListView.builder(
        itemCount: loadedObras.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: ((context, index) => ChangeNotifierProvider.value(
            value: loadedObras[index],
            child: ObraItem(),
          )
        )
      ),
    );
  }
}