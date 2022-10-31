
import 'package:control/models/evaluation.dart';
import 'package:control/models/location.dart';
import 'package:control/models/method.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

import '../models/item.dart';
import '../models/obra.dart';
import '../models/stage.dart';
import '../models/team.dart';

class DB {
  static Future<sql.Database> database() async {
    int version = 2;
    final dbPath = await sql.getDatabasesPath();

    var database;

    if(await sql.databaseExists(dbPath)){
      database = await sql.openDatabase(dbPath);

      if(await database.getVersion() < version){ //here is an error because this function doesnt really do anything
        await sql.deleteDatabase(dbPath);
        
        database = await sql.openDatabase(
          path.join(dbPath, 'teste66.db'),
          onCreate:  (db, version) async {
            await db.execute('CREATE TABLE IF NOT EXISTS obras(id TEXT PRIMARY KEY, address TEXT, name TEXT, owner TEXT, engineer TEXT, isComplete INT, isUpdated INT, isDeleted INT, needFirebase INT)');
            await db.execute('CREATE TABLE IF NOT EXISTS stages (id TEXT PRIMARY KEY, stage TEXT, matchmakingId TEXT, isDeleted INT, isUpdated INT, isComplete INT, needFirebase INT )');
            await db.execute('CREATE TABLE IF NOT EXISTS method (id TEXT PRIMARY KEY, tolerance TEXT, method TEXT, item TEXT, team TEXT, matchmakingId TEXT, isMethodGood INT, isUpdated INT, isDeleted INT, isComplete INT, needFirebase INT)');
            await db.execute('CREATE TABLE IF NOT EXISTS items (id TEXT PRIMARY KEY, item TEXT, description TEXT, endingDate TEXT, beginningDate TEXT, matchmakingId TEXT, isGood INT, isUpdated INT, isDeleted INT, isComplete INT, needFirebase INT)');
            await db.execute('CREATE TABLE IF NOT EXISTS evaluation (id TEXT PRIMARY KEY, error TEXT, image TEXT, team TEXT, methodName TEXT, toleranceName TEXT, isEPI INT, isOrganized INT, isProductive INT, evaluationDate TEXT, matchmakingId TEXT, locationId TEXT, isUpdated INT, isDeleted INT, needFirebase INT)');
            await db.execute('CREATE TABLE IF NOT EXISTS location (id TEXT PRIMARY KEY, location TEXT, matchmakingId TEXT, isUpdated INT, isDeleted INT, needFirebase INT)');
            await db.execute('CREATE TABLE IF NOT EXISTS teams (id TEXT PRIMARY KEY, team TEXT, matchmakingId TEXT, isDeleted INT, isUpdated INT, needFirebase INT )');
          },
          version: version,
        );
      }
      return database;
    }
    //teste51 eh a versao atual da griselda
    database = sql.openDatabase(
      path.join(dbPath, 'teste66.db'),
      onCreate:  (db, version) async {
        await db.execute('CREATE TABLE obras (id TEXT PRIMARY KEY, address TEXT, name TEXT, owner TEXT, engineer TEXT, isComplete INT, isUpdated INT, isDeleted INT, needFirebase INT)');
        await db.execute('CREATE TABLE stages (id TEXT PRIMARY KEY, stage TEXT, matchmakingId TEXT, isDeleted INT, isUpdated INT, isComplete INT, needFirebase INT )');
        await db.execute('CREATE TABLE method (id TEXT PRIMARY KEY, tolerance TEXT, method TEXT, item TEXT, team TEXT, matchmakingId TEXT, isMethodGood INT, isUpdated INT, isDeleted INT, isComplete INT, needFirebase INT)');
        await db.execute('CREATE TABLE items (id TEXT PRIMARY KEY, item TEXT, description TEXT, endingDate TEXT, beginningDate TEXT, matchmakingId TEXT, isGood INT, isUpdated INT, isDeleted INT, isComplete INT, needFirebase INT)');
        await db.execute('CREATE TABLE evaluation (id TEXT PRIMARY KEY, error TEXT, image TEXT, team TEXT, methodName TEXT, toleranceName TEXT, isEPI INT, isOrganized INT, isProductive INT, evaluationDate TEXT, matchmakingId TEXT, locationId TEXT, isUpdated INT, isDeleted INT, needFirebase INT)'); 
        await db.execute('CREATE TABLE location (id TEXT PRIMARY KEY, location TEXT, matchmakingId TEXT, isUpdated INT, isDeleted INT, needFirebase INT)');
        await db.execute('CREATE TABLE teams (id TEXT PRIMARY KEY, team TEXT, matchmakingId TEXT, isDeleted INT, isUpdated INT, needFirebase INT )');
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

  static getEvaluationsFromDB() async{
    final db = await DB.database();

    List<Evaluation> evaluations = [];

    List data = await db.query('evaluation');

    if(data.isNotEmpty){
      evaluations = data.map((e) => Evaluation.fromSQLMap(e)).toList();
      return evaluations;
    }
    else{
      return evaluations;
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

  static getMethodsFromDB() async{
    final db = await DB.database();

    List<Method> methods = [];

    List data = await db.query('method');

    if(data.isNotEmpty){
      methods = data.map((e) => Method.fromSQLMap(e)).toList();
      return methods;
    }
    else{
      return methods;
    }
  }

  static getLocationFromDB() async{
    final db = await DB.database();

    List<Location> location = [];

    List data = await db.query('location');

    if(data.isNotEmpty){
      location = data.map((e) => Location.fromSQLMap(e)).toList();
      return location;
    }
    else{
      return location;
    }
  }


  static getTeamFromDB() async{
    final db = await DB.database();

    List<Team> teams = [];

    List data = await db.query('teams');

    if(data.isNotEmpty){
      teams = data.map((e) => Team.fromSQLMap(e)).toList();
      return teams;
    }
    else{
      return teams;
    }
  }

  static deleteDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    await sql.deleteDatabase(dbPath);

  }

  static deleteInfo(String table, String id) async {
    final db = await DB.database();
    await db.delete(table, where: "id = ?", whereArgs: [id]);
  }

  static updateInfo(String table, String id, Map<String, dynamic> result) async{
    final db = await DB.database();

    await db.update(table, result, where: 'id = ?', whereArgs: [id]);
  }


}