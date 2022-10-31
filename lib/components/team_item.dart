

// ignore_for_file: unused_local_variable

import 'package:control/screens/item_screen.dart';

import '../models/stage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/stage_list.dart';
import '../models/team.dart';
import '../models/team_list.dart';
import '../utils/app_routes.dart';
import '../utils/cache.dart';

class TeamItem extends StatefulWidget {
  
  const TeamItem( {Key? key}) : super(key: key);

  @override
  State<TeamItem> createState() => _TeamItemState();
}

class _TeamItemState extends State<TeamItem> {


  @override
  Widget build(BuildContext context) {
    final team = Provider.of<Team>(context, listen: false);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(255, 231, 231, 238),
      ),
      child: ListTile(
        leading: Icon(Icons.engineering, color: Color.fromARGB(255, 81, 157, 219),),
        title: Text(
          team.team,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.TEAM_FORM, arguments: {
                      'team':team,
                    }
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () {
                  showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Excluir Equipe?'),
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
                      await Provider.of<TeamList>(context, listen: false).removeTeam(team);
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