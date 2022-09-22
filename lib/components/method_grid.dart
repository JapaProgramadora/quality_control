import '../models/method.dart';
import '../models/method_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'method_item.dart';

class MethodGrid extends StatelessWidget {
  final String matchmakingId;
  const MethodGrid({ Key? key, required this.matchmakingId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MethodList>(context);
    final List<Method> phaseItem = provider.getAllItems(matchmakingId);
    
    return ListView.builder(
      shrinkWrap: true,
      itemCount: phaseItem.length,
      itemBuilder: (ctx,i) => ChangeNotifierProvider.value(
        value: phaseItem[i],
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300 , width: 1),
            borderRadius: BorderRadius.circular(6)
          ),
          child: MethodItem(matchmakingId)
        ),
      ),
    );
  }
}