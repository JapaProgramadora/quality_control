

// ignore_for_file: constant_identifier_names, unused_field

import 'package:control/components/method_grid.dart';
import 'package:control/models/location_list.dart';
import 'package:control/models/method_list.dart';
import 'package:control/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/team.dart';
import '../models/team_list.dart';

enum FilterOptions {
  Andamento,
  All,
}

class MethodScreen extends StatefulWidget {
  const MethodScreen({ Key? key}) : super(key: key);

  @override
  State<MethodScreen> createState() => _MethodScreenState();
}

class _MethodScreenState extends State<MethodScreen> {
  bool _isLoading = true;

  List<Team> teams = [];

  @override
  void initState() {
    super.initState();
    Provider.of<MethodList>(context,listen: false,).loadMethod().then((value) {
      setState(() {
       _isLoading = false;
      });
    });

    Provider.of<LocationList>(context,listen: false,).loadLocation();

    teams = Provider.of<TeamList>(context, listen: false).items;
  
  }

  @override
  Widget build(BuildContext context) {
    final matchmakingId = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Métodos de Verificação'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.METHOD_FORM_SCREEN, arguments: {
                  "id": matchmakingId,
                  "teams": teams,
               }
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: MethodGrid(matchmakingId: matchmakingId)
    );
  }
}