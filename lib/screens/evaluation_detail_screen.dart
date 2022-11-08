import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rolling_switch/rolling_switch.dart';

import '../models/evaluation.dart';
import '../models/method.dart';
import '../models/method_list.dart';

class EvaluationDetailScreen extends StatelessWidget {
  const EvaluationDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    final evaluation = arguments['evaluation'] as Evaluation;
    final method = Provider.of<MethodList>(context, listen: false).getSpecificMethod(evaluation.matchmakingId).first;
    final hasInternet = arguments['hasInternet'] as String;
  
    
    return Scaffold(
      appBar: AppBar(
        // title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: hasInternet == 'yes' 
              ? Image.network(
                  evaluation.image,
                  fit: BoxFit.cover,
                )
                : Image.file(
                    File(evaluation.image),
                      fit: BoxFit.cover,
                      width: double.infinity,
                  ),
            ),
            Container(
                color: const Color.fromARGB(255, 187, 217, 231),
                padding: const EdgeInsets.only(left: 30),
                width: double.infinity,
                height: 40,
                alignment: Alignment.centerLeft,
                child: const Text(
                  'd a d o s',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 21, 70, 92)
                  ),
                ),
              ),
              SizedBox(
                child: Column(
                  children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'data',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 66, 66, 66),
                                ),
                              ),
                              SizedBox(child: Text(DateFormat('dd/MM/y').format(evaluation.evaluationDate))),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'método',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 66, 66, 66),
                              ),
                            ),
                            SizedBox(child: Text(evaluation.methodName)),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'tolerância',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 66, 66, 66),
                              ),
                            ),
                            SizedBox(child: Text(evaluation.toleranceName)),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'ambiente',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 66, 66, 66),
                              ),
                            ),
                            SizedBox(child: Text(evaluation.locationId)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: const Color.fromARGB(255, 187, 217, 231),
                padding: const EdgeInsets.only(left: 30),
                width: double.infinity,
                height: 40,
                alignment: Alignment.centerLeft,
                child: const Text(
                  'e q u i p e',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 21, 70, 92)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                        'organização:',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 66, 66, 66),
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: SizedBox(
                        child: evaluation.isOrganized
                        ? Text('Conforme')
                        : Text('Não conforme'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                        'produtividade:',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 66, 66, 66),
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: SizedBox(
                        child: evaluation.isProductive
                        ? const Text('Conforme')
                        : const Text('Não conforme'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                        'segurança:',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 66, 66, 66),
                        ),
                    ),
                     Padding(
                      padding: const EdgeInsets.all(5),
                      child: SizedBox(
                        child: evaluation.isEPI
                        ? Text('Conforme')
                        : Text('Não conforme'),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: const Color.fromARGB(255, 187, 217, 231),
                padding: const EdgeInsets.only(left: 30),
                width: double.infinity,
                height: 40,
                alignment: Alignment.centerLeft,
                child: const Text(
                  'n o t a',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 21, 70, 92)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                        'avaliação geral:',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 66, 66, 66),
                        ),
                    ),
                     Padding(
                      padding: const EdgeInsets.all(5),
                      child: SizedBox(
                        child: method.isMethodGood
                        ? const Text('Conforme')
                        : const Text('Não conforme'),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
