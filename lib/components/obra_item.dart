
// ignore_for_file: use_key_in_widget_constructors

import 'package:control/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/obra.dart';

//ImagePicker()
class ObraItem extends StatefulWidget {

  @override
  State<ObraItem> createState() => _ObraItemState();
}

class _ObraItemState extends State<ObraItem> {
  @override
  Widget build(BuildContext context){
    final obras = Provider.of<Obra>(context, listen: false);


    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(AppRoutes.OBRA_STAGES_SCREEN, arguments: obras);
        },
        child: Container(
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient( 
              colors: [
                Color.fromARGB(255, 159, 210, 219),
                Color.fromARGB(255, 6, 85, 68).withOpacity(0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 300,
              left: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  obras.name,
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                  const Icon(Icons.house, color: Colors.white,),
                  const Padding(padding: EdgeInsets.only(left: 5)),
                    Text(
                      obras.address,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                  Icon(Icons.engineering, color: Colors.white,),
                  Padding(padding: EdgeInsets.only(left: 5)),
                  Text(
                      obras.engineer,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}