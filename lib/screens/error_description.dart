
import 'package:flutter/foundation.dart';

import '../models/evaluation.dart';
import '../models/evaluation_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class EvaluationForm extends StatefulWidget {
  final String matchmakingId;
  const EvaluationForm(this.matchmakingId, {Key? key}) : super(key: key);

  @override
  _EvaluationFormState createState() => _EvaluationFormState();
}

class _EvaluationFormState extends State<EvaluationForm> {
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
      final errorId = await Provider.of<EvaluationList>(
        context,
        listen: false,
      ).saveEvaluation(_formData);

      List<Evaluation> listErrors = Provider.of<EvaluationList>(context, listen: false).getSpecificEvaluation(errorId);

      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Avalie a Equipe!'),          
          actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                const Text('Estão usando EPI?'),
                Consumer<Evaluation>(
                  builder:(ctx, error, _) => TextButton(
                    child: const Text('Sim'),
                    onPressed: () {
                      Evaluation error = listErrors.first;
                      error.changeEPI(true, error);
                    },
                  )
                ),
              ],
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
