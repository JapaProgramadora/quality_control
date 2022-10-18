

// ignore_for_file: constant_identifier_names, unused_field

import 'package:control/components/app_drawer.dart';
import 'package:control/components/obra_grid.dart';
import 'package:control/models/obra_list.dart';
import 'package:control/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  Andamento,
  All,
}

class HomeScreen extends StatefulWidget {

  const HomeScreen({ Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  bool _showDoneOnly = false;

  Future<void> _refreshObras(BuildContext context) async{
    Provider.of<ObraList>(context, listen: false).loadProducts();
  }


  @override
  void initState() {
    super.initState();
    Provider.of<ObraList>(
      context,
      listen: false,
    ).loadProducts().then((value) {
      setState(() {
       _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Obras'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.OBRA_FORM_SCREEN);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text('Em andamento'),
                value: FilterOptions.Andamento,
              ),
              const PopupMenuItem(
                child: Text('Todas'),
                value: FilterOptions.All,
              ),
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Andamento) {
                  _showDoneOnly = false;
                } else {
                  _showDoneOnly = true;
                }
            });
          }),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshObras(context),
        child: ObraGrid(_showDoneOnly,)
        ),
    );
  }
}