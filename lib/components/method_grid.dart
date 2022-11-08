
import '../models/method.dart';
import '../models/method_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'method_item.dart';

class MethodGrid extends StatefulWidget {
  final String matchmakingId;
  const MethodGrid({ Key? key, required this.matchmakingId}) : super(key: key);

  @override
  State<MethodGrid> createState() => _MethodGridState();
}

class _MethodGridState extends State<MethodGrid> {

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MethodList>(context);
    final List<Method> phaseItem = provider.getAllItems(widget.matchmakingId);
    
    return ListView.builder(
      shrinkWrap: true,
      itemCount: phaseItem.length,
      itemBuilder: (ctx,i) => ChangeNotifierProvider.value(
        value: phaseItem[i],
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: MethodItem(widget.matchmakingId),
        ),
      ),
    );
  }
}