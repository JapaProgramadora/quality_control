
// ignore_for_file: unused_field

import 'package:control/components/stage_grid.dart';
import 'package:control/models/item_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/stage_list.dart';
import '../models/team_list.dart';
import '../utils/app_routes.dart';

class ObraStagesScreen extends StatefulWidget {
  const ObraStagesScreen({ Key? key, }) : super(key: key);

  @override
  State<ObraStagesScreen> createState() => _ObraStagesScreenState();
  
}

class _ObraStagesScreenState extends State<ObraStagesScreen> {
  bool _isLoading = true;
  final bool _isClicked = false;

  Future<void> _onRefresh(BuildContext context) async{
    Provider.of<StageList>(context, listen: false).loadStage();
  }


  @override
    void initState() {
      super.initState();
      Provider.of<StageList>(
        context,
        listen: false,
      ).loadStage().then((value) {
        setState(() {
        _isLoading = false;
        });
      });
      Provider.of<ItemList>(
        context,
        listen: false,
      ).loadItems().then((value) {
        setState(() {
        _isLoading = false;
        });
      });
      Provider.of<TeamList>(context,listen: false,).loadTeams();
  }

  // bool _copyStage(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (_) {
  //         CopyStageForm();
  //         return true;
  //     },
  //   );
  // }
  
          
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Estágios'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text(
                    'Gostaria de carregar estágios de base?',
                    textAlign: TextAlign.justify,
                  ),
                  content: const Text(
                    'Caso existam estágios semelhantes em outra obra, carregue-os para economizar tempo!',
                    textAlign: TextAlign.justify,
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Sim')),
                    TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Não'))
                  ],
                ),
              ).then((value) async {
                if (value ?? true){
                  Navigator.of(context).pushNamed(AppRoutes.ALTERNATIVE_STAGE_FORM, arguments: id);
                }else{
                  Navigator.of(context).pushNamed(AppRoutes.STAGES_FORM_SCREEN, arguments: id);
                }
              });
            },
            icon: const Icon(Icons.add),
          ),
          
          PopupMenuButton(
            child: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: const Text('Adicionar Ambiente'),
                value: 0
              ),
            ],
            onSelected: (result){
              if(result == 0){
                Navigator.of(context).pushNamed(
                  AppRoutes.LOCATION_FORM_SCREEN,
                  arguments: {
                    "matchmakingId": id.toString()
                  }
                );
              }
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(context),
        child: StageGrid(matchmakingId: id),
      ),
    ); 
  }
}
