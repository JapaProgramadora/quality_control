// ignore_for_file: avoid_print, use_key_in_widget_constructors, avoid_function_literals_in_foreach_calls

import 'package:control/models/location.dart';
import 'package:control/models/location_list.dart';
import 'package:control/models/stage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/stage_list.dart';

class CopyStageForm extends StatefulWidget {
  const CopyStageForm();

  @override
  _CopyStageFormState createState() => _CopyStageFormState();
}

class _CopyStageFormState extends State<CopyStageForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  final _formData2 = <String, Object>{};

  bool _isLoading = false;


  Future<void> _submitForm(Stage stage, String matchmakingId) async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    _formData['stage'] = stage.stage;
    _formData['matchmakingId'] = matchmakingId;

    final List<Location> loadedLocations = Provider.of<LocationList>(context, listen: false).getAllItems(stage.id);

    setState(() => _isLoading = true);

    try {
      String stageId = await Provider.of<StageList>(
        context,
        listen: false,
      ).saveStage(_formData);

      if(loadedLocations.isNotEmpty){
        loadedLocations.forEach((element) async { 
            _formData2['location'] = element.location;
            _formData2['matchmakingId'] = stageId;

            await Provider.of<LocationList>(
            context,
            listen: false,
          ).saveLocation(_formData2);
        });

      }

      Navigator.of(context).pop();
    } catch (error) {
      print(error);
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
    final matchId = ModalRoute.of(context)?.settings.arguments as String;
    final List<Stage> loadedStages = Provider.of<StageList>(context).items;
    final dropValue = ValueNotifier('');
    String arg = '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Estágio'),
        actions: [
          IconButton(
            onPressed: () {
              Stage stage = Provider.of<StageList>(context, listen: false).getSpecificStage(arg).first;
              _submitForm(stage, matchId);
            },
            icon: const Icon(Icons.save),
          ),
        ],
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
                    ValueListenableBuilder(
                      valueListenable: dropValue, 
                      builder: (BuildContext ctx, String value, _){
                        return DropdownButton<String>(
                          hint: const Text('Estágio'),
                          value: (value.isEmpty)? null : value,
                          onChanged: (escolha) => arg = escolha.toString(),
                          items: loadedStages.map((stages) => DropdownMenuItem(
                            value: stages.id,
                            child: Text(stages.stage))
                          ).toList(), 
                        );
                      }
                    ),
                  ],
                ),
              ),
            ),
      );
  }
}
