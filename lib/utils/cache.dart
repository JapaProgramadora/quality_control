
import 'package:shared_preferences/shared_preferences.dart';


class Cache {
  static final String obraId = 'obraId';
  //static final String cacheObra = 'cacheObra';

  Future<bool> setObraId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool result = await prefs.setString(obraId, id);
    
    return result;
  }

  Future<String> getObraId() async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var result = prefs.getString(obraId);
      print(result.toString());

      if(result != null){
        return result.toString();
      }
    }
    catch(err){
      print(err);
    }
    return 'null';
  }

  // Future<bool> setUserInfo(Obra obra) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   bool result = await prefs.setString(cacheObra, obra.toJson());

  //   return result;
  // }

  // Future<Obra?> getUserInfo() async {
  //   try{
  //     SharedPreferences prefs = await SharedPreferences.getInstance();

  //     var result = await prefs.getString(userInfo);

  //     if(result != null){
  //       return Obra.fromJson(result);
  //     }
  //   }
  //   catch(err){
  //     print(err);
  //   }
  //   return null;
  // }
}
