// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../components/image_input.dart';

// class PlaceFormScreen extends StatefulWidget {
//   const PlaceFormScreen({Key? key}) : super(key: key);

//   @override
//   State<PlaceFormScreen> createState() => _PlaceFormScreenState();
// }

// class _PlaceFormScreenState extends State<PlaceFormScreen> {
//   final _titleController = TextEditingController();
//   File? _pickedImage;

//   void _selectImage(File pickedImage) {
//     _pickedImage = pickedImage;
//   }

//   void _submitForm() {
//     if (_titleController.text.isEmpty || _pickedImage == null) {
//       return;
//     }

//     Provider.of<GreatPlaces>(context, listen: false).addPlace(
//       _titleController.text,
//       _pickedImage!,
//     );

//     Navigator.of(context).pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Novo Lugar'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Column(
//                   children: [
//                     TextField(
//                       controller: _titleController,
//                       decoration: const InputDecoration(
//                         labelText: 'Título',
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     ImageInput(_selectImage),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           ElevatedButton.icon(
//             icon: const Icon(Icons.add),
//             label: const Text('Adicionar'),
//             style: ElevatedButton.styleFrom(
//               elevation: 0,
//               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//             ),
//             onPressed: _submitForm,
//           ),
//         ],
//       ),
//     );
//   }
// }
