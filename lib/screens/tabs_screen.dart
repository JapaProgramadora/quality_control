

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
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    final matchmakingId = arguments['matchmakingId'];
    final internetConnection = arguments['hasInternet'];
    TabController _tabController = TabController(length: 2, vsync: this);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color.fromARGB(255, 9, 123, 143),
        ),
        body: Column(
          children: [
            Material(
              color: const Color.fromARGB(255, 9, 123, 143),
              child: Column(
                children: [
                    const Text(
                      'Verificações',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  const SizedBox(height: 10,),
                  TabBar(
                  indicatorWeight: 5,
                  indicatorColor: const Color.fromARGB(255, 118, 204, 219),
                  controller: _tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: Color.fromARGB(255, 194, 191, 191),
                  tabs: const [
                    Tab(text: 'Tarefas', icon: Icon(Icons.assignment)),
                    Tab(text: 'Galeria', icon: Icon(Icons.photo)),
                  ]
                  ),
                ],
              ),
            ),
            Container(
              width: double.maxFinite,
              height: 500,
              child: TabBarView(
                controller: _tabController,
                children: [
                  MethodScreen(matchmakingId: matchmakingId,),
                  GalleryGrid(hasInternet: internetConnection),
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}