
// ignore_for_file: equal_keys_in_map

import 'package:control/models/base_list.dart';
import 'package:control/models/evaluation_list.dart';
import 'package:control/models/item_list.dart';
import 'package:control/models/location_list.dart';
import 'package:control/models/method_list.dart';
import 'package:control/models/obra_list.dart';
import 'package:control/models/team_list.dart';
import 'package:control/screens/evaluation_screen2.dart';
import 'package:control/screens/obra_screen.dart';
import 'package:control/screens/item_form.dart';
import 'package:control/screens/location_form_screen.dart';
import 'package:control/screens/location_screen.dart';
import 'package:control/screens/method_form.dart';
import 'package:control/screens/splash_screen_2.dart';
import 'package:control/screens/tabs_screen.dart';
import 'package:control/screens/obra_form_screen.dart';
import 'package:control/screens/obra_stages_screen.dart';
import 'package:control/screens/stage_form_screen.dart';
import 'package:control/screens/team_form.dart';
import 'package:control/screens/teams_screen.dart';
import 'package:control/utils/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/stage_list.dart';
import 'screens/evaluation_detail_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        ChangeNotifierProvider(create: (_) => EvaluationList()),
        ChangeNotifierProvider(create: (_) => LocationList()),
        ChangeNotifierProvider(create: (_) => MethodList()),
        ChangeNotifierProvider(create: (_) => TeamList()),
        ChangeNotifierProvider(create: (_) => BaseList()),
      ],
      child: MaterialApp(
        title: 'Controle de Qualidade',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),        
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.OBRA_SCREEN: (ctx) => const ObraScreen(),
          AppRoutes.OBRA_FORM_SCREEN: (ctx) => const ObraFormPage(),
          AppRoutes.OBRA_STAGES_SCREEN: (ctx) => const ObraStagesScreen(),
          AppRoutes.STAGES_FORM_SCREEN: (ctx) => const StageFormScreen(),
          AppRoutes.EVALUATION_DETAIL: (ctx) => const EvaluationDetailScreen(),
          AppRoutes.ITEM_FORM_SCREEN: (ctx) => const ItemForm(),
          AppRoutes.LOCATION_FORM_SCREEN: (ctx) => const LocationForm(),
          AppRoutes.LOCATION_SCREEN: (ctx) => const LocationScreen(),
          AppRoutes.TEAM_FORM: (ctx) => const TeamForm(),
          AppRoutes.METHOD_FORM_SCREEN: (ctx) => const MethodForm(),
          AppRoutes.VERIFICATION_DISPLAY_SCREEN: (ctx) => const EvaluationScreen2(),
          AppRoutes.TEAM_SCREEN: (ctx) => const TeamScreen(),
          AppRoutes.TAB_SCREEN: (ctx) => const TabScreen(),
        },
      ),
    );
  }
}
