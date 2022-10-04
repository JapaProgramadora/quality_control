// ignore_for_file: avoid_print, use_key_in_widget_constructors

import 'package:control/models/location_list.dart';
import 'package:control/models/stage.dart';
import 'package:control/models/stage_list.dart';
import 'package:control/utils/obraId_helper.dart';
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

  List<Location> listLocation = [];
  List<Stage> loadedStages = [];
  


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

    listLocation = Provider.of<LocationList>(context).getSpecificLocation(arg['id']);      
    
    if(listLocation.isNotEmpty){
      final Location product = listLocation.first;
      
      _formData['location'] = product.location;
      _formData['matchmakingId'] = product.matchmakingId;
    }
    final provider = Provider.of<StageList>(context);
    loadedStages = provider.allMatchingStages(arg['obraId']);
  }

  Future<void> _submitForm(String dropValue) async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    if(_formData.isEmpty){
      return;
    }

    _formData['matchmakingId'] = dropValue.toString();

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
    final dropValue = ValueNotifier('');
    String arg = '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade900,
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
                    // ValueListenableBuilder(
                    //   valueListenable: dropValue, 
                    //   builder: (BuildContext ctx, String value, _){
                    //     return DropdownButton<String>(
                    //       hint: const Text('Estágio'),
                    //       value: (value.isEmpty)? null : value,
                    //       onChanged: (escolha) => arg = escolha.toString(),
                    //       items: loadedStages.map((stages) => DropdownMenuItem(
                    //         value: stages.id,
                    //         child: Text(stages.stage))
                    //       ).toList(), 
                    //     );
                    //   }
                    // ),
                    const Padding(padding: EdgeInsets.all(10)),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade900,
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
                      onPressed: () => _submitForm(arg),
                      child: const Text('Salvar'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
