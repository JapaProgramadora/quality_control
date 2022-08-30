

import 'package:control/components/location_item.dart';
import 'package:control/models/stage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/stage_list.dart';
import '../utils/app_routes.dart';
import 'location_grid.dart';

class StageItem extends StatefulWidget {
  final String matchmakingId;
  
  const StageItem(this.matchmakingId);

  @override
  State<StageItem> createState() => _StageItemState();
}

class _StageItemState extends State<StageItem> {

  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final stage = Provider.of<Stage>(context, listen: false);
    String teste = stage.id.toString();

    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(stage.stage),
            trailing: IconButton(
              icon: const Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              height: (7 * 25) + 10,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget> [
                      LocationGrid(matchmakingId: stage.id),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                try{
                                  Navigator.of(context).pushNamed(AppRoutes.LOCATION_FORM_SCREEN, arguments: teste);
                                }catch(error){
                                  print(error);
                                }
                              }, 
                              icon: const Icon(Icons.add),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: Theme.of(context).errorColor,
                              onPressed: () {
                                showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Excluir todo o Estágio?'),
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
                      )
                    ]
                  ),
              ),
              ),
        ],
      ),
    );
    // return InkWell(
    //   onTap: () {
    //     try{
    //       Navigator.of(context).pushNamed(AppRoutes.ITEM_SCREEN, arguments: teste);
    //     }catch(error){
    //       print('the error was somewhere here');
    //       print(error);
    //     }
    //   },
    //   child: ListTile(
    //     leading: CircleAvatar(
    //       backgroundColor: Colors.amber.shade900,
    //     ),
    //     title: Text(stage.stage),
    //     trailing: SizedBox(
    //       width: 100,
    //       child: Row(
    //         children: [
    //           IconButton(
    //             icon: const Icon(Icons.edit),
    //             color: Colors.amber.shade900,
    //             onPressed: () {
    //               Navigator.of(context).pushNamed(AppRoutes.STAGES_FORM_SCREEN, arguments: teste);
    //             },
    //           ),
    //           IconButton(
    //             icon: const Icon(Icons.delete),
    //             color: Theme.of(context).errorColor,
    //             onPressed: () {
    //               showDialog<bool>(
    //                 context: context,
    //                 builder: (ctx) => AlertDialog(
    //                   title: const Text('Excluir Método?'),
    //                   content: const Text('Tem certeza?'),
    //                   actions: [
    //                     TextButton(
    //                       child: const Text('Não'),
    //                       onPressed: () => Navigator.of(ctx).pop(false),
    //                     ),
    //                     TextButton(
    //                       child: const Text('Sim'),
    //                       onPressed: () => Navigator.of(ctx).pop(true),
    //                     ),
    //                   ],
    //                 ),
    //               ).then((value) async {
    //                 if (value ?? false){
    //                   await Provider.of<StageList>(context, listen: false).removeStage(stage);
    //                 }
    //               });
    //             },
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}