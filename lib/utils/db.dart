
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

import '../models/item.dart';
import '../models/obra.dart';
import '../models/stage.dart';

class DB {
  static Future<sql.Database> database() async {
    int version = 1;
    final dbPath = await sql.getDatabasesPath();

    var database;
    //await sql.deleteDatabase(dbPath);

    if(await sql.databaseExists(dbPath)){
      database = await sql.openDatabase(dbPath);

      if(await database.getVersion() < version){
        await sql.deleteDatabase(dbPath);
        
        database = await sql.openDatabase(
          path.join(dbPath, 'teste16.db'),
          onCreate:  (db, version) async {
            await db.execute('CREATE TABLE IF NOT EXISTS obras(id TEXT PRIMARY KEY, address TEXT, name TEXT, owner TEXT, engineer TEXT, isIncomplete INT, isUpdated INT)');
            await db.execute('CREATE TABLE IF NOT EXISTS stages(id TEXT PRIMARY KEY, stage TEXT, matchmakingId TEXT, isDeleted INT, isUpdated INT)');
            await db.execute('CREATE TABLE IF NOT EXISTS method(id TEXT PRIMARY KEY, tolerance TEXT, method TEXT, team TEXT, matchmakingId TEXT, isTeamGood INT, isUpdated INT, isDeleted INT)');
            await db.execute('CREATE TABLE items (id TEXT PRIMARY KEY, item TEXT, description TEXT, endingDate TEXT, beginningDate TEXT, matchmakingId TEXT, isGood INT, isUpdated INT, isDeleted INT)');
          },
          version: version,
        );
      }
      return database;
    }

    database = sql.openDatabase(
      path.join(dbPath, 'teste16.db'),
      onCreate:  (db, version) async {
        await db.execute('CREATE TABLE obras (id TEXT PRIMARY KEY, address TEXT, name TEXT, owner TEXT, engineer TEXT, isIncomplete INT, isUpdated INT)');
        await db.execute('CREATE TABLE stages (id TEXT PRIMARY KEY, stage TEXT, matchmakingId TEXT, isDeleted INT, isUpdated INT)');
        await db.execute('CREATE TABLE method (id TEXT PRIMARY KEY, tolerance TEXT, method TEXT, team TEXT, matchmakingId TEXT, isTeamGood INT, isUpdated INT, isDeleted INT)');
        await db.execute('CREATE TABLE items (id TEXT PRIMARY KEY, item TEXT, description TEXT, endingDate TEXT, beginningDate TEXT, matchmakingId TEXT, isGood INT, isUpdated INT, isDeleted INT)');
      },
      version: version,
    );
    return database;
  }

  static Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await DB.database();
    await db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }


  static getObrasFromDB(String table) async{
    final db = await DB.database();

    List<Obra> obras = [];

    List data = await db.query(table);

    if(data.isNotEmpty){
      obras = data.map((e) => Obra.fromSQLMap(e)).toList();
      return obras;
    }
    else{
      return obras;
    }
  }

  static getStagesFromDb(String table) async{
    final db = await DB.database();

    List<Stage> stages = [];

    List data = await db.query(table);

    if(data.isNotEmpty){
      stages = data.map((e) => Stage.fromSQLMap(e)).toList();
      return stages;
    }
    else{
      return stages;
    }
  }

  static getItemsFromDB(String table) async{
    final db = await DB.database();

    List<Items> items = [];

    List data = await db.query(table);

    if(data.isNotEmpty){
      items = data.map((e) => Items.fromSQLMap(e)).toList();
      return items;
    }
    else{
      return items;
    }
  }

  static deleteDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    await sql.deleteDatabase(dbPath);

  }

  static deleteObra(Obra obra) async {
    final db = await DB.database();
    await db.delete("obras", where: "id = ?", whereArgs: [obra.id]);
  }

  static deleteStage(Stage stage) async {
    final db = await DB.database();
    await db.delete("stages", where: "id = ?", whereArgs: [stage.id]);
  }

  static updateObra(Obra obra) async{
    final db = await DB.database();

    var result = obra.toMapSQL();
    await db.update('obras', result, where: 'id = ?', whereArgs: [obra.id]);
  }
  

}