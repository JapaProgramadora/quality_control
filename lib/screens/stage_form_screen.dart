import 'package:control/models/obra_list.dart';
import 'package:control/models/stage.dart';
import 'package:control/models/stage_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/obra.dart';
import '../models/stage_list.dart';

class StageFormScreen extends StatefulWidget {

  const StageFormScreen();

  @override
  _StageFormScreenState createState() => _StageFormScreenState();
}

class _StageFormScreenState extends State<StageFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  bool _isLoading = false;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;

    if (_formData.isEmpty) {

      if (arg != null) {
        final List<Stage> provider = Provider.of<StageList>(context).getSpecificStage(arg);
        final Stage product = provider[0];
        print(product.id);
        print(product.matchmakingId);

        _formData['id'] = product.id;
        _formData['stage'] = product.stage;
        _formData['matchmakingId'] = product.matchmakingId;
      }
    }else{
      if(arg != null){
        _formData['matchmakingId'] = arg.toString();
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Item'),
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
                        labelText: 'Estágio',
                      ),
                      textInputAction: TextInputAction.next,
                      onSaved: (stage) => _formData['stage'] = stage ?? '',
                      validator: (_stage) {
                        final stage = _stage ?? '';

                        if (stage.trim().isEmpty) {
                          return 'Estágio é obrigatório';
                        }

                        if (stage.trim().length < 3) {
                          return 'Estágio precisa no mínimo de 3 letras.';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
