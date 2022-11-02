

// ignore_for_file: constant_identifier_names, unused_field

import 'package:control/components/gallery_grid.dart';
import 'package:control/components/method_grid.dart';
import 'package:control/models/location_list.dart';
import 'package:control/models/method_list.dart';
import 'package:control/screens/method_screen.dart';
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

class TabScreen extends StatefulWidget {
  const TabScreen({ Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> with TickerProviderStateMixin{
  bool _isLoading = true;
  bool _isVisible = true;

  List<Team> teams = [];

  @override
  void initState() {
    super.initState();


    Provider.of<LocationList>(context,listen: false,).loadLocation();
    Provider.of<EvaluationList>(context,listen: false,).loadEvaluation();
  
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
              tabs: const [
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
                  MethodScreen(matchmakingId: matchmakingId,),
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