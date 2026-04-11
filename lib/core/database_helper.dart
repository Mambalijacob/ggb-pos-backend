import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  static Future<Database> initDb() async {
    final path = join(await getDatabasesPath(), 'pos.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE sales(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            item TEXT,
            qty INTEGER,
            price REAL,
            synced INTEGER
          )
        ''');
      },
    );
  }

  static Future<void> insertSale(Map<String, dynamic> sale) async {
    final dbClient = await db;
    await dbClient.insert("sales", sale);
  }

  static Future<List<Map<String, dynamic>>> getUnsynced() async {
    final dbClient = await db;
    return dbClient.query("sales", where: "synced = 0");
  }

  static Future<void> markSynced(int id) async {
    final dbClient = await db;
    await dbClient.update("sales", {"synced": 1},
        where: "id = ?", whereArgs: [id]);
  }
}