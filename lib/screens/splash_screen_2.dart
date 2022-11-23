// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:control/models/obra_list.dart';
import 'package:control/models/stage_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../utils/app_routes.dart';
import '../validation/connectivity.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 3), (timer) {
     });

    Timer.run(() async => await onLoad());
  }

  Future onLoad() async {
    if(await hasInternetConnection()){
      await Firebase.initializeApp();
      await Provider.of<ObraList>(context, listen: false).loadProducts();
      // await Provider.of<ObraList>(context, listen: false).checkData();
      // await Provider.of<ObraList>(context, listen: false).checkUpdate();
      await Future.delayed(const Duration(milliseconds: 1500), () {
        Navigator.pushReplacementNamed(context, AppRoutes.OBRA_SCREEN);
      });
    }
    else{ 
      await Future.delayed(const Duration(milliseconds: 1500), () {
        Navigator.pushReplacementNamed(context, AppRoutes.OBRA_SCREEN);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 65, 134, 190),
              Color.fromARGB(255, 0, 96, 173),
            ]
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(
              Icons.house,
              size: 70,
              color: Colors.white,
            ),
            SizedBox(height: 30,),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}