import 'package:control/models/obra_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/app_routes.dart';

class AppDrawer extends StatefulWidget {

  const AppDrawer({ Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {

  @override
    void initState() {
      super.initState();
      Provider.of<ObraList>(
        context,
        listen: false,
      ).loadProducts();
  }
  

  @override
  Widget build(BuildContext context) {
  
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Informações Extras'),
            backgroundColor:const  Color.fromARGB(255, 9, 123, 143),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.verified),
            title: const Text('Análise'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.engineering),
            title: const Text('Equipe'),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.TEAM_SCREEN);
            },
          ),
        ],
      ),
    );
  }
}