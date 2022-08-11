
import 'package:control/components/stage_grid.dart';
import 'package:flutter/material.dart';


class StagesItemScreen extends StatefulWidget {
  const StagesItemScreen({ Key? key, }) : super(key: key);

  @override
  State<StagesItemScreen> createState() => _StagesItemScreenState();
  
}

class _StagesItemScreenState extends State<StagesItemScreen> {

          
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Estágios da Obra'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
            ),
        ],
      ),
      body: Text('hEllo'),
    );
  }
}
