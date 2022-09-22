
import 'package:flutter/foundation.dart';

import '../models/errorMethod_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/errorMethod.dart';

class ErrorMethodForm extends StatefulWidget {
  final String matchmakingId;
  const ErrorMethodForm(this.matchmakingId, {Key? key}) : super(key: key);

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

      List<ErrorMethod> listErrors = Provider.of<ErrorMethodList>(context, listen: false).getSpecificErrorMethod(errorId);

      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Avalie a Equipe!'),          
          actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                const Text('Estão usando EPI?'),
                Consumer <ErrorMethodList>(
                  builder: (ctx, error, _) => TextButton(
                    child: const Text('Sim'),
                    onPressed: () {
                      ErrorMethod error = listErrors.first;
                      error.changeEPI(true);
                    }
                  ),
                ),
                TextButton(
                  child: const Text('Não'),
                  onPressed: () {
                      ErrorMethod error = listErrors.first;
                      error.changeEPI(false);
                  }
                ),
            ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Estão produtivos?'),
                Consumer <ErrorMethodList>(
                  builder: (ctx, error, _) => TextButton(
                    child: const Text('Sim'),
                    onPressed: () {
                      ErrorMethod error = listErrors.first;
                      error.changeProductive(true);
                    }
                  ),
                ),
                TextButton(
                  child: const Text('Não'),
                  onPressed: () {
                      ErrorMethod error = listErrors.first;
                      error.changeProductive(false);
                    }
                ),
            ],),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Estão organizados?'),
                Consumer <ErrorMethodList>(
                  builder: (ctx, error, _) => TextButton(
                    child: const Text('Sim'),
                    onPressed: () {
                      ErrorMethod error = listErrors.first;
                      error.changeOrganized(true);
                    }
                  ),
                ),
                TextButton(
                  child: const Text('Não'),
                  onPressed: ()  {
                      ErrorMethod error = listErrors.first;
                      error.changeOrganized(false);
                  }
                ),
              ],
            ),
            TextButton(
                child: const Text('Salvar'),
                  onPressed: ()  {
                      Navigator.of(context).pop();
                  }
            ),
          ],
        ),
      );

      Navigator.of(context).pop();

    } catch (error) {
      if (kDebugMode) {
        print(error);
        print(_formData);
      }
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
                    const Divider(),
                    ElevatedButton(
                      onPressed: () async => await _submitForm(), 
                      child: const Text('Salvar'),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
