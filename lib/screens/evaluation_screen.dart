
// ignore_for_file: unused_local_variable

import 'package:control/models/location.dart';
import 'package:control/models/location_list.dart';
import 'package:provider/provider.dart';

import '../utils/obraId_helper.dart';
import 'error_description.dart';
import 'package:flutter/material.dart';

import '../models/method.dart';

class VerificationDisplayScreen extends StatelessWidget {

  const VerificationDisplayScreen({ Key? key }) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    final method = ModalRoute.of(context)!.settings.arguments as Method;
    final name = method.method.toString;
    List<Location> toRemove = [];
    List<Location> loadedLocations = Provider.of<LocationList>(context, listen: false).items;
    final dropValue = ValueNotifier('');
    String arg = '';

    //ObraIdHelper.of(context)!.state.getValue();

    // for(var location in loadedLocations){
    //   if(location.matchmakingId != obraId){
    //     toRemove.add(location);
    //   }
    // }

    loadedLocations.removeWhere((element) => toRemove.contains(element));

    _openErrorDescriptionForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
          return EvaluationForm(method.id, arg);
      },
    );
  }

  return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Avaliação'),
      ),
      body: Column(
        children: [ 
          Container(
            margin: const EdgeInsets.all(30) ,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey)
            ),
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Column(
                children:[
                  const Text(
                    'Método de Verificação',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const Divider(),
                  Text(
                      method.method,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                      method.tolerance,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                    ),
                  ),
                  ValueListenableBuilder(
                      valueListenable: dropValue, 
                      builder: (BuildContext ctx, String value, _){
                        return DropdownButton<String>(
                          hint: const Text('Ambiente'),
                          value: (value.isEmpty)? null : value,
                          onChanged: (escolha) => arg = escolha.toString(),
                          items: loadedLocations.map((locale) => DropdownMenuItem(
                            value: locale.id,
                            child: Text(locale.location))
                        ).toList(), 
                      );
                    }
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          method.changeMethodGood(true, method);
                        },
                        child: const Text('Conforme'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        )
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                            method.changeMethodGood(false, method);
                            _openErrorDescriptionForm(context);
                          },
                        child: const Text('Não conforme'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        )
                      ),
                    ],
                  ),
                ],
              )
          ),
        ],
      )
    );
  }
}