
// ignore_for_file: use_key_in_widget_constructors

import 'package:control/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/location.dart';
import '../models/location_list.dart';

//ImagePicker()
class LocationItem extends StatelessWidget {

  final String matchmakingId;
  
  const LocationItem(this.matchmakingId);

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<Location>(context, listen: false);
    String id = items.id.toString();

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.ITEM_SCREEN, arguments: id);
      },
      child: ListTile(
        leading: Consumer<Location>(          
          builder: (ctx, method, _) => const CircleAvatar(
            backgroundColor: Colors.green, //method.isMethodGood ? Colors.green : Colors.red
          ),
        ),
        title: Text(items.location),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.LOCATION_FORM_SCREEN, arguments: {
                    "id": id,
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
                      title: const Text('Excluir Ambiente?'),
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
                      await Provider.of<LocationList>(context, listen: false).removeLocation(items);
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