
// ignore_for_file: unused_local_variable

import 'package:control/validation/connectivity.dart';

import 'error_description.dart';
import 'package:flutter/material.dart';

import '../models/method.dart';

class VerificationDisplayScreen extends StatelessWidget {

  const VerificationDisplayScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final method = ModalRoute.of(context)!.settings.arguments as Method;
    final name = method.method.toString;

    _openErrorDescriptionForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
          return EvaluationForm(method.id);
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