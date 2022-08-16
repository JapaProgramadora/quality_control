import 'package:control/components/stage_item_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/stages_item_list.dart';
import '../utils/app_routes.dart';


class StagesItemScreen extends StatefulWidget {
  const StagesItemScreen({ Key? key, }) : super(key: key);

  @override
  State<StagesItemScreen> createState() => _StagesItemScreenState();
  
}

class _StagesItemScreenState extends State<StagesItemScreen> {

  bool _isLoading = true;

  @override
    void initState() {
      super.initState();
      Provider.of<StagesList>(
        context,
        listen: false,
      ).loadItems().then((value) {
        setState(() {
        _isLoading = false;
        });
      });
  }

          
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Controle de Qualidade'),
        actions: [
          IconButton(
            onPressed: () {
              //para add vc passar
              Navigator.of(context).pushNamed(AppRoutes.ITEM_FORM_SCREEN, arguments: {
                'matchmakingId' : id
              });
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StageItemGrid(matchmakingId: id),
    );
  }
}
