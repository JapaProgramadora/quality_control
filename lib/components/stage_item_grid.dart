import 'package:control/components/item_widget.dart';
import 'package:control/models/stage.dart';
import 'package:control/models/stage_item.dart';
import 'package:control/models/stage_list.dart';
import 'package:control/models/stages_item_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'stage_item.dart';

class StageItemGrid extends StatelessWidget {
  final String matchmakingId;
  const StageItemGrid({ Key? key, required this.matchmakingId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StagesList>(context);
    final List<Items> item = provider.testItems(matchmakingId);
    
    return Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: item.length,
          itemBuilder: (ctx,i) => ChangeNotifierProvider.value(
            value: item[i],
            child: ItemWidget(),
          ),
        ),
    );
  }
}