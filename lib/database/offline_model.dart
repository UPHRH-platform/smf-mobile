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
      const String inspectionTable = AppDatabase.inspectionTable;

      await db.execute('''CREATE TABLE $applicationsTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            application_data TEXT
            )''');
      await db.execute('''CREATE TABLE $inspectionTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            inspection_data TEXT
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

  static Future<Map> getApplications(int userId) async {
    final db = await OfflineModel.database();
    List<dynamic> whereArgs = [userId];
    List<Map> rows = await db.query(AppDatabase.applicationsTable,
        where: 'user_id = ?', orderBy: 'id DESC', whereArgs: whereArgs);
    return rows[0];
  }

  static Future<void> deleteApplications(int userId) async {
    Database db = await OfflineModel.database();
    List<dynamic> whereArgs = [userId];
    await db.delete(AppDatabase.applicationsTable,
        where: 'user_id = ?', whereArgs: whereArgs);
  }

  static Future<void> saveInspection(Map<String, Object> data) async {
    final db = await OfflineModel.database();
    db.insert(
      AppDatabase.inspectionTable,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getInspections(int userId) async {
    final db = await OfflineModel.database();
    List<dynamic> whereArgs = [userId];
    return db.query(AppDatabase.inspectionTable,
        where: 'user_id = ?', whereArgs: whereArgs);
  }

  static Future<void> deleteInspections(int userId) async {
    Database db = await OfflineModel.database();
    List<dynamic> whereArgs = [userId];
    await db.delete(AppDatabase.inspectionTable,
        where: 'user_id = ?', whereArgs: whereArgs);
  }
}
