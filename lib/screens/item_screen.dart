// ignore_for_file: unused_field

import '../components/item_grid.dart';
import '../models/method_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/item_list.dart';
import '../utils/app_routes.dart';


class ItemScreen extends StatefulWidget {
  const ItemScreen({ Key? key, }) : super(key: key);

  @override
  State<ItemScreen> createState() => _ItemScreenState();
  
}

class _ItemScreenState extends State<ItemScreen> {

  bool _isLoading = true;

  @override
    void initState() {
      super.initState();
      Provider.of<ItemList>(
        context,
        listen: false,
      ).loadItems().then((value) {
        setState(() {
        _isLoading = false;
        });
      });
      Provider.of<MethodList>(
        context,
        listen: false,
      ).loadMethod();
  }

          
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Controle de Qualidade'),
        actions: [
          IconButton(
            onPressed: () {
              //para add vc passar
              Navigator.of(context).pushNamed(AppRoutes.ITEM_FORM_SCREEN, arguments: {
                'matchmakingId' : id
              });
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ItemGrid(matchmakingId: id),
    );
  }
}
