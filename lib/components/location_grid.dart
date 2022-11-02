import 'package:control/components/location_item.dart';
import 'package:control/components/stage_item.dart';
import 'package:control/models/location.dart';
import 'package:control/models/location_list.dart';
import 'package:control/models/team_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/stage.dart';
import '../models/stage_list.dart';
import '../models/team.dart';
import 'team_item.dart';

class LocationGrid extends StatefulWidget {
  final String matchmakingId;
  const LocationGrid({ Key? key, required this.matchmakingId}) : super(key: key);

  @override
  State<LocationGrid> createState() => _LocationGridState();
}

class _LocationGridState extends State<LocationGrid> {

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocationList>(context);
    final List<Location> locations = provider.getAllItems(widget.matchmakingId);
    
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: locations.length,
          itemBuilder: (ctx,i) => ChangeNotifierProvider.value(
            value: locations[i],
            child: const Padding(
              padding: EdgeInsets.only(top: 5),
              child: LocationItem(),
            ),
          ),
        ),
    );
  }
}