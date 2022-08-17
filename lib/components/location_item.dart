
// ignore_for_file: use_key_in_widget_constructors

import 'package:control/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/location.dart';
import '../models/location_list.dart';

//ImagePicker()
class LocationItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<Location>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          child: Stack(
            children: [ 
              Container(
                child: null,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient( 
                    colors: [
                      Colors.blue.shade200.withOpacity(0.5),
                      Colors.blue.shade400,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // Container(
              //   color: Colors.green,
              //   child: Row(
              //     children: const [
              //       Checkbox(value: true, onChanged: null),
              //       Text('Completo'),
              //       SizedBox(),
              //     ],
              //   ),
              // )
              // Positioned(
              //   top: 5,
              //   child: Consumer<Location>(
              //     builder: (ctx, items, _) => IconButton(
              //       onPressed: () {
              //         items.toggleFavorite();
              //       },
              //       icon: Icon(
              //         items.isIncomplete? Icons.check_box_outline_blank : Icons.check_box,
              //       ),
              //       color: Colors.grey[100],
              //     ),
              //   ),
              // ),
            ]
          ),
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.OBRA_STAGES_SCREEN, arguments: items);
          },
        ),
        footer: GridTileBar(
          leading: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.LOCATION_FORM_SCREEN,
                arguments: items, 
              );
            },
          ),
          title: Text(
            items.location, 
            textAlign: TextAlign.center, 
            style: const TextStyle(
              fontSize: 15
            ),
          ),
          backgroundColor: Colors.black54,
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Excluir Obra?'),
                  content: const Text('Tem certeza que deseja excluir a obra?'),
                  actions: [
                    TextButton(
                      child: const Text('Não'),
                      onPressed: () => Navigator.of(ctx).pop(false),
                    ),
                    TextButton(
                      child: const Text('Sim'),
                      onPressed: () => Navigator.of(ctx).pop(true),
                    )
                  ],
                ),
              ).then((value) async {
                if(value ?? false){
                  await Provider.of<LocationList>(
                      context,
                      listen: false,
                  ).removeLocation(items);
                }
              });
            },
          ),
        ),
      ),
    );
  }
}