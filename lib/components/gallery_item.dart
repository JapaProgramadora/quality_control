
// ignore_for_file: use_key_in_widget_constructors

import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:control/models/evaluation.dart';
import 'package:control/models/obra_list.dart';
import 'package:control/utils/app_routes.dart';
import 'package:control/utils/cache.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/method_list.dart';
import '../models/obra.dart';
import '../validation/connectivity.dart';

//ImagePicker()
class GalleryItem extends StatefulWidget {
  final String hasInternet;

  const GalleryItem({
    Key? key,
    required this.hasInternet,
  }) : super(key: key);

  @override
  State<GalleryItem> createState() => _GalleryItemState();
}

class _GalleryItemState extends State<GalleryItem> {

  @override
  Widget build(BuildContext context){
    final evaluation = Provider.of<Evaluation>(context);

    return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: InkWell(
            onTap: () async {
              String hasInternet = await Cache().getHasInternet();
              Navigator.of(context).pushNamed(AppRoutes.EVALUATION_DETAIL, 
                arguments: {
                  'evaluation': evaluation,
                  'hasInternet': hasInternet,
                }
              );
            },
            child: GridTile(
              child: GestureDetector(
                child: Stack(
                  children: [ 
                      SizedBox(
                        height: 250,
                        width: double.infinity,
                        child: widget.hasInternet == 'yes'? 
                          Image.network(
                            evaluation.image,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
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
          ),
    );
  }
}