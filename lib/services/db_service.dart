import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBService {
  static Database? _db;

  static Future<Database> init() async {
    if (_db != null) return _db!;

    final path = join(await getDatabasesPath(), 'pos.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, v) async {
        await db.execute('''
          CREATE TABLE cart(
            id INTEGER PRIMARY KEY,
            name TEXT,
            price REAL,
            quantity INTEGER
          )
        ''');
      },
    );

    return _db!;
  }
}
