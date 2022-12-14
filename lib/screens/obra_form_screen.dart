// ignore_for_file: avoid_print

import 'package:control/models/obra_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/obra.dart';

class ObraFormPage extends StatefulWidget {
  const ObraFormPage({Key? key}) : super(key: key);

  @override
  _ObraFormPageState createState() => _ObraFormPageState();
}

class _ObraFormPageState extends State<ObraFormPage> {


  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final product = arg as Obra;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['engineer'] = product.engineer;
        _formData['owner'] = product.owner;
        _formData['address'] = product.address;
      }
    }
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    setState(() => _isLoading = true);

    try {
      await Provider.of<ObraList>(
        context,
        listen: false,
      ).saveProduct(_formData);

      Navigator.of(context).pop();
    } catch (error) {
      print(error);
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ocorreu um erro!'),
          content: const Text('Ocorreu um erro para salvar o produto.'),
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
        backgroundColor: Color.fromARGB(255, 9, 123, 143),
        title: const Text('Formul??rio de Obra'),
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
                      initialValue: _formData['name']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                      ),
                      textInputAction: TextInputAction.next,
                      onSaved: (name) => _formData['name'] = name ?? '',
                      validator: (_name) {
                        final name = _name ?? '';

                        if (name.trim().isEmpty) {
                          return 'Nome ?? obrigat??rio';
                        }

                        if (name.trim().length < 3) {
                          return 'Nome precisa no m??nimo de 3 letras.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['engineer']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Engenheiro Respons??vel',
                      ),
                      textInputAction: TextInputAction.next,
                      onSaved: (engineer) => _formData['engineer'] = engineer ?? '',
                      validator: (_engineer) {
                        final engineer = _engineer ?? '';

                        if (engineer.trim().isEmpty) {
                          return 'Engenheiro ?? obrigat??rio';
                        }

                        if (engineer.trim().length < 3) {
                          return 'O nome do engenheiro precisa de no m??nimo de 3 letras.';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['owner']?.toString(),
                      decoration: const InputDecoration(labelText: 'Propriet??rio'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      onSaved: (owner) =>
                          _formData['owner'] = owner ?? '',
                      validator: (_owner) {
                        final owner = _owner ?? '';

                        if (owner.trim().isEmpty) {
                          return 'O propriet??rio ?? obrigat??rio.';
                        }

                        if (owner.trim().length < 3) {
                          return 'Necess??rio no m??nimo 3 letras.';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['address']?.toString(),
                      decoration: const InputDecoration(labelText: 'Endere??o'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      onSaved: (address) =>
                          _formData['address'] = address ?? '',
                      validator: (_address) {
                        final address = _address ?? '';

                        if (address.trim().isEmpty) {
                          return 'O endere??o ?? obrigat??rio.';
                        }

                        if (address.trim().length < 10) {
                          return 'Endere??o precisa de no m??nimo 10 letras.';
                        }

                        return null;
                      },
                    ),                    
                    const Padding(padding: EdgeInsets.all(10)),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 9, 123, 143),
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
                      onPressed: _submitForm,
                      child: const Text('Salvar'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

}
