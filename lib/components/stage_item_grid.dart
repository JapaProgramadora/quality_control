import 'package:control/components/item_widget.dart';
import 'package:control/models/stage_item.dart';
import 'package:control/models/stages_item_list.dart';
import 'package:control/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StageItemGrid extends StatelessWidget {
  final String matchmakingId;
  const StageItemGrid({ Key? key, required this.matchmakingId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StagesList>(context);
    final List<Items> item = provider.testItems(matchmakingId);

    _editItem(id) async {
      await Navigator.of(context).pushNamed(AppRoutes.ITEM_FORM_SCREEN, arguments: {
        'id' : id,
        'matchmakingId' : matchmakingId,
      });
    }
    
    return Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: item.length,
          itemBuilder: (ctx,i) => ChangeNotifierProvider.value(
            value: item[i],
            child: Column(
              children: [                
                const ItemWidget(),
                IconButton(onPressed: () async => _editItem(item[i].id), icon: const Icon(Icons.edit))
              ],
            ),
          ),
        ),
    );
  }
}