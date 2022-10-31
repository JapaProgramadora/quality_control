

// ignore_for_file: constant_identifier_names, unused_field

import 'package:control/components/gallery_grid.dart';
import 'package:control/components/method_grid.dart';
import 'package:control/models/location_list.dart';
import 'package:control/models/method_list.dart';
import 'package:control/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/evaluation_list.dart';
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

class _MethodScreenState extends State<MethodScreen> with TickerProviderStateMixin{
  bool _isLoading = true;
  bool _isVisible = true;

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
    Provider.of<EvaluationList>(context,listen: false,).loadEvaluation();

    teams = Provider.of<TeamList>(context, listen: false).items;
  
  }

  @override
  Widget build(BuildContext context) {
    final matchmakingId = ModalRoute.of(context)?.settings.arguments as String;
    TabController _tabController = TabController(length: 2, vsync: this);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
        ),
        floatingActionButton: Visibility(
          visible: _isVisible,
          child: FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 102, 183, 197),
            child: Icon(Icons.add),
            onPressed: () {
              if(_tabController.index == 0){
                Navigator.of(context).pushNamed(AppRoutes.METHOD_FORM_SCREEN, arguments: {
                  "id": matchmakingId,
                  "teams": teams,
                  }
                );
              }
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 20),
              child: const Text(
                'Verificações', 
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700
                )
              ,),
            ),
            const SizedBox(height: 30,),
            Container(
              child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'Tarefas', icon: Icon(Icons.assignment)),
                Tab(text: 'Galeria', icon: Icon(Icons.photo),),
              ]
              ),
            ),
            Container(
              width: double.maxFinite,
              height: 500,
              child: TabBarView(
                controller: _tabController,
                children: [
                  MethodGrid(matchmakingId: matchmakingId,),
                  GalleryGrid(),
                ],
              ),
            )
            
          ],
        )
      ),
    );
  }
}