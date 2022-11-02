

// ignore_for_file: unused_local_variable

import 'package:control/models/item_list.dart';
import 'package:control/screens/item_screen.dart';

import '../models/stage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/stage_list.dart';
import '../models/team.dart';
import '../models/team_list.dart';
import '../utils/app_routes.dart';
import '../utils/cache.dart';

class StageItemTeste extends StatefulWidget {
  final String matchmakingId;
  
  const StageItemTeste(this.matchmakingId, {Key? key}) : super(key: key);

  @override
  State<StageItemTeste> createState() => _StageItemTesteState();
}

class _StageItemTesteState extends State<StageItemTeste> {
  int finished =0;
  int pending = 0;
  double percentage = 0.0;
  int total = 0;

  @override
  Widget build(BuildContext context) {
    final stage = Provider.of<Stage>(context, listen: false);
    final items = Provider.of<ItemList>(context).loadMatchingItems(stage.id);

    if(items.isNotEmpty){
      for(var item in items){
        if(item.isGood == true){
          finished +=1;
        }else{
          pending += 1;
        }
      }
      total = finished + pending;
      if(finished == 0){
        percentage = 0.0;
      }else{
        percentage = finished / total;
        if(percentage*100.toInt() == 100){
          stage.changeStageGood(true, stage);
        }
      }
    }

    final provider = Provider.of<TeamList>(context);
    final List<Team> teams = provider.items;

    Cache().setObraId(stage.matchmakingId);

   _openItemModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
          return SizedBox(
            height: 900,
            child: ItemScreen(matchmakingId: stage.id, teams: teams),
          );
      },
    );
  }

    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(255, 231, 231, 238),
      ),
      child: InkWell(
        onTap: ()  {
          _openItemModal(context);
        },  
        child: ListTile(
          leading: CircleAvatar(
            child: Text(
              '${(percentage*100).toStringAsFixed(1)}%', 
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600
              )
            ),
            backgroundColor: const Color.fromARGB(255, 148, 188, 221),
          ),
          title: Text(
            stage.stage,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: SizedBox(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.STAGES_FORM_SCREEN, arguments: stage);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                  onPressed: () {
                    showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Excluir Estágio?'),
                        content: const Text('Tem certeza?'),
                        actions: [
                          TextButton(
                            child: const Text('Não'),
                            onPressed: () => Navigator.of(ctx).pop(false),
                          ),
                          TextButton(
                            child: const Text('Sim'),
                            onPressed: () => Navigator.of(ctx).pop(true),
                          ),
                        ],
                      ),
                    ).then((value) async {
                      if (value ?? false){
                        await Provider.of<StageList>(context, listen: false).removeStage(stage);
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}