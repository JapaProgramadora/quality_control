// ignore_for_file: avoid_print, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:control/models/stage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/stage_list.dart';
import '../utils/app_routes.dart';

class StageItem extends StatelessWidget {
  final String matchmakingId;
  
  StageItem(this.matchmakingId);

  @override
  Widget build(BuildContext context) {
    final stage = Provider.of<Stage>(context, listen: false);
    String teste = stage.id.toString();
    print('here we are in stage item');
    print(teste);

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.STAGES_ITEM_SCREEN, arguments: teste);
      },
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.purple,
        ),
        title: Text(stage.stage),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.STAGES_FORM_SCREEN, arguments: teste);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () {
                  showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Excluir Produto?'),
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
    );
  }
}