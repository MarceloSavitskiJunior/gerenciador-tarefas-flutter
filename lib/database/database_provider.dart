
import 'package:sqflite/sqflite.dart';

import '../model/task.dart';

class DatabaseProvider{
  static const _dbName = 'cadastro_tarefas.db';
  static const _dbVersion = 1;

  DatabaseProvider.int();

  static final DatabaseProvider instace = DatabaseProvider.int();

  Database? _database;

  Future<Database> get database async {
    if (_database == null){
      _database = await _initDatabase();
    }
    return _database!;
  }

  Future<Database> _initDatabase() async{
    String databasePath = await getDatabasesPath();
    String dbPath = '$databasePath/$_dbName';
    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void>_onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE ${Task.TABLE_NAME} (
      ${Task.ID} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${Task.DESCRIPTION} TEXT NOT NULL,
      ${Task.DELIVERY_AT} TEXT
      );
      '''
    );
  }

  Future<void>_onUpgrade(Database db, int oldVersion, int newVersion) async {

  }

  Future<void> close() async{
    if(_database != null){
      await _database!.close();
    }
  }

}









