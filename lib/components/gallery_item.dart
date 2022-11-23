
// ignore_for_file: use_key_in_widget_constructors

import 'dart:io';

import 'package:control/models/evaluation.dart';
import 'package:control/models/evaluation_list.dart';
import 'package:control/utils/app_routes.dart';
import 'package:control/utils/cache.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';


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

    print(hash(evaluation.id)%20);

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
                        child: evaluation.image == ''
                        ? Container(color: const Color.fromARGB(255, 35, 150, 179),) 
                        : widget.hasInternet == 'yes'? 
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
                  evaluation.methodName, 
                  textAlign: TextAlign.center, 
                  style: const TextStyle(
                    fontSize: 15
                  ),
                ),
                backgroundColor: Colors.black54,
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                  onPressed: () {
                    showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Excluir Avaliação?'),
                        content: const Text('Tem certeza?'),
                        actions: [
                          TextButton(
                            child: const Text('Não'),
                            onPressed: () => Navigator.of(ctx).pop(false),
                          ),
                          TextButton(
                            child: const Text('Sim'),
                            onPressed: () => Navigator.of(ctx).pop(true),
                          ),
                        ],
                      ),
                    ).then((value) async {
                      if (value ?? false){
                        await Provider.of<EvaluationList>(context, listen: false).removeEvaluation(evaluation);
                      }
                    });
                  },
                ),
              ),
            ),
          ),
    );
  }
}