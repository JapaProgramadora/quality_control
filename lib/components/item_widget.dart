import 'package:flutter/foundation.dart';

import 'method_grid.dart';
import '../models/item_list.dart';
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
  
  @override
  Widget build(BuildContext context) {
    final item = Provider.of<Items>(context, listen: false);
    if (kDebugMode) {
      print(item);
    }

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.METHOD_SCREEN, arguments: item.id);
      },
      child: ListTile(
        leading: Consumer<Items>(          
          builder: (ctx, method, _) => const CircleAvatar(
            backgroundColor: Colors.green, //method.isMethodGood ? Colors.green : Colors.red
          ),
        ),
        title: Text(item.item),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.ITEM_FORM_SCREEN, arguments: {
                    "id": item.id,
                  });
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
                      await Provider.of<ItemList>(context, listen: false).removeItem(item);
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
