
// ignore_for_file: unused_local_variable

import 'package:control/models/location.dart';
import 'package:control/models/location_list.dart';
import 'package:control/utils/cache.dart';
import 'package:provider/provider.dart';

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


  @override
  Widget build(BuildContext context)  {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    final method = arguments['method'] as Method;
    List<String> allMethods = method.method;
    List<String> allTolerances = method.tolerance;
    List<Location> finalList = arguments['locations'] as List<Location>;
    final name = method.method.toString();
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
                      child: ValueListenableBuilder(
                          valueListenable: dropValue1, 
                          builder: (BuildContext ctx, String value, _){
                            return DropdownButton<String>(
                              hint: const Text('Método'),
                              isExpanded: true,
                              value: (value.isEmpty)? null : value,
                              onChanged: (escolha) => methodName = escolha.toString(),
                              items: allMethods.toSet().toList().map((method) => DropdownMenuItem(
                                value: method,
                                child: Text(method))
                            ).toList(), 
                          );
                        }
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    child: ValueListenableBuilder(
                        valueListenable: dropValue2, 
                        builder: (BuildContext ctx, String value, _){
                          return DropdownButton<String>(
                            hint:  const Text('Tolerância'),
                            value: (value.isEmpty)? null : value,
                            isExpanded: true,
                            onChanged: (escolha) => toleranceName = escolha.toString(),
                            items: allTolerances.toSet().toList().map((tolerance) => DropdownMenuItem(
                              value: tolerance,
                              child: Text(tolerance))
                          ).toList(), 
                        );
                      }
                    ),
                  ),
              
                  ValueListenableBuilder(
                      valueListenable: dropValue, 
                      builder: (BuildContext ctx, String value, _){
                        return DropdownButton<String>(
                          hint: const Text('Ambiente'),
                          value: (value.isEmpty)? null : value,
                          onChanged: (escolha) => locationId = escolha.toString(),
                          items: finalList.toSet().toList().map((locale) => DropdownMenuItem(
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