import 'package:flutter/material.dart';

import '../utils/app_routes.dart';

class AppDrawer extends StatelessWidget {

  const AppDrawer({ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Informações Extras'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.book_rounded),
            title: const Text('Andamento'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.verified),
            title: const Text('Análise'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.engineering),
            title: const Text('Equipe'),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.TEAM_FORM);
            },
          ),
        ],
      ),
    );
  }
}