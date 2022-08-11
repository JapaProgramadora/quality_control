import 'package:control/models/obra.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/obra_list.dart';
import 'obra_item.dart';

class ObraGrid extends StatelessWidget {
  final bool showDoneOnly;
  
  ObraGrid(this.showDoneOnly);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ObraList>(context);
    final List<Obra> loadedObras = showDoneOnly? provider.items : provider.andamentoItems;
    
    return Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: loadedObras.length,
          itemBuilder: (ctx,i) => ChangeNotifierProvider.value(
            value: loadedObras[i],
            child: ObraItem(),
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10, //espaçamento
            mainAxisSpacing: 10, //espaçamento
            crossAxisCount: 2, //exibe 2 produtos por linha
          ),
        ),
    );
  }
}