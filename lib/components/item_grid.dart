import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/item.dart';
import '../models/item_list.dart';
import 'item_widget.dart';

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
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300 , width: 1),
                borderRadius: BorderRadius.circular(6)
              ),
              child: ItemWidget(matchmakingId: matchmakingId),
            ),
          ),
        ),
    );
  }
}