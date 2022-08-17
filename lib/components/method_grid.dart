import 'package:control/models/method.dart';
import 'package:control/models/method_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'method_item.dart';
import 'stage_item.dart';

class MethodGrid extends StatelessWidget {
  final String matchmakingId;
  const MethodGrid({ Key? key, required this.matchmakingId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MethodList>(context);
    final List<Method> phaseItem = provider.getAllItems(matchmakingId);
    
    return Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: phaseItem.length,
          itemBuilder: (ctx,i) => ChangeNotifierProvider.value(
            value: phaseItem[i],
            child: MethodItem(matchmakingId),
          ),
        ),
    );
  }
}