// import 'package:control/components/location_grid.dart';
// import 'package:control/models/location_list.dart';
// import 'package:control/utils/app_routes.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';


// class LocationScreen extends StatefulWidget {

//   const LocationScreen({ Key? key}) : super(key: key);

//   @override
//   State<LocationScreen> createState() => _LocationScreenState();
// }

// class _LocationScreenState extends State<LocationScreen> {
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     Provider.of<LocationList>(
//       context,
//       listen: false,
//     ).loadLocation().then((value) {
//       setState(() {
//        _isLoading = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final id = ModalRoute.of(context)!.settings.arguments;

//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.purple.shade900,
//         title: const Text('Local'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.of(context).pushNamed(AppRoutes.LOCATION_FORM_SCREEN, arguments: id); //change this
//             },
//             icon: const Icon(Icons.add),
//           ),
//         ],
//       ),
//       body: LocationGrid(id.toString()),
//     );
//   }
// }