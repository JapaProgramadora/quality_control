
import 'package:control/screens/error_description.dart';
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
          return ErrorMethodForm(method.id);
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
                        onPressed: () {
                          method.changeMethodGood();
                        },
                        child: const Text('Conforme'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                        )
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                            method.changeMethodGood();
                            _openErrorDescriptionForm(context);
                          },
                        child: const Text('Não conforme'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        )
                      ),
                    ],
                  ),
                ],
              )
          ),
          Container(
            margin: const EdgeInsets.all(30) ,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey)
            ),
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            height: 150,
            child: Column(
                children:[
                  const Text(
                    'Equipe',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const Divider(),
                  Text(
                      method.method, //change this to show the team
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
                        onPressed: () {}, 
                        child: const Text('Conforme'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                        )
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {}, 
                        child: const Text('Não conforme'),
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 206, 176, 174),
                        )
                      ),
                    ],
                  ),
                ],
              )
          ),
          const Padding(padding: EdgeInsets.all(30),),
        ],
      )
    );
  }
}