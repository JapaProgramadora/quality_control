// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:control/models/evaluation.dart';
import 'package:control/models/evaluation_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'gallery_item.dart';

class GalleryGrid extends StatelessWidget {
  final String hasInternet;
  final String matchmakingId;
  const GalleryGrid({ Key? key, required this.hasInternet, required this.matchmakingId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EvaluationList>(context);
    final List<Evaluation> loadedEva = provider.allMatchingEvaluations(matchmakingId);
    
    return Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: loadedEva.length,
          itemBuilder: (ctx,i) => ChangeNotifierProvider.value(
            value: loadedEva[i],
            child: GalleryItem(hasInternet: hasInternet,),
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