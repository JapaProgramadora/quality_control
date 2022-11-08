
// ignore_for_file: unused_field

import 'package:control/components/stage_grid.dart';
import 'package:control/components/team_grid.dart';
import 'package:control/models/item_list.dart';
import 'package:control/models/obra.dart';
import 'package:control/screens/team_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/stage_list.dart';
import '../models/team_list.dart';
import '../utils/app_routes.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({ Key? key, }) : super(key: key);

  @override
  State<TeamScreen> createState() => _TeamScreenState();
  
}

class _TeamScreenState extends State<TeamScreen> {
  bool _isLoading = true;
  final bool _isClicked = false;

  Future<void> _onRefresh(BuildContext context) async{
    Provider.of<TeamList>(context, listen: false).loadTeams();
  }


  @override
    void initState() {
      super.initState();
      Provider.of<TeamList>(
        context,
        listen: false,
      ).loadTeams().then((value) {
        setState(() {
        _isLoading = false;
        });
      });
      
  }
  
          
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 9, 123, 143),
        title: const Text(
          'Equipes',
          style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 102, 183, 197),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.TEAM_FORM);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(context),
        child: const TeamGrid(),
      ),
    ); 
  }
}
