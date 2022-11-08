// ignore_for_file: use_key_in_widget_constructors, avoid_print, unused_local_variable

import 'package:control/models/item_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/item.dart';

class ItemForm extends StatefulWidget {
  const ItemForm();

  @override
  _ItemFormState createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  DateTime _selectedBeginningDate = DateTime.now();
  DateTime _selectedEndingDate = DateTime.now();  

  bool _isLoading = false;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;

    if(arg != null){
      
      if((arg as Map)['id'] != null){
        final Items product = Provider.of<ItemList>(context).getSpecificItem(arg['id']);

        _formData['id'] = product.id;
        _formData['item'] = product.item;
        _formData['description'] = product.description;
        _selectedBeginningDate = product.beginningDate;
        _selectedEndingDate = product.endingDate;
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
      await Provider.of<ItemList>(
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
        backgroundColor:  const Color.fromARGB(255, 9, 123, 143),
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
                      initialValue: _formData['description']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Anotações (Opcional)',
                      ),
                      textInputAction: TextInputAction.next,
                      maxLines: 5,
                      onSaved: (description) => _formData['description'] = description ?? '',
                      validator: (_description) {                        
                        final description = _description;
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 70,
                      child: Row(
                        children: <Widget> [
                            Expanded(
                              child: Text(
                                'Data Selecionada: ${DateFormat('dd/MM/y').format(_selectedBeginningDate)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            TextButton(
                              child: const Text('Selecionar Inicio'),
                              onPressed: () {
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
                                      _selectedBeginningDate = pickedDate;
                                      _formData['beginningDate'] = _selectedBeginningDate;
                                    });
                                  });
                              },
                            )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 70,
                      child: Column(
                        children: [
                          Row(
                            children: <Widget> [
                                Expanded(
                                  child: Text(
                                    'Data Selecionada: ${DateFormat('dd/MM/y').format(_selectedEndingDate)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  child: const Text(
                                    'Selecionar Final',
                                  ),
                                  onPressed: () {
                                    showDatePicker(
                                        context: context, 
                                        initialDate: DateTime.now(), 
                                        firstDate: DateTime(2019), 
                                        lastDate: DateTime(2025),
                                      ).then((pickedDate) {
                                        setState(() {
                                          if (pickedDate == null){
                                            return;
                                          }
                                          _selectedEndingDate = pickedDate;
                                          _formData['endingDate'] = _selectedEndingDate;
                                        });
                                      });
                                  }
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
