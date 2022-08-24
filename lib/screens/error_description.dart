
import 'package:control/models/errorMethod_list.dart';
import 'package:control/models/method_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/errorMethod.dart';
import '../models/method.dart';

class ErrorMethodForm extends StatefulWidget {
  final String matchmakingId;
  const ErrorMethodForm(this.matchmakingId);

  @override
  _ErrorMethodFormState createState() => _ErrorMethodFormState();
}

class _ErrorMethodFormState extends State<ErrorMethodForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  bool _isLoading = false;

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
      final errorId = await Provider.of<ErrorMethodList>(
        context,
        listen: false,
      ).saveErrorMethod(_formData);


      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Avalie a Equipe!'),
          actions: [
            Text('Estão produtivos?'),
            Consumer <ErrorMethodList>(
              builder: (ctx, error, _) => TextButton(
                child: const Text('Sim'),
                onPressed: () {
                  List<ErrorMethod> listErrors = Provider.of<ErrorMethodList>(context, listen: true).getSpecificErrorMethod(errorId);
                  ErrorMethod error = listErrors.first;
                  error.changeEPI();
                }
              ),
            ),
            TextButton(
              child: const Text('Não'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );

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
    _formData['matchmakingId'] = widget.matchmakingId;

    return Scaffold(
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
                      initialValue: _formData['error']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                      ),
                      maxLines: 5,
                      textInputAction: TextInputAction.next,
                      onSaved: (description) => _formData['error'] = description ?? '',
                      validator: (_description) {
                        final description = _description ?? '';

                        if (description.trim().isEmpty) {
                          return 'A descrição é obrigatório';
                        }

                        if (description.trim().length < 3) {
                          return 'A descrição precisa ter no mínimo de 3 letras.';
                        }
                        return null;
                      },
                    ),
                    Divider(),
                    ElevatedButton(
                      onPressed: _submitForm, 
                      child: Text('Salvar'),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
