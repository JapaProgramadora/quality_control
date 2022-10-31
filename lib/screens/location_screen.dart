import 'package:control/components/location_grid.dart';
import 'package:control/models/location_list.dart';
import 'package:control/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/obra.dart';
import '../models/obra_list.dart';


class LocationScreen extends StatefulWidget {

  const LocationScreen({ Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool _isLoading = true;
  String? obraValue = '';
  String matchmakingId = '';

  @override
  void initState() {
    super.initState();
    Provider.of<LocationList>(
      context,
      listen: false,
    ).loadLocation().then((value) {
      setState(() {
       _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Obra> loadedObras = Provider.of<ObraList>(context).items;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple.shade900,
        title: const Text('Local'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.LOCATION_FORM_SCREEN); //change this
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Container(
        child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20, left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Selecione a Obra:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Divider(),
                    Container(
                      height: 70,
                      width: 300,
                      child: DropdownButtonFormField<String?>(
                          hint: const Text('Obra'),
                          isExpanded: true,
                          dropdownColor: Color.fromARGB(255, 235, 223, 223),
                          isDense: true,
                          elevation: 5,
                          value: (obraValue == '')? null : obraValue,
                          onChanged: (escolha) {
                            setState(() {
                              matchmakingId = escolha.toString();
                              obraValue = escolha.toString();
                            });
                          },
                          iconEnabledColor: Colors.deepPurple.shade50,
                          icon: const Icon(Icons.arrow_drop_down_circle, color: Colors.deepPurple,),
                          decoration: const InputDecoration(
                            labelText: 'Obra',
                            prefixIcon: Icon(Icons.house, color: Colors.deepPurple,),
                            prefixIconColor: Color.fromARGB(255, 172, 153, 214),
                          ),
                          items: loadedObras.map((obra) => DropdownMenuItem(
                            value: obra.id,
                            child: Text(obra.name)
                            ),
                          ).toList(), 
                      ),
                    )
                  ]
                ),
              ),
            ],
          ),
          SizedBox(
            height: 450,
            child: LocationGrid(matchmakingId: matchmakingId)
          ),
        ],
      )),
    );
  }
}