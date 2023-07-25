import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uacademy_db/data/models/cached_user_model.dart';

class LocalDatabase {
  /// Singleton patern
  LocalDatabase._init();
  static final LocalDatabase getInstance = LocalDatabase._init();
  factory LocalDatabase() {
    return getInstance;
  }

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB("users.db");
      return _database!;
    }
  }

  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return await openDatabase(path, version: 1, onCreate: (db, ver) async {
      const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
      const textType = "TEXT NOT NULL";
      const intType = "INTEGER DEFAULT 0";
      const boolType = 'BOOLEAN NOT NULL';

      await db.execute('''
    CREATE TABLE $userTable (
    ${CachedUsersFields.id} $idType,
    ${CachedUsersFields.userName} $textType,
    ${CachedUsersFields.age} $intType
    )
    ''');
    });
  }

  //----------------------------- Cached Users Table ---------------------------

  //--------------------------------- Create Users --------------------------------
  static Future<CachedUser> insertCachedUser(CachedUser cachedUser) async {
    final db = await getInstance.database;
    final id = await db.insert(userTable, cachedUser.toJson());
    return cachedUser.copyWith(id: id);
  }

  //------------------------------ Read Users By ID -----------------------------
  static Future<CachedUser> getSingleUserById(int id) async {
    final db = await getInstance.database;
    final results = await db.query(
      userTable,
      columns: CachedUsersFields.values,
      where: '${CachedUsersFields.id} = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return CachedUser.fromJson(results.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  //------------------------------ Read All Users -------------------------------
  static Future<List<CachedUser>> getAllCachedUsers() async {
    final db = await getInstance.database;
    const orderBy = "${CachedUsersFields.userName} ASC";
    final result = await db.query(
      userTable,
      orderBy: orderBy,
    );
    return result.map((json) => CachedUser.fromJson(json)).toList();
  }

  static Future<int> updateCachedUser(CachedUser cachedUser) async {
    Map<String, dynamic> col = {
      // CachedUsersFields.userName: cachedUser.userName,
      CachedUsersFields.age: cachedUser.age,
    };

    final db = await getInstance.database;
    return await db.update(
      userTable,
      col,
      where: '${CachedUsersFields.id} = ?',
      whereArgs: [cachedUser.id],
    );
  }

  //------------------------------ Delete Users By ID --------------------------
  static Future<int> deleteCachedUserById(int id) async {
    final db = await getInstance.database;
    var t = await db
        .delete(userTable, where: "${CachedUsersFields.id}=?", whereArgs: [id]);
    if (t > 0) {
      return t;
    } else {
      return -1;
    }
  }

  //------------------------------ Delete All User -----------------------------
  static Future<int> deleteAllCachedUsers() async {
    final db = await getInstance.database;
    return await db.delete(userTable);
  }

  //--------------------------------- Close DB ---------------------------------
  static Future close() async {
    final db = await getInstance.database;
    db.close();
  }
}
