// ignore_for_file: avoid_print, use_key_in_widget_constructors

import 'package:control/models/method.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/method_list.dart';

class MethodForm extends StatefulWidget {
  const MethodForm();

  @override
  _MethodFormState createState() => _MethodFormState();
}

class _MethodFormState extends State<MethodForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  List<String> methods = [];
  List<String> tolerances = [];

  bool _isLoading = false;

  @override 
  void initState(){
    super.initState();
    methods = List<String>.empty(growable: true);
    methods.add('');
    tolerances = List<String>.empty(growable: true);
    tolerances.add('');
  }



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;

    if(arg != null){
      final List<Method> listMethods = Provider.of<MethodList>(context).getSpecificMethod(arg);      
      
      if (listMethods.isEmpty) {
        _formData['matchmakingId'] = arg.toString();
      }
      else{        
        // final List<Method> provider = Provider.of<MethodList>(context).getSpecificMethod(arg);
        final Method product = listMethods.first;
        

        print(product.id);
        print(product.matchmakingId);

        _formData['id'] = product.id;
        _formData['method'] = product.method;
        _formData['item'] = product.item;
        _formData['team'] = product.team;
        _formData['tolerance'] = product.tolerance;
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

    _formData['tolerance'] = tolerances;
    _formData['method'] = methods;

    try {
      await Provider.of<MethodList>(
        context,
        listen: false,
      ).saveMethod(_formData);

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
        title: const Text('Formulário de Método de Verificação'),
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
                        _formData['item'] = '';

                        if (item.trim().isEmpty) {
                          return 'Item é obrigatório';
                        }

                        if (item.trim().length < 3) {
                          return 'Item precisa no mínimo de 3 letras.';
                        }
                        return null;
                      },
                    ),
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(children: [emailUi(index)],);
                      },
                      itemCount: methods.length,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget emailUi(index){
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: TextFormField(
                  initialValue: methods[index],
                  decoration: const InputDecoration(
                  labelText: 'Método',
                  ),
                  textInputAction: TextInputAction.next,
                  onSaved: (method) => methods[index] = method ?? '',
                  validator: (_method) {
                  final method = _method ?? '';

                  if (method.trim().isEmpty) {
                    return 'Método é obrigatório';
                  }

                  if (method.trim().length < 3) {
                    return 'Método precisa no mínimo de 3 letras.';
                  }
                  return null;
                },
              ),
            ),
            Visibility(
              child: SizedBox(
                  width: 35,
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      addEmailControl('method');
                    },
                  )
              ),
              visible: index == methods.length - 1,
            ),
            Visibility(
              child: SizedBox(
                  width: 35,
                  child: IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      removeEmailControl(index, 'method');
                    },
                )
              ),
              visible: index > 0,
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              child: TextFormField(
                  initialValue: tolerances[index],
                  decoration: const InputDecoration(
                  labelText: 'Tolerância',
                  ),
                  textInputAction: TextInputAction.next,
                  onSaved: (tolerance) => tolerances[index] = tolerance ?? '',
                  validator: (_tolerance) {
                  final tolerance = _tolerance ?? '';

                  if (tolerance.trim().isEmpty) {
                    return 'Tolerância é obrigatório';
                  }

                  if (tolerance.trim().length < 3) {
                    return 'Tolerância precisa no mínimo de 3 letras.';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void addEmailControl(String item){
    setState(() {
      if(methods.isNotEmpty){
        methods.add("");
        tolerances.add("");
      }
    });
  }

  void removeEmailControl(index, String item){
    setState(() {
        if(methods.length > 1){
          methods.removeAt(index);
          tolerances.removeAt(index);
        }
    });
  }
}
