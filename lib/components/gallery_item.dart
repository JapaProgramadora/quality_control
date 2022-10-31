
// ignore_for_file: use_key_in_widget_constructors

import 'dart:io';

import 'package:control/models/evaluation.dart';
import 'package:control/models/obra_list.dart';
import 'package:control/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/obra.dart';

//ImagePicker()
class GalleryItem extends StatefulWidget {

  @override
  State<GalleryItem> createState() => _GalleryItemState();
}

class _GalleryItemState extends State<GalleryItem> {
  @override
  Widget build(BuildContext context){
    final evaluation = Provider.of<Evaluation>(context, listen: false);

    return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: GridTile(
            child: GestureDetector(
              child: Stack(
                children: [ 
                  SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: Image.file(
                      File(evaluation.image),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ]
              ),
            ),
            footer: GridTileBar(
              title: Text(
                evaluation.team, 
                textAlign: TextAlign.center, 
                style: const TextStyle(
                  fontSize: 15
                ),
              ),
              backgroundColor: Colors.black54,
            ),
          ),
    );
  }
}