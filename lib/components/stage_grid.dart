import 'package:control/models/stage.dart';
import 'package:control/models/stage_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'stage_item.dart';

class StageGrid extends StatelessWidget {
  final String matchmakingId;
  const StageGrid({ Key? key, required this.matchmakingId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StageList>(context);
    final List<Stage> stages = provider.testItems(matchmakingId);
    
    return Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: stages.length,
          itemBuilder: (ctx,i) => ChangeNotifierProvider.value(
            value: stages[i],
            child: StageItem(),
          ),
        ),
    );
  }
}