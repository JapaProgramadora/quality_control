// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:control/components/location_item.dart';
import 'package:control/models/location.dart';
import 'package:control/models/location_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationGrid extends StatelessWidget {
  final String matchmakingId;
  const LocationGrid({ Key? key, required this.matchmakingId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocationList>(context);
    final List<Location> loadedLocations = provider.getAllItems(matchmakingId);
    
    return ListView.builder(
      shrinkWrap: true,
      itemCount: loadedLocations.length,
      itemBuilder: (ctx,i) => ChangeNotifierProvider.value(
        value: loadedLocations[i],
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300 , width: 1),
            borderRadius: BorderRadius.circular(6)
          ),
          child: LocationItem(matchmakingId)
        ),
      ),
    );
  }
}