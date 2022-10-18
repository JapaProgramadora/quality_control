
// ignore_for_file: unused_local_variable

import 'package:control/models/location.dart';

import 'error_description.dart';
import 'package:flutter/material.dart';

import '../models/method.dart';

class VerificationDisplayScreen extends StatefulWidget {

  const VerificationDisplayScreen({ Key? key }) : super(key: key);

  @override
  State<VerificationDisplayScreen> createState() => _VerificationDisplayScreenState();
}

class _VerificationDisplayScreenState extends State<VerificationDisplayScreen> {
  String obraId = '';
  String? methodValue;
  String? placeValue;
  int index = 0;

  @override
  Widget build(BuildContext context)  {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    final method = arguments['method'] as Method;
    List<String> allMethods = method.method;
    List<String> allTolerances = method.tolerance;
    List<Location> finalList = arguments['locations'] as List<Location>;
    final dropValue = ValueNotifier('');
    final dropValue1 = ValueNotifier('');
    var dropValue2 = ValueNotifier('');
    String locationId = ''; 
    String methodName = ''; 
    String toleranceName = ''; 


    _openErrorDescriptionForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
          return EvaluationForm(method.id, locationId, methodName, toleranceName);
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
            margin: const EdgeInsets.all(10) ,
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
                  Container(
                    width: 200,
                    child: SingleChildScrollView(
                      child: DropdownButton<String>(
                        hint: Text('Método'),
                        isExpanded: true,
                        isDense: true,
                        value: methodValue,
                        onChanged: (escolha) {
                          setState(() {
                            methodValue = escolha;
                            methodName = escolha.toString();
                            for(int i = 0; i < allMethods.length; i++){
                                if(method.method[i] == escolha){
                                  index = i;
                                }
                            }
                          });
                        },
                        items: allMethods.map((method) => DropdownMenuItem(
                          value: method,
                          child: Text(method)
                          ),
                        ).toList(), 
                    //(escolha) => methodName = escolha.toString(),
                        )
                    ),
                  ),
                  const Divider(),
                  Container(
                   width: 200,
                    child: Text(
                      allTolerances[index],
                    )
                  ),
                  const Divider(),
                  DropdownButton<String>(
                    hint: const Text('Ambiente'),
                    value: placeValue,
                    onChanged: (escolha) {
                      setState(() {
                        placeValue = escolha;
                        locationId = escolha.toString();
                      });
                    },
                    items: finalList.map((locale) => DropdownMenuItem(
                        value: locale.id,
                        child: Text(locale.location))
                    ).toList(), 
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          method.changeMethodGood(true, method);
                          _openErrorDescriptionForm(context);
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