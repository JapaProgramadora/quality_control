import 'package:control/models/stage.dart';
import 'package:control/models/stages_item_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/stage_list.dart';

class StageItemForm extends StatefulWidget {
  const StageItemForm();

  @override
  _StageItemFormState createState() => _StageItemFormState();
}

class _StageItemFormState extends State<StageItemForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  bool _isLoading = false;


  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final arg = ModalRoute.of(context)?.settings.arguments;

  //   if(arg != null){
  //     final List<Stage> listStages = Provider.of<StageList>(context).getSpecificStage(arg);      
      
  //     if (listStages.isEmpty) {
  //       _formData['matchmakingId'] = arg.toString();
  //     }
  //     else{        
  //       // final List<Stage> provider = Provider.of<StageList>(context).getSpecificStage(arg);
  //       final Stage product = listStages.first;
        

  //       print(product.id);
  //       print(product.matchmakingId);

  //       _formData['id'] = product.id;
  //       _formData['stage'] = product.stage;
  //       _formData['matchmakingId'] = product.matchmakingId;
  //     }
  //   }
  // }

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
      await Provider.of<StagesList>(
        context,
        listen: false,
      ).saveItem(_formData);

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
                      initialValue: _formData['item']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Item',
                      ),
                      textInputAction: TextInputAction.next,
                      onSaved: (item) => _formData['item'] = item ?? '',
                      validator: (_item) {
                        final item = _item ?? '';

                        if (item.trim().isEmpty) {
                          return 'O item é obrigatório';
                        }

                        if (item.trim().length < 3) {
                          return 'O item precisa ter no mínimo de 3 letras.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['method']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Método',
                      ),
                      textInputAction: TextInputAction.next,
                      onSaved: (method) => _formData['method'] = method ?? '',
                      validator: (_method) {
                        final method = _method ?? '';

                        if (method.trim().isEmpty) {
                          return 'O método é obrigatório';
                        }

                        if (method.trim().length < 3) {
                          return 'O método precisa no mínimo de 3 letras.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['tolerance']?.toString(),
                      decoration: InputDecoration(labelText: 'Tolerância'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.numberWithOptions(
                         decimal: true,
                      ),
                      onSaved: (tolerance) =>
                          _formData['tolerance'] = double.parse(tolerance ?? '0'),
                      validator: (_tolerance) {
                        final toleranceString = _tolerance ?? '';
                        final tolerance = double.tryParse(toleranceString) ?? -1;

                        if (tolerance <= 0) {
                          return 'Informe uma tolerância válida.';
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
