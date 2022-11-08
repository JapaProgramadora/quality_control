
// ignore_for_file: unused_field

import 'package:control/components/method_grid.dart';
import 'package:control/components/stage_grid.dart';
import 'package:control/models/item_list.dart';
import 'package:control/models/location_list.dart';
import 'package:control/models/method_list.dart';
import 'package:control/models/obra.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/stage_list.dart';
import '../models/team.dart';
import '../models/team_list.dart';
import '../utils/app_routes.dart';

class MethodScreen extends StatefulWidget {
  final String matchmakingId;
  const MethodScreen({ Key? key, required this.matchmakingId }) : super(key: key);

  @override
  State<MethodScreen> createState() => _MethodScreenState();
  
}

class _MethodScreenState extends State<MethodScreen> {
  bool _isLoading = false;
  final bool _isClicked = false;

          
  @override
  Widget build(BuildContext context) {
    List<Team> teams = Provider.of<TeamList>(context, listen: false).items;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor:const  Color.fromARGB(255, 102, 183, 197),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.METHOD_FORM_SCREEN, arguments: {
            "id" : widget.matchmakingId,
            "teams": teams,
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: _isLoading? 
        const Center(child: CircularProgressIndicator(),)
      : MethodGrid(matchmakingId: widget.matchmakingId),
    ); 
  }
}
