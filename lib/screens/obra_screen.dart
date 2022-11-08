

// ignore_for_file: constant_identifier_names, unused_field

import 'package:control/components/app_drawer.dart';
import 'package:control/components/obra_grid.dart';
import 'package:control/models/obra_list.dart';
import 'package:control/models/stage_list.dart';
import 'package:control/utils/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


enum FilterOptions {
  Andamento,
  All,
}

class ObraScreen extends StatefulWidget {

  const ObraScreen({ Key? key}) : super(key: key);

  @override
  State<ObraScreen> createState() => _ObraScreenState();
}

class _ObraScreenState extends State<ObraScreen> {
  bool _isLoading = true;
  bool _showDoneOnly = false;

  Future<void> _refreshObras(BuildContext context) async{
    await Provider.of<ObraList>(context, listen: false).loadProducts().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
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
    Provider.of<StageList>(
      context,
      listen: false,
    ).loadStage().then((value) {
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
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30)
          )
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: Container(
            padding: const EdgeInsets.only(bottom: 20, right: 230),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                 Text(
                  'Obras',
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                )
              ],
            )
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:const  Color.fromARGB(255, 102, 183, 197),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.OBRA_FORM_SCREEN);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      drawer: const AppDrawer(),
      body: _isLoading? 
      const Center(child: CircularProgressIndicator(),)
      : RefreshIndicator(
        onRefresh: () => _refreshObras(context),
        child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: ObraGrid(_showDoneOnly,),
        )
        ),
    );
  }
}