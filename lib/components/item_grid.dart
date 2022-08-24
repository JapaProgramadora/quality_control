import 'package:control/components/item_widget.dart';
import 'package:control/models/item_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/item.dart';

class ItemGrid extends StatelessWidget {
  final String matchmakingId;
  const ItemGrid({ Key? key, required this.matchmakingId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerItem = Provider.of<ItemList>(context);
    final List<Items> item = providerItem.loadMatchingItems(matchmakingId);
    return Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: item.length,
          itemBuilder: (ctx,i) => ChangeNotifierProvider.value(
            value: item[i],
            child: ItemWidget(matchmakingId: matchmakingId),
          ),
        ),
    );
  }
}