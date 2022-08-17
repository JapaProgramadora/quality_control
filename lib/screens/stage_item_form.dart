// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'package:control/models/stages_item_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/stage_item.dart';

class StageItemForm extends StatefulWidget {
  const StageItemForm();

  @override
  _StageItemFormState createState() => _StageItemFormState();
}

class _StageItemFormState extends State<StageItemForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  DateTime _selectedDate = DateTime.now(); 

  bool _isLoading = false;

  void _showDatePicker(){
    showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(2019), 
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      setState(() {
        if (pickedDate == null){
          return;
        }
        _selectedDate = pickedDate;
        _formData['date'] = _selectedDate;
      });
    });
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;

    if(arg != null){
      
      if((arg as Map)['id'] != null){
        final Items product = Provider.of<StagesList>(context).getSpecificItem(arg['id']);

        _formData['id'] = product.id;
        _formData['item'] = product.item;
        _formData['description'] = product.description;
        _formData['method'] = product.method;
        _formData['tolerance'] = product.tolerance;
        _formData['date'] = product.date;
        _formData['matchmakingId'] = product.matchmakingId;
      
      }
      else{
        _formData['matchmakingId'] = arg['matchmakingId'];
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
                      decoration: const InputDecoration(labelText: 'Tolerância'),
                      textInputAction: TextInputAction.next,
                      keyboardType: const TextInputType.numberWithOptions(
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
                    TextFormField(
                      initialValue: _formData['description']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Anotações (Opcional)',
                      ),
                      textInputAction: TextInputAction.next,
                      maxLines: 5,
                      onSaved: (description) => _formData['description'] = description ?? '',
                      validator: (_description) {                        
                        final description = _description ?? '';
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 70,
                      child: Row(
                        children: <Widget> [
                            Expanded(
                              child: Text(
                                _selectedDate == null 
                                ? 'Nenhuma data selecionada!'
                                : 'Data Selecionada: ${DateFormat('dd/MM/y').format(_selectedDate)}',
                                ),
                            ),
                            TextButton(
                              child: const Text('Selecionar Data'),
                              onPressed: _showDatePicker,
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
