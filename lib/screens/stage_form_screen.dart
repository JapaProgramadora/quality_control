// ignore_for_file: avoid_print, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/stage.dart';
import '../models/stage_list.dart';

class StageFormScreen extends StatefulWidget {
  const StageFormScreen();

  @override
  _StageFormScreenState createState() => _StageFormScreenState();
}

class _StageFormScreenState extends State<StageFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  bool _isLoading = false;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;

    if(arg != null){
      final List<Stage> listStages = Provider.of<StageList>(context).getSpecificStage(arg);      
      
      if (listStages.isEmpty) {
        _formData['matchmakingId'] = arg.toString();
      }
      else{        
        // final List<Stage> provider = Provider.of<StageList>(context).getSpecificStage(arg);
        final Stage product = listStages.first;
        

        print(product.id);
        print(product.matchmakingId);

        _formData['id'] = product.id;
        _formData['stage'] = product.stage;
        _formData['matchmakingId'] = product.matchmakingId;
      }
    }
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
      await Provider.of<StageList>(
        context,
        listen: false,
      ).saveStage(_formData);

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
    final arg = ModalRoute.of(context)?.settings.arguments;
    _formData['matchmakingId'] = arg.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formul??rio de Est??gio'),
        backgroundColor: const Color.fromARGB(255, 9, 123, 143),
        actions: [
          IconButton(
            onPressed: _submitForm,
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
                    TextFormField(
                      initialValue: _formData['stage']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Est??gio',
                      ),
                      textInputAction: TextInputAction.next,
                      onSaved: (stage) => _formData['stage'] = stage ?? '',
                      validator: (_stage) {
                        final stage = _stage ?? '';

                        if (stage.trim().isEmpty) {
                          return 'Est??gio ?? obrigat??rio';
                        }

                        if (stage.trim().length < 3) {
                          return 'Est??gio precisa no m??nimo de 3 letras.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 9, 123, 143),
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
