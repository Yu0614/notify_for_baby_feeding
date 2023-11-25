import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FeedsDBAccessor {
  FeedsDBAccessor._();
  static final FeedsDBAccessor db = FeedsDBAccessor._();

  static const dbName = "feed_notify.db";
  static Database? _database;

  // initDBをしてdatabaseを使用する
  Future<Database> get database async => _database ??= await initDB();

  /// initDB
  /// DataBaseのバージョンが違う場合はtableを作成する
  Future<Database> initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), dbName),
      version: 1,
      onCreate: _createTable,
    );
  }

  Future _createTable(Database db, int version) async {
    // ダブルクォートもしくはシングルクォート3つ重ねることで改行で文字列を作成できる。$変数名は、クラス内の変数のこと（文字列の中で使える）
    await db.execute('''
          CREATE TABLE IF NOT EXISTS feeds(
            id INTEGER PRIMARY KEY,
            memo TEXT DEFAULT '',
            amount INTEGER NOT NULL ,
            feed_at TIMESTAMP,
            created_at TIMESTAMP NOT NULL DEFAULT (DATETIME(CURRENT_TIMESTAMP, 'localtime')),
            updated_at TIMESTAMP NOT NULL DEFAULT (DATETIME(CURRENT_TIMESTAMP, 'localtime'))
          )
          ''');
  }

  /// Insert Records
  /// [json]はレコードの内容
  Future<int> create({
    required Map<String, Object?> json,
  }) async {
    final db = await database;
    return db.insert("feeds", json);
  }

  /// tableからデータを取得する
  /// [where]は id = ? のような形式にする
  /// [where]もしくは[whereArgs]がnullの場合は全件取得する
  Future<List<Map<String, Object?>>> get({
    String? where,
    List? whereArgs,
  }) async {
    final db = await database;
    if (where == null || whereArgs == null) {
      return db.query("feeds");
    }
    return db.query(
      "feeds",
      where: where,
      whereArgs: whereArgs,
    );
  }

  /// tableのidに一致する[primaryKey]を指定してレコードをupdateする
  Future<int> update({
    required Map<String, Object?> json,
    required int primaryKey,
  }) async {
    final db = await database;
    return db.update(
      "feeds",
      json,
      where: "id = ?",
      whereArgs: [primaryKey],
    );
  }

  /// tableのidに一致する[primaryKey]を指定してレコードを削除する
  Future<int> delete({
    required int primaryKey,
  }) async {
    final db = await database;
    var res = db.delete("feeds", where: "id = ?", whereArgs: [primaryKey]);
    return res;
  }
}
