
// ignore_for_file: use_key_in_widget_constructors

import 'package:control/models/obra_list.dart';
import 'package:control/models/stage_list.dart';
import 'package:control/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../models/obra.dart';

enum FilterOptions {
  editar,
  deletar,
  adicionar,
}

//ImagePicker()
class ObraItem extends StatefulWidget {

  @override
  State<ObraItem> createState() => _ObraItemState();
}

class _ObraItemState extends State<ObraItem> {
  double percentage = 0.0;

  @override
  Widget build(BuildContext context){
    final obras = Provider.of<Obra>(context, listen: false);

    final stages = Provider.of<StageList>(context).allMatchingStages(obras.id);

    if(stages.isNotEmpty){
      int finished = 0;
      int pending = 0;
      double percent = 0;
      for(var stage in stages){
        if(stage.isComplete == true){
          finished +=1;
        }else{
          pending += 1;
        }
      }
      int total = finished + pending;
      percent = finished / total;
      percentage = percent;
      // if(percentage*100.toInt() == 100){
      //   item.changeItemGood(true, item);
      // }
    }else{
      percentage = 0;
    }


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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30,
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(height: 5,),
                    PopupMenuButton(
                      icon: const Icon(
                        Icons.more_vert, 
                        color: Colors.white,
                        size: 30,
                      ),
                      itemBuilder:(_) => [
                        const PopupMenuItem(
                          child: Text('Adicionar ambientes'),
                          value: 'adicionar',
                        ),
                        const PopupMenuItem(
                          child: Text('Editar'),
                          value: 'editar',
                        ),
                        const PopupMenuItem(
                          child: Text('Deletar'),
                          value: 'deletar',
                        ),
                      ],
                      onSelected: (String selectedValue) {
                        if(selectedValue == 'adicionar'){
                          Navigator.of(context).pushNamed(AppRoutes.LOCATION_SCREEN, arguments: obras.id);
                        }else if(selectedValue == 'editar'){
                          Navigator.of(context).pushNamed(AppRoutes.OBRA_FORM_SCREEN, arguments: obras);
                        }else{
                          showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Excluir Obra?'),
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
                              await Provider.of<ObraList>(context, listen: false).removeProduct(obras);
                            }
                          });
                        }
                      }
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 50, left: 15),
                child: CircularPercentIndicator(
                  radius: 85,
                  circularStrokeCap: CircularStrokeCap.round,
                  lineWidth: 25,
                  progressColor: Color.fromARGB(255, 79, 95, 240),
                  percent: percentage,
                  center: Text(
                    '${(percentage*100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  animation: true,
                  animationDuration: 500,
                )
              ),
              Container(
                padding: const EdgeInsets.only(top: 60,left: 10,),
                child: Column(
                  children: [
                    FittedBox(
                      fit: BoxFit.cover,
                      child: Text(
                        obras.name,
                        style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
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
            ],
          ),
        ),
      ),
    );
  }
}