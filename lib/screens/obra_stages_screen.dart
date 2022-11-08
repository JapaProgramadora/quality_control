
// ignore_for_file: unused_field

import 'package:control/components/stage_grid.dart';
import 'package:control/models/base_list.dart';
import 'package:control/models/item_list.dart';
import 'package:control/models/location_list.dart';
import 'package:control/models/obra.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/method_list.dart';
import '../models/stage.dart';
import '../models/stage_list.dart';
import '../models/team.dart';
import '../models/team_list.dart';
import '../utils/app_routes.dart';

class ObraStagesScreen extends StatefulWidget {
  const ObraStagesScreen({ Key? key, }) : super(key: key);

  @override
  State<ObraStagesScreen> createState() => _ObraStagesScreenState();
  
}

class _ObraStagesScreenState extends State<ObraStagesScreen> {
  bool _isLoading = true;
  final bool _isClicked = false;
  List<Team> teams = [];
  Obra? newObra;
  List<Map<String, String>> baseStage = [
    {'stage': 'Serviços Preliminares', 'class': '1'},
    {'stage': 'Compactação de Solo', 'class': '2'},
    {'stage': 'Infraestrutura', 'class': '3'},
    {'stage': 'Superestrutura', 'class': '4'},
    {'stage': 'Fechamento', 'class': '5'},
    {'stage': 'Cobertura', 'class': '6'},
    {'stage': 'Revestimento', 'class': '7'},
    {'stage': 'Pavimentação', 'class': '8'},
    {'stage': 'Instalações Hidrossanitárias', 'class': '9'},
    {'stage': 'Instalações Elétricas', 'class': '10'},
    {'stage': 'Pintura', 'class': '10'},
  ];

  Future<void> _onRefresh(BuildContext context) async{
    setState(() {
      _isLoading = true;
    });
    Provider.of<StageList>(context, listen: false).loadStage().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }


  @override
    void initState() {
      super.initState();
      
      Provider.of<StageList>(
        context,
        listen: false,
      ).loadStage();
      Provider.of<ItemList>(
        context,
        listen: false,
      ).loadItems().then((value) {
        setState(() {
        _isLoading = false;
        });
      });
      Provider.of<TeamList>(context,listen: false,).loadTeams();
      Provider.of<LocationList>(context,listen: false,).loadLocation();
      teams = Provider.of<TeamList>(context,listen: false,).items;
  }
  
          
  @override
  Widget build(BuildContext context) {
    final obra = ModalRoute.of(context)!.settings.arguments as Obra;
    newObra = obra;

  
    List<Stage> stages = Provider.of<StageList>(context).allMatchingStages(obra.id);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 9, 123, 143),
        title: Text(
          'Obra ${obra.name}',
          style: const TextStyle(
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
        onPressed: () async {
          if(stages.isEmpty){
            Future(_showDialog);
          }else{
            Navigator.of(context).pushNamed(AppRoutes.STAGES_FORM_SCREEN, arguments: obra.id);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: _isLoading? 
        const Center(child: CircularProgressIndicator(),)
      : RefreshIndicator(
        onRefresh: () => _onRefresh(context),
        child: StageGrid(matchmakingId: obra.id),
      ),
    );
 
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text("Gostaria de carregar estágios?"),
          content: const Text("Aceitando você carregará estágios base para facilitar seu processo!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            ElevatedButton(
              child: const Text("Adicionar"),
              onPressed: () async {
                if(teams.isEmpty){
                  await TeamList().saveTeam({'team': 'Marcio da Rosa'});
                }
                for(var stage in baseStage){
                  await Provider.of<BaseList>(context, listen: false).addBaseStage(stage, newObra!.id);
                }
                await Provider.of<StageList>(context, listen: false).loadStage();
                await Provider.of<TeamList>(context, listen: false).loadTeams();
                await Provider.of<ItemList>(context, listen: false).loadItems();
                await Provider.of<MethodList>(context, listen: false).loadMethod();
                Navigator.of(context).pop(true);
              },
            ),
            ElevatedButton(
              child: const Text("Cancelar"),
              onPressed: () async {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    ).then((value) {
      if(value == false){
        Navigator.of(context).pushNamed(AppRoutes.STAGES_FORM_SCREEN, arguments: newObra!.id);
      }
    });
  }

}
