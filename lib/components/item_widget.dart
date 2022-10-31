import 'package:control/models/method_list.dart';
import '../models/item_list.dart';
import 'package:flutter/material.dart';
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
  int finished = 0;
  int pending = 0;
  
  @override
  Widget build(BuildContext context) {
    double percentage = 0;
    final item = Provider.of<Items>(context, listen: false);
    final methods = Provider.of<MethodList>(context).items;

    if(methods.isNotEmpty){
      for(var method in methods){
        if(method.isMethodGood == true){
          finished +=1;
        }else{
          pending += 1;
        }
      }
      int total = finished + pending;
      percentage = finished / total;
    }else{
      percentage = 0;
    }


    
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.METHOD_SCREEN, arguments: item.id);
      },
      child: ListTile(
        leading: Text(
          '${(percentage*100).toStringAsFixed(1)}%',
          style: const TextStyle(
            color: Color.fromARGB(255, 4, 34, 59),
            fontSize: 20,
          )
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
