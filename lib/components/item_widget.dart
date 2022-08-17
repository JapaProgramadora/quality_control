import 'package:control/components/method_grid.dart';
import 'package:control/models/stage_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';




class ItemWidget extends StatefulWidget {

  const ItemWidget({
    Key? key,
  }) : super(key: key);

  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  bool _expanded = false;
  

  @override
  Widget build(BuildContext context) {
    final item = Provider.of<Items>(context, listen: false);

    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(item.item),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(item.date),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              height: (7 * 25) + 10,
              child: MethodGrid(matchmakingId: item.id),
                // ListView(
                // shrinkWrap: true,
                // children: [
                //     // IconButton(onPressed: () {
                //     //     Navigator.of(context).pushNamed(AppRoutes.METHOD_FORM_SCREEN, arguments: item.id);
                //     //   }, 
                //     //   icon: const Icon(Icons.add)
                //     // ),

                //   ] 
                // ),
              ),
        ],
      ),
    );
  }
}
