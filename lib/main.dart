
// ignore_for_file: equal_keys_in_map

import 'package:control/models/errorMethod_list.dart';
import 'package:control/models/location_list.dart';
import 'package:control/models/method_list.dart';
import 'package:control/models/obra_list.dart';
import 'package:control/models/item_list.dart';
import 'package:control/screens/home_screen.dart';
import 'package:control/screens/location_form_screen.dart';
import 'package:control/screens/location_screen.dart';
import 'package:control/screens/obra_form_screen.dart';
import 'package:control/screens/obra_stages_screen.dart';
import 'package:control/screens/method_form.dart';
import 'package:control/screens/stage_form_screen.dart';
import 'package:control/screens/item_form.dart';
import 'package:control/screens/item_screen.dart';
import 'package:control/screens/verification_display_screen.dart';
import 'package:control/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/stage_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ObraList()),
        ChangeNotifierProvider(create: (_) => ItemList()),
        ChangeNotifierProvider(create: (_) => StageList()),
        ChangeNotifierProvider(create: (_) => ErrorMethodList()),
        ChangeNotifierProvider(create: (_) => LocationList()),
        ChangeNotifierProvider(create: (_) => MethodList()),
      ],
      child: MaterialApp(
        title: 'Controle de Qualidade',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),        
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.OBRA_FORM_SCREEN: (ctx) => const ObraFormPage(),
          AppRoutes.OBRA_STAGES_SCREEN: (ctx) => const ObraStagesScreen(),
          AppRoutes.STAGES_FORM_SCREEN: (ctx) => const StageFormScreen(),
          AppRoutes.ITEM_SCREEN: (ctx) => const ItemScreen(),
          AppRoutes.ITEM_FORM_SCREEN: (ctx) => const ItemForm(),
          AppRoutes.OBRA_LOCATION_SCREEN: (ctx) => const LocationScreen(),
          AppRoutes.LOCATION_FORM_SCREEN: (ctx) => const LocationForm(),
          AppRoutes.METHOD_FORM_SCREEN: (ctx) => const MethodForm(),
          AppRoutes.VERIFICATION_DISPLAY_SCREEN: (ctx) => const VerificationDisplayScreen(),
        },
      ),
    );
  }
}
