// ignore_for_file: avoid_print, use_key_in_widget_constructors

import 'package:control/models/location_list.dart';
import 'package:control/models/obra.dart';
import 'package:control/models/obra_list.dart';
import 'package:control/models/stage.dart';
import 'package:control/models/stage_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/location.dart';

class LocationForm extends StatefulWidget {
  const LocationForm();

  @override
  _LocationFormState createState() => _LocationFormState();
}

class _LocationFormState extends State<LocationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  bool _isLoading = false;

  String? obraValue = '';

  List<Location> listLocation = [];
  List<Stage> loadedStages = [];
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // final arg = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

    // listLocation = Provider.of<LocationList>(context).getSpecificLocation(arg['id']);      
    
    // if(listLocation.isNotEmpty){
    //   final Location product = listLocation.first;
      
    //   _formData['location'] = product.location;
    //   _formData['matchmakingId'] = product.matchmakingId;
    // }
    // final provider = Provider.of<StageList>(context);
    // loadedStages = provider.allMatchingStages(arg['obraId']);
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

    setState(() => _isLoading = true);

    try {
      await Provider.of<LocationList>(
        context,
        listen: false,
      ).saveLocation(_formData);

      Navigator.of(context).pop();
    } catch (error) {
      print(error);
      print(_formData);
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ocorreu um erro!'),
          content: const Text('Ocorreu um erro para salvar o local.'),
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
    _formData['matchmakingId'] =  ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 20, 122, 140),
        title: const Text('Formulário de Ambiente'),
        // actions: [
        //   IconButton(
        //     onPressed: _submitForm,
        //     icon: const Icon(Icons.save),
        //   ),
        // ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formData['location']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Localidade',
                      ),
                      textInputAction: TextInputAction.next,
                      onSaved: (location) => _formData['location'] = location ?? '',
                      validator: (_location) {
                        final location = _location ?? '';

                        if (location.trim().isEmpty) {
                          return 'Localidade é obrigatório';
                        }

                        if (location.trim().length < 3) {
                          return 'Localidade precisa no mínimo de 3 letras.';
                        }
                        return null;
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 20, 122, 140),
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
                      onPressed: () => _submitForm(),
                      child: const Text('Salvar'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
