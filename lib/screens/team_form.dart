// ignore_for_file: avoid_print, use_key_in_widget_constructors

import 'package:control/models/location_list.dart';
import 'package:control/models/stage.dart';
import 'package:control/models/stage_list.dart';
import 'package:control/models/team.dart';
import 'package:control/models/team_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/location.dart';

class TeamForm extends StatefulWidget {
  const TeamForm();

  @override
  _TeamFormState createState() => _TeamFormState();
}

class _TeamFormState extends State<TeamForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  bool _isLoading = false;

  List<Team> listTeam = [];
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    
    if(arg.isNotEmpty){
      final Team product = arg['team'];
      
      _formData['id'] = product.id;
      _formData['team'] = product.team;
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
      await Provider.of<TeamList>(
        context,
        listen: false,
      ).saveTeam(_formData);

      Navigator.of(context).pop();
    } catch (error) {
      print(error);
      print(_formData);
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ocorreu um erro!'),
          content: const Text('Ocorreu um erro para salvar a equipe.'),
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
        backgroundColor: Colors.purple.shade900,
        title: const Text('Formulário de Equipe'),
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
                      initialValue: _formData['team']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Equipe',
                      ),
                      textInputAction: TextInputAction.next,
                      onSaved: (team) => _formData['team'] = team ?? '',
                      validator: (_team) {
                        final team = _team ?? '';

                        if (team.trim().isEmpty) {
                          return 'Equipe é obrigatório';
                        }

                        if (team.trim().length < 3) {
                          return 'Equipe precisa no mínimo de 3 letras.';
                        }
                        return null;
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade900,
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
