// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:control/components/location_item.dart';
import 'package:control/models/location.dart';
import 'package:control/models/location_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationGrid extends StatelessWidget {
  final String matchmakingId;
  
  LocationGrid(this.matchmakingId);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocationList>(context);
    final List<Location> loadedLocations = provider.testItems(matchmakingId);
    
    return Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: loadedLocations.length,
          itemBuilder: (ctx,i) => ChangeNotifierProvider.value(
            value: loadedLocations[i],
            child: LocationItem(),
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10, //espaçamento
            mainAxisSpacing: 10, //espaçamento
            crossAxisCount: 2, //exibe 2 produtos por linha
          ),
        ),
    );
  }
}