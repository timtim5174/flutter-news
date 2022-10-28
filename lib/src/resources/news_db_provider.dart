import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../models/item_model.dart';
import 'cache.dart';
import 'source.dart';

class NewsDbProvider implements Source, Cache {
  static final NewsDbProvider _newsDbProvider = NewsDbProvider._internal();

  late final Database db;

  factory NewsDbProvider() {
    return _newsDbProvider;
  }

  NewsDbProvider._internal() {
    print('DB provider has been created');
    init();
  }

  void init() async {
    // Returns a reference to a temp folder on mobile devices
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "items1.db");
    db = await openDatabase(path, version: 1,
        onCreate: (Database newDb, int version) {
      newDb.execute("""
            CREATE TABLE Items
            (
              id INTEGER PRIMARY KEY,
              type TEXT,
              by TEXT,
              time INTEGER,
              text TEXT,
              parent INTEGER,
              kids BLOB,
              dead INTEGER,
              deleted INTEGER,
              url TEXT,
              score INTEGER,
              title TEXT,
              descendants INTEGER
            )  
          """);
    });
  }

  @override
  Future<ItemModel?> fetchItem(int id) async {
    final maps = await db.query(
      "Items",
      columns: null,
      where: "id = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ItemModel.fromDb(maps.first);
    }
    return null;
  }

  @override
  Future<List<int>> fetchTopIds() {
    return Future.value([]);
  }

  Future<int> addItem(ItemModel item) {
    return db.insert('Items', item.toMapForDb(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  @override
  Future<int> clear() {
    return db.delete('Items');
  }
}
