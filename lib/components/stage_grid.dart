import 'package:control/components/stage_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/stage.dart';
import '../models/stage_list.dart';
import 'team_item.dart';

class StageGrid extends StatelessWidget {
  final String matchmakingId;
  const StageGrid({ Key? key, required this.matchmakingId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StageList>(context);
    final List<Stage> stages = provider.allMatchingStages(matchmakingId);
    
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: stages.length,
          itemBuilder: (ctx,i) => ChangeNotifierProvider.value(
            value: stages[i],
            child: Padding(
              padding: const EdgeInsets.only(
                top: 5,
              ),
              child: StageItemTeste(matchmakingId),
            ),
          ),
        ),
    );
  }
}