import 'package:control/components/method_grid.dart';
import 'package:control/models/item_list.dart';
import 'package:control/models/method.dart';
import 'package:control/models/method_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/item.dart';
import '../utils/app_routes.dart';


class ItemWidget extends StatefulWidget {
  final String matchmakingId;

  const ItemWidget({
    Key? key,
    required this.matchmakingId,
  }) : super(key: key);

  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  bool _expanded = false;

  
  @override
  Widget build(BuildContext context) {
    final item = Provider.of<Items>(context, listen: false);
    print(item);

    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(item.item),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(item.beginningDate),
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget> [
                      MethodGrid(matchmakingId: item.id),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                                IconButton(onPressed: () {
                                Navigator.of(context).pushNamed(AppRoutes.METHOD_FORM_SCREEN, arguments: item.id);
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
                                    title: const Text('Excluir todo o Item?'),
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
                                    await Provider.of<ItemList>(context, listen: false).removeItem(item);
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
  }
}
