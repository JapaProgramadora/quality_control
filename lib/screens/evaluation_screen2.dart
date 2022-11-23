import 'dart:io';

import 'package:control/components/image_input.dart';
import 'package:control/models/evaluation_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rolling_switch/rolling_switch.dart';

import '../models/location.dart';
import '../models/method.dart';

class EvaluationScreen2 extends StatefulWidget {
  const EvaluationScreen2({Key? key}) : super(key: key);

  @override
  State<EvaluationScreen2> createState() => _EvaluationScreen2State();
}

class _EvaluationScreen2State extends State<EvaluationScreen2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  final _textController = TextEditingController();
   final _textControllerEngenheiro = TextEditingController();
  bool _isLoading = false;
  bool isOrganized = false;
  bool isEPI = false;
  bool isProductive = false;
  bool isDependent = false;
  String team = '';
  String newMethod = '';
  String newPlace = '';
  String newTolerance = '';
  String error = '';
  String? methodValue;
  String? placeValue = '';
  String? teamValue = '';
  int index = 0;
  File? _pickedImage;

  void _selectImage(File pickedImage) {
    setState(() {
      _pickedImage = pickedImage;
    });
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    if(_formData.isEmpty){
      return;
    }

    _formData['isOrganized'] = isOrganized;
    _formData['isProductive'] = isProductive;
    _formData['isEPI'] = isEPI;
    _formData['methodName'] = newMethod;
    _formData['locationId'] = newPlace;
    _formData['toleranceName'] = newTolerance;
    _formData['error'] = _textController.text;
    setState(() => _isLoading = true);

    try {
      await Provider.of<EvaluationList>(
        context,
        listen: false,
      ).saveEvaluation(_formData, _pickedImage);

      Navigator.of(context).pop();
    } catch (error) {
      print(error);
      print(_formData);
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ocorreu um erro!'),
          content: const Text('Ocorreu um erro para salvar o item.'),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    final method = arguments['method'] as Method;
    final loadedLocations = arguments['locations'] as List<Location>;
    List<String> allMethods = method.method;
    List<String> allTolerances = method.tolerance;
    _formData['matchmakingId'] = method.matchmakingId;
    _formData['team'] = method.team;

    if(allMethods.length == 1){
      methodValue = allMethods.first; 
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: const Icon(Icons.save),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 9, 123, 143),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30)
          )
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: Container(
            padding: const EdgeInsets.only(bottom: 20, right: 170),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                 Text(
                  'Avaliação',
                  style: TextStyle(
                    fontSize: 37,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                )
              ],
            )
          ),
        ),
      ),
      body: _isLoading? 
          const Center(child: CircularProgressIndicator(),)
        : SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20,),
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
                        padding: const EdgeInsets.only(left: 25, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                            width: 80,
                            child: Text(
                              'método',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 66, 66, 66),
                              ),
                            ),
                          ),
                          Container(
                            width: 240,
                            padding: const EdgeInsets.all(8),
                            child: DropdownButton<String>(
                              underline: const SizedBox(),
                              isExpanded: true,
                              isDense: true,
                              borderRadius: BorderRadius.circular(5),
                              value: methodValue,
                              onChanged: (escolha) {
                                setState(() {
                                  methodValue = escolha;
                                  newMethod = escolha.toString();
                                  for(int i = 0; i < allMethods.length; i++){
                                      if(method.method[i] == escolha){
                                        index = i;
                                      }
                                  }
                                  newTolerance = allTolerances[index];
                                });
                              },
                              items: allMethods.map((method) => DropdownMenuItem(
                                value: method,
                                child: Text(method)
                                ),
                              ).toList(), 
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 25, top: 10),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 110,
                            child: Text(
                              'tolerância',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 66, 66, 66),
                                ),
                            ),
                          ),
                          const SizedBox(height: 15, width: 15,),
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    methodValue == null? '': allTolerances[index],
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, top: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 100,
                            child: Text(
                              'ambiente',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 66, 66, 66),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15,),
                          SizedBox(
                            width: 227,
                            child: SingleChildScrollView(
                              child: DropdownButton<String?>(
                                underline: const SizedBox(),
                                isExpanded: true,
                                isDense: true,
                                value: (placeValue == '')? null : placeValue,
                                onChanged: (escolha) {
                                  setState(() {
                                    placeValue = escolha.toString();
                                    newPlace = escolha.toString();
                                  });
                                },
                                items: loadedLocations.map((location) => DropdownMenuItem(
                                  value: location.location,
                                  child: Text(location.location)
                                  ),
                                ).toList(), 
                              )
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, top: 0, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                              'avaliador:',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 66, 66, 66),
                              ),
                          ),
                          SizedBox(
                            width: 250,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25, right: 25),
                              child: TextField(
                                controller: _textControllerEngenheiro,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  hintText: 'Engenheiro Avaliador',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(onPressed: () {
                      _formData['engineer'] = _textControllerEngenheiro.text;
                    }, 
                      child: const Text('OK')
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
                padding: const EdgeInsets.only(left: 25, top: 0, bottom: 15),
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
                      child: Transform.scale(
                        scale: 0.7,
                        child: RollingSwitch.icon(
                          onChanged: (bool value) {
                            setState(() {
                              isOrganized = value;
                             });
                          },
                          rollingInfoRight: const RollingIconInfo(
                            backgroundColor: Colors.greenAccent,
                            icon: Icons.check,
                            text: Text(''),
                          ),
                          rollingInfoLeft: const RollingIconInfo(
                            icon: Icons.flag,
                            backgroundColor: Colors.grey,
                            text: Text(''),
                          ),
                        )
                      )
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, top: 0, bottom: 15),
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
                      child: Transform.scale(
                        scale: 0.7,
                        child: RollingSwitch.icon(
                          onChanged: (bool value) {
                             setState(() {
                                isProductive = value;
                             });
                          },
                          rollingInfoRight: const RollingIconInfo(
                            backgroundColor: Colors.greenAccent,
                            icon: Icons.check,
                            text: Text(''),
                          ),
                          rollingInfoLeft: const RollingIconInfo(
                            icon: Icons.flag,
                            backgroundColor: Colors.grey,
                            text: Text(''),
                          ),
                        )
                      )
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, top: 0, bottom: 15),
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
                      child: Transform.scale(
                        scale: 0.7,
                        child: RollingSwitch.icon(
                          onChanged: (bool value) {
                            setState(){
                              isEPI = value;
                            }
                          },
                          rollingInfoRight: const RollingIconInfo(
                            backgroundColor: Colors.greenAccent,
                            icon: Icons.check,
                            text: Text(''),
                          ),
                          rollingInfoLeft: const RollingIconInfo(
                            icon: Icons.flag,
                            backgroundColor: Colors.grey,
                            text: Text(''),
                          ),
                        )
                      )
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
                  's i t u a ç ã o',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 21, 70, 92)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, top: 0, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                        'pendente:',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 66, 66, 66),
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Transform.scale(
                        scale: 0.7,
                        child: RollingSwitch.icon(
                          onChanged: (bool value) {
                            if(value == true){
                              method.changeDependent(true, method);
                            }else{
                              method.changeDependent(false, method);
                            }
                          },
                          rollingInfoRight: const RollingIconInfo(
                            backgroundColor: Colors.greenAccent,
                            icon: Icons.check,
                            text: Text(''),
                          ),
                          rollingInfoLeft: const RollingIconInfo(
                            icon: Icons.flag,
                            backgroundColor: Colors.grey,
                            text: Text(''),
                          ),
                        )
                      )
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, top: 0, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                        'conforme:',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 66, 66, 66),
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Transform.scale(
                        scale: 0.7,
                        child: RollingSwitch.icon(
                          onChanged: (bool value) {
                            if(value == true){
                              method.changeMethodGood(true, method);
                            }else{
                              method.changeMethodGood(false, method);
                            }
                          },
                          rollingInfoRight: const RollingIconInfo(
                            backgroundColor: Colors.greenAccent,
                            icon: Icons.check,
                            text: Text(''),
                          ),
                          rollingInfoLeft: const RollingIconInfo(
                            icon: Icons.flag,
                            backgroundColor: Colors.grey,
                            text: Text(''),
                          ),
                        )
                      )
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10),
                child: ImageInput(_selectImage),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: TextField(
                  controller: _textController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Adicione uma descrição',
                  ),
                ),
              ),
              TextButton(onPressed: () {
                _formData['engineer'] = _textControllerEngenheiro.text;
                }, 
                child: const Text('OK')
              ),
            ],
          ),
        ),
      ),
    );
  }
}