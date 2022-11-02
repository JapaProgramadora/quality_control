import 'package:control/components/stage_item.dart';
import 'package:control/models/team_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/stage.dart';
import '../models/stage_list.dart';
import '../models/team.dart';
import 'team_item.dart';

class TeamGrid extends StatelessWidget {
  const TeamGrid({ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TeamList>(context);
    final List<Team> teams = provider.items;
    
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: teams.length,
          itemBuilder: (ctx,i) => ChangeNotifierProvider.value(
            value: teams[i],
            child: Padding(
              padding: const EdgeInsets.only(
                top: 5,
              ),
              child: TeamItem(),
            ),
          ),
        ),
    );
  }
}