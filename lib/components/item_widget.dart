import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


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
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('Test'),
            //subtitle: Text(
              //DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date),
            //),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          // if (_expanded)
          //   Container(
          //     padding: const EdgeInsets.symmetric(
          //       horizontal: 15,
          //       vertical: 4,
          //     ),
          //     height: (widget.order.products.length * 25) + 10,
          //     child: ListView(
          //       children: widget.order.products.map(
          //         (product) {
          //           return Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text(
          //                 product.name,
          //                 style: TextStyle(
          //                   fontSize: 18,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               Text(
          //                 '${product.quantity}x R\$ ${product.price}',
          //                 style: TextStyle(
          //                   fontSize: 18,
          //                   color: Colors.grey,
          //                 ),
          //               ),
          //             ],
          //           );
          //         },
          //       ).toList(),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
