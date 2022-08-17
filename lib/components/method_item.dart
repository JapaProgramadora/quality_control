

// ignore_for_file: use_key_in_widget_constructors

import 'package:control/models/method.dart';
import 'package:control/models/method_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/app_routes.dart';

class MethodItem extends StatelessWidget {
  final String matchmakingId;
  
  const MethodItem(this.matchmakingId);

  @override
  Widget build(BuildContext context) {
    final method = Provider.of<Method>(context, listen: false);
    String id = method.id.toString();

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.STAGES_ITEM_SCREEN, arguments: id);
      },
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.purple,
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
                  Navigator.of(context).pushNamed(AppRoutes.STAGES_FORM_SCREEN, arguments: id);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () {
                  showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Excluir Estágio?'),
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