
// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:control/components/image_input.dart';
import 'package:control/models/evaluation_list.dart';
import 'package:control/models/location.dart';
import 'package:control/models/location_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../models/team.dart';
import 'package:flutter/material.dart';

import '../models/method.dart';

class EvaluationScreen extends StatefulWidget {

  const EvaluationScreen({ Key? key }) : super(key: key);

  @override
  State<EvaluationScreen> createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  final _textController = TextEditingController();
  bool isVisible = false;
  bool isLoading = false;
  String? methodValue;
  String? placeValue = '';
  String? teamValue = '';
  int index = 0;
  int currentStep = 0;
  File? _storedImage;

  _takePicture() async {
    final ImagePicker picker = ImagePicker();
    XFile imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    ) as XFile;

    setState(() {
      _storedImage = File(imageFile.path);
    });
  }

  @override
  Widget build(BuildContext context)  {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    final method = arguments['method'] as Method;
    _formData['matchmakingId'] = method.id;
    File? _pickedImage;
    File selectedImage;
    final loadedLocations = arguments['locations'] as List<Location>;
    List<String> allMethods = method.method;
    List<String> allTolerances = method.tolerance;

    void _selectImage(File pickedImage) {
      _pickedImage = pickedImage;
    }


  return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text(
          'Avaliação',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.horizontal,
          currentStep: currentStep,
          elevation: 0,
          controlsBuilder:(context, details) {
            return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
                TextButton(
                  onPressed: details.onStepContinue,
                  child: const Text(
                    'Salvar',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 78, 142, 161)),
                  ),
                ),
                const SizedBox(width: 15,),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 209, 219, 215)),
                  ),
                  onPressed: details.onStepCancel,
                  child: const Text(
                    'Voltar',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
              ],
            );
          },
          onStepCancel: () {
            setState(() {
              if(currentStep == 0){
                currentStep == 0;
              }else{
                currentStep -=1;
              }
            });
          },
          onStepContinue: () async {
            setState(() {
              currentStep +=1;
            });
            if(currentStep == 2){
              setState(() {
                currentStep -=1;
                isLoading = true;
              }); 
              await Provider.of<EvaluationList>(context, listen: false,).saveEvaluation(_formData, _pickedImage!);
              setState(() {
                isLoading = false;
              });
            }
          },
          steps: [
            Step(
              isActive: currentStep >= 0,
              title: const Text('Identificação'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    const Text(
                      'Insira os dados',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 20,),
                    const Text(
                          'Avaliação:',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 66, 66, 66),
                           ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () async {
                            method.changeMethodGood(true, method);
                            setState(() {
                                isVisible = false;
                            });
                          },
                          icon: const Icon(Icons.thumb_up_rounded),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 141, 199, 143),
                          )
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () {
                              method.changeMethodGood(false, method);
                              setState(() {
                                isVisible = true;
                              });
                            },
                          icon: const Icon(Icons.thumb_down_alt_rounded),
                        ),
                      ],
                    ),
                    Visibility(
                      child: Column(
                        children: [
                          TextField(
                            controller: _textController,
                            maxLines: 2,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Descreva o erro',
                            ),
                          ),
                          TextButton(onPressed: () {
                            _formData['error'] = _textController.text;
                          }, 
                          child: Text('OK')
                          )
                        ],
                      ),
                      visible: isVisible == true,
                    ),
                    SizedBox(height: 10,),
                    ImageInput(_selectImage),
                    SizedBox(height: 10,),
                    Column(
                      children: [
                        Container(
                          width: 350,
                          child: const Text(
                            'Método',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 66, 66, 66),
                             ),
                          ),
                        ),
                        const SizedBox(height: 15,),
                        Container(
                          width: 350,
                          padding: const EdgeInsets.all(8),
                          child: DropdownButton<String>(
                            hint: const Text('Método'),
                            isExpanded: true,
                            isDense: true,
                            borderRadius: BorderRadius.circular(5),
                            value: methodValue,
                            onChanged: (escolha) {
                              setState(() {
                                methodValue = escolha;
                                _formData['methodName'] = escolha.toString();
                                for(int i = 0; i < allMethods.length; i++){
                                    if(method.method[i] == escolha){
                                      index = i;
                                    }
                                }
                                _formData['toleranceName'] = allTolerances[index];
                                _formData['team'] = method.team;
                                _formData['image'] = _pickedImage!;
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
                    Column(
                      children: [
                       Container(
                          width: 350,
                          child: const Text(
                            'Tolerância',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 66, 66, 66),
                             ),
                          ),
                        ),
                        const SizedBox(height: 15,),
                        Container(
                        width: 350,
                        padding: const EdgeInsets.all(8),
                        child: Text(
                            allTolerances[index],
                          )
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Column(
                      children: [
                        Container(
                          width: 350,
                          child: const Text(
                            'Ambiente',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 66, 66, 66),
                             ),
                          ),
                        ),
                        const SizedBox(height: 15,),
                        Container(
                          width: 350,
                          padding: const EdgeInsets.all(8),
                          child: SingleChildScrollView(
                            child: DropdownButton<String?>(
                              hint: const Text('Ambiente'),
                              isExpanded: true,
                              isDense: true,
                              value: (placeValue == '')? null : placeValue,
                              onChanged: (escolha) {
                                setState(() {
                                  placeValue = escolha.toString();
                                  _formData['locationId'] = escolha.toString();
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
                    const SizedBox(height: 20,),
                  ],
                ),
            ),
            Step(
              isActive: currentStep >= 1,
              title: const Text('Equipe'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                      'Avalie a Equipe',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                      ),
                  ),
                  const SizedBox(height: 30,),
                  Column(
                      children: [
                        Container(
                          width: 350,
                          child: const Text(
                            'Equipe',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 66, 66, 66),
                             ),
                          ),
                        ),
                        const SizedBox(height: 15,),
                        Container(
                        width: 350,
                        padding: const EdgeInsets.all(8),
                        child: Text(method.team)
                        ),
                      ],
                    ),
                  const Text(
                      'Organização:',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 66, 66, 66),
                      ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () async {
                            _formData['isOrganized'] = true;
                          },
                          icon: const Icon(Icons.thumb_up_rounded),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () {
                              _formData['isOrganized'] = false;
                            },
                          icon: const Icon(Icons.thumb_down_alt_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                        'Produtividade:',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 66, 66, 66),
                        ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () async {
                              _formData['isProductive'] = true;
                            },
                            icon: const Icon(Icons.thumb_up_rounded),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            onPressed: () {
                                _formData['isProductive'] = false;
                              },
                            icon: const Icon(Icons.thumb_down_alt_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Segurança:',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 66, 66, 66),
                        ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () async {
                              _formData['isEPI'] = true;
                          },
                          icon: const Icon(Icons.thumb_up_rounded),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () {
                            _formData['isEPI'] = false;
                          },
                          icon: const Icon(Icons.thumb_down_alt_rounded),
                        ),
                      ],
                    ),
                ],
              )
            )
          ],
        ),
      )
    );
  }
}