
// ignore_for_file: unused_field

import 'package:control/components/stage_grid.dart';
import 'package:control/models/item_list.dart';
import 'package:control/models/obra.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/stage.dart';
import '../models/stage_list.dart';
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
  Obra? newObra;
  List<String> baseStages = ['stage1', 'stage2', 'stage3'];

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
      ).loadStage().then((value) {
        setState(() {
        _isLoading = false;
        });
      });
      Provider.of<ItemList>(
        context,
        listen: false,
      ).loadItems().then((value) {
        setState(() {
        _isLoading = false;
        });
      });
      Provider.of<TeamList>(context,listen: false,).loadTeams();

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
          }
          Navigator.of(context).pushNamed(AppRoutes.STAGES_FORM_SCREEN, arguments: obra.id);
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
                for(var stage in baseStages){
                  await Provider.of<StageList>(context, listen: false).addBaseStage(stage, newObra!.id);
                }
                await Provider.of<StageList>(context, listen: false).loadStage();
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
      if(value == true){
        Navigator.of(context).pushNamed(AppRoutes.OBRA_STAGES_SCREEN, arguments: newObra);
      }else{
        return;
      }
    });
  }

}
