

// ignore_for_file: use_key_in_widget_constructors

import 'package:control/models/method.dart';
import 'package:control/models/method_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/location.dart';
import '../models/location_list.dart';
import '../utils/app_routes.dart';
import '../utils/cache.dart';

class MethodItem extends StatelessWidget {
  final String matchmakingId;
  
  const MethodItem(this.matchmakingId);

  @override
  Widget build(BuildContext context) {
    final method = Provider.of<Method>(context, listen: false);
    String id = method.id.toString();

    List<Location> loadedLocations = Provider.of<LocationList>(context, listen: false).items;

    Future<List<Location>> getLoadedLocations(List<Location> loaded) async{
      List<Location> toRemove = [];
      List<Location> matchingItems = [];
      List<Location> notMatchingItems = [];
      String obraId = await Cache().getObraId();
      for(var location in loaded){
      if(location.matchmakingId != obraId){
        toRemove.add(location);
      }
    }
    loaded.removeWhere((element) => toRemove.contains(element)); 
    
    return loaded;
  }
 
    return InkWell(
      onTap: () async {
        loadedLocations = await getLoadedLocations(loadedLocations);
        Navigator.of(context).pushNamed(AppRoutes.VERIFICATION_DISPLAY_SCREEN, arguments: {
            "method": method,
            "locations": loadedLocations,
          }  
        );
      },
      child: ListTile(
        leading: Consumer<Method>(
          builder: (ctx, method, _) => CircleAvatar(
            backgroundColor: method.isMethodGood ? Colors.green : Colors.red
          ),
        ),
        title: Text(method.method),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.METHOD_FORM_SCREEN, arguments: id);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () {
                  showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Excluir Método de Verificação?'),
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
                      await Provider.of<MethodList>(context, listen: false).removeMethod(method);
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