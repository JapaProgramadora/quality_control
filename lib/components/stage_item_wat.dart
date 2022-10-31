

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


  @override
  Widget build(BuildContext context) {
    // final items = Provider.of<ItemList>(context).items;
    // for(var item in items){
    //   if(item.is == true){
    //     finished +=1;
    //   }else{
    //     pending += 1;
    //   }
    // }
    // int total = finished + pending;
    // double percentage = finished / total;
    final stage = Provider.of<Stage>(context, listen: false);
    String teste = stage.id.toString();
    final provider = Provider.of<TeamList>(context);
    final List<Team> teams = provider.items;

    Cache().setObraId(stage.matchmakingId);

   _openErrorDescriptionForm(BuildContext context) {
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
          _openErrorDescriptionForm(context);
        },  
        child: ListTile(
          leading: const CircleAvatar(
              backgroundColor:  Color.fromARGB(255, 148, 188, 221),
          ),
          title: Text(
            stage.stage,
            style: TextStyle(
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