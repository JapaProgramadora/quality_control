
// ignore_for_file: use_key_in_widget_constructors

import 'package:control/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/location.dart';
import '../models/location_list.dart';

//ImagePicker()
class LocationItem extends StatelessWidget {

  const LocationItem();

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<Location>(context, listen: false);
    String id = items.id.toString();

    return InkWell(
      onTap: () {},
      child: ListTile(
        leading: const Icon(Icons.house_rounded, color: Color.fromARGB(255, 33, 150, 170),),
        title: Text(items.location),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                color: Color.fromARGB(255, 33, 150, 170),
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