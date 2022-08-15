
import 'package:control/components/stage_grid.dart';
import 'package:control/components/stage_item_grid.dart';
import 'package:flutter/material.dart';

import '../utils/app_routes.dart';


class StagesItemScreen extends StatefulWidget {
  const StagesItemScreen({ Key? key, }) : super(key: key);

  @override
  State<StagesItemScreen> createState() => _StagesItemScreenState();
  
}

class _StagesItemScreenState extends State<StagesItemScreen> {

          
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Estágios da Obra'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.STAGES_FORM_SCREEN, arguments: id);
            },
            icon: const Icon(Icons.add),
            ),
        ],
      ),
      body: StageItemGrid(matchmakingId: id),
    );
  }
}
