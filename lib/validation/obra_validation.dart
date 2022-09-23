
import 'dart:convert';

import '../utils/constants.dart';
import '../utils/db.dart';
import '../models/obra.dart';
import 'package:http/http.dart' as http;


List<Obra> _items = [];

Future<void> loadObras() async {
    _items.clear();

    final response = await http.get(
      Uri.parse('${Constants.PRODUCT_BASE_URL}.json'),
    );

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      _items.add(
        Obra(
          id: productId,
          name: productData['name'],
          engineer: productData['engineer'],
          address: productData['address'],
          owner: productData['owner'],
        ),
      );
    });
}


Future<List<Obra>> missingFirebaseObras() async {
    final List<Obra> loadedObra = await DB.getObrasFromDB();
    final List<Obra> matchingItems = [];
    final List<Obra> notMatchingItems = [];

    if(loadedObra.isEmpty){
      return [];
    }

    await loadObras();

    print('estes são os itens');
    print(_items);
    if(_items.isEmpty){
      return loadedObra;
    }

    loadedObra.forEach((obra) {
      _items.forEach((item) {
        if(obra.id == item.id){
          if(!matchingItems.contains(obra)){
            matchingItems.add(obra);
          }
        }else{
          if(!notMatchingItems.contains(obra)){
            notMatchingItems.add(obra);
          }
        }
      });
    });
  
  
    print('estas são as obras');
    print(loadedObra.toString());

    notMatchingItems.removeWhere((element) => matchingItems.contains(element));
    print(notMatchingItems);

    return notMatchingItems;
}