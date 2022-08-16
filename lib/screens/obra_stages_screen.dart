
// ignore_for_file: unused_field

import 'package:control/components/stage_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/stage_list.dart';
import '../utils/app_routes.dart';


class ObraStagesScreen extends StatefulWidget {
  const ObraStagesScreen({ Key? key, }) : super(key: key);

  @override
  State<ObraStagesScreen> createState() => _ObraStagesScreenState();
  
}

class _ObraStagesScreenState extends State<ObraStagesScreen> {
  bool _isLoading = true;

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
  }
  
          
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Estágios da Obra'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.STAGES_FORM_SCREEN, arguments: id);
            },
            icon: const Icon(Icons.add),
            ),
        ],
      ),
      body: StageGrid(matchmakingId: id),
    );
  }
}
