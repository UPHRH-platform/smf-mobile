import 'package:smf_mobile/constants/app_constants.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class OfflineModel {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, AppDatabase.name),
        onCreate: (db, version) async {
      const String applicationsTable = AppDatabase.applicationsTable;
      const String formsTable = AppDatabase.formsTable;
      const String inspectionTable = AppDatabase.inspectionTable;
      const String loginPinsTable = AppDatabase.loginPinsTable;

      await db.execute('''CREATE TABLE $applicationsTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username VARCHAR(64),
            application_data TEXT
            )''');
      await db.execute('''CREATE TABLE $formsTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username VARCHAR(64),
            form_data TEXT
            )''');
      await db.execute('''CREATE TABLE $inspectionTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            inspector_type CHECK( inspector_type IN ('${Inspector.leadInspector}','${Inspector.assistantInspector}') ),
            inspection_data TEXT
            )''');
      await db.execute('''CREATE TABLE $loginPinsTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username VARCHAR(64),
            pin VARCHAR(4)
            )''');
    }, version: 1);
  }

  static Future<void> saveApplications(Map<String, Object> data) async {
    final db = await OfflineModel.database();
    db.insert(
      AppDatabase.applicationsTable,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Map> getApplications(String username) async {
    final db = await OfflineModel.database();
    List<dynamic> whereArgs = [username];
    List<Map> rows = await db.query(AppDatabase.applicationsTable,
        where: 'username = ?', orderBy: 'id DESC', whereArgs: whereArgs);
    return rows[0];
  }

  static Future<void> deleteApplications(String username) async {
    Database db = await OfflineModel.database();
    List<dynamic> whereArgs = [username];
    await db.delete(AppDatabase.applicationsTable,
        where: 'username = ?', whereArgs: whereArgs);
  }

  static Future<void> saveForms(Map<String, Object> data) async {
    final db = await OfflineModel.database();
    db.insert(
      AppDatabase.formsTable,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Map> getForms(String username) async {
    final db = await OfflineModel.database();
    List<dynamic> whereArgs = [username];
    List<Map> rows = await db.query(AppDatabase.formsTable,
        where: 'username = ?', orderBy: 'id DESC', whereArgs: whereArgs);
    return rows[0];
  }

  static Future<void> deleteForms(String username) async {
    Database db = await OfflineModel.database();
    List<dynamic> whereArgs = [username];
    await db.delete(AppDatabase.formsTable,
        where: 'username = ?', whereArgs: whereArgs);
  }

  static Future<void> saveInspection(Map<String, Object> data) async {
    final db = await OfflineModel.database();
    db.insert(
      AppDatabase.inspectionTable,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getInspections() async {
    final db = await OfflineModel.database();
    return db.query(
      AppDatabase.inspectionTable,
    );
  }

  static Future<void> deleteInspections() async {
    Database db = await OfflineModel.database();
    await db.delete(
      AppDatabase.inspectionTable,
    );
  }

  static Future<void> savePin(Map<String, Object> data) async {
    final db = await OfflineModel.database();
    db.insert(
      AppDatabase.loginPinsTable,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deletePin(String username) async {
    Database db = await OfflineModel.database();
    List<dynamic> whereArgs = [username];
    await db.delete(AppDatabase.loginPinsTable,
        where: 'username = ?', whereArgs: whereArgs);
  }

  static Future<Map> getPinDetails(String username, String pin) async {
    final db = await OfflineModel.database();
    List<dynamic> whereArgs = [username, pin];
    List<Map> rows = await db.query(AppDatabase.loginPinsTable,
        where: 'username = ? AND pin = ?',
        orderBy: 'id DESC',
        whereArgs: whereArgs);
    return rows.isNotEmpty ? rows[0] : {};
  }
}
