import 'package:control/models/stage_item.dart';
import 'package:control/models/stages_item_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/app_routes.dart';


class ItemWidget extends StatefulWidget {

  const ItemWidget({
    Key? key,
  }) : super(key: key);

  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  bool _expanded = false;
  

  @override
  Widget build(BuildContext context) {
    final item = Provider.of<Items>(context, listen: false);

    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(item.item),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(item.date),
            ),
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
              child: ListView(
                children: [
                  const Text(
                      'Método:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      item.method,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const Text(
                      'Tolerância:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      item.tolerance.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const Text(
                      'Descrição:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      item.description,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(
                      height: 70,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Satisfatório:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(60)),
                          const Text('Sim:'),
                          Consumer<Items>(
                            builder: (ctx, item, _) => IconButton(
                              onPressed: () {
                                item.toggleSatisfaction();
                              }, 
                              icon: Icon(item.isGood == true? Icons.check_box : Icons.check_box_outline_blank )
                            ),
                          ),                    
                          const Text('Não:'),
                          Consumer<Items>(
                            builder: (ctx, item, _) => IconButton(
                              onPressed: () {
                                item.toggleSatisfaction();
                              }, 
                              icon: Icon(item.isGood == false? Icons.check_box : Icons.check_box_outline_blank )
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: Theme.of(context).colorScheme.primary,
                          onPressed: () {
                            Navigator.of(context).pushNamed(AppRoutes.ITEM_FORM_SCREEN, arguments: item.id);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Theme.of(context).errorColor,
                          onPressed: () {
                            showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Excluir Item?'),
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
                                await Provider.of<StagesList>(context, listen: false).removeItem(item);
                              }
                            });
                          },
                        ),
                      ],
                    )
                  ] 
                ),
              ),
        ],
      ),
    );
  }
}
