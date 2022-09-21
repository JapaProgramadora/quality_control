
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

import '../models/obra.dart';


class DB {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'quality.db'),
      onCreate:  (db, version) {
        return db.execute(
          'CREATE TABLE IF NOT EXISTS obras (id TEXT PRIMARY KEY, address TEXT, name TEXT, owner TEXT, engineer TEXT, isIncomplete INT)'
        );
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DB.database();
    await db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Obra>> read() async {
    final db = await DB.database();
    if(db == null){
      return [];
    }
    try {
      final data = await db.rawQuery('SELECT * FROM obras');
      final obra = data.map((info) => Obra.fromDatabase(info)).toList();
      return obra;
    }catch(err){
      print(err);
    }
    return [];
  }

  static readDatabase() async{
    final db = await DB.database();
    print('this is from readDatabase');
    List data = await db.rawQuery('SELECT * FROM obras');

    print(data);

  }
  // _onCreate(db, versao) async {
  //   await db.execute(_obras);
    

  //   String get _obras => '''
  //     CREATE TABLE obras (
  //       id INTEGER PRIMARY KEY, 
  //       isDeleted INTEGER, 
  //       address TEXT,
  //       name TEXT,
  //       owner TEXT,
  //       engineer TEXT,
  //       isIncomplete INTEGER, 
  //     );
  //   ''';
  // }
}