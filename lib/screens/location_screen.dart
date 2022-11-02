import 'package:control/components/location_grid.dart';
import 'package:control/models/location_list.dart';
import 'package:control/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/obra.dart';
import '../models/obra_list.dart';


class LocationScreen extends StatefulWidget {

  const LocationScreen({ Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool _isLoading = true;
  String? obraValue = '';

  @override
  void initState() {
    super.initState();
    Provider.of<LocationList>(
      context,
      listen: false,
    ).loadLocation().then((value) {
      setState(() {
       _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final matchId = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 153, 105, 212),
        title: const Text('Ambientes'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 175, 102, 197),
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.LOCATION_FORM_SCREEN, arguments: matchId);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: _isLoading
      ? const Center(
        child: CircularProgressIndicator(),
      )
      : SizedBox(
            height: 450,
            child: LocationGrid(matchmakingId: matchId)
      ),

      );
  }
}