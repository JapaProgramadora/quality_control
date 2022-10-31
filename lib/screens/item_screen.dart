// ignore_for_file: unused_field

import 'package:control/models/team_list.dart';

import '../components/item_grid.dart';
import '../models/method.dart';
import '../models/method_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/item_list.dart';
import '../models/team.dart';
import '../utils/app_routes.dart';
import '../utils/app_routes.dart';


class ItemScreen extends StatefulWidget {
  final String matchmakingId;
  final List<Team> teams;
  const ItemScreen({ Key? key, required this.matchmakingId, required this.teams}) : super(key: key);

  @override
  State<ItemScreen> createState() => _ItemScreenState();
  
}

class _ItemScreenState extends State<ItemScreen> {

  bool _isLoading = true;

  @override
    void initState() {
      super.initState();

      if(widget.teams.isEmpty){
        Future(_showDialog);
      }
      Provider.of<MethodList>(context,listen: false,).loadMethod();
  }

          
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Itens',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 102, 183, 197),
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.ITEM_FORM_SCREEN, arguments: {
            'matchmakingId': widget.matchmakingId,
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ItemGrid(matchmakingId: widget.matchmakingId),
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Não existem Equipes!"),
          content: new Text("Para continuar, você precisa adicionar equipes que exercerão os trabalhos!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new ElevatedButton(
              child: new Text("Adicionar equipes"),
              onPressed: () async {
                await Navigator.of(context).pushNamed(AppRoutes.TEAM_FORM);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
