
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
          'CREATE TABLE obras(id TEXT PRIMARY KEY, address TEXT, name TEXT, owner TEXT,engineer TEXT)'
        );
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DB.database();
    await db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static readDatabase() async{
    final db = await DB.database();
    print('this is from readDatabase');
    List data = await db.rawQuery('SELECT * FROM obras');

    print(data);
    print(data.where((data) => data['id'] == '0.9654619751084338')); 
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