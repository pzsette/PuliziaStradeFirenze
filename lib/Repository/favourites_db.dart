import 'dart:io' show Directory;
import 'package:path/path.dart' show join;
import 'package:pulizia_strade/Models/PositionInMap.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

class DBHelper {
  static final _databaseName = "FavDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'favPosition';

  static final columnStreetName = 'street';
  static final columnStreetSection = 'section';
  static final columnCityName = 'city';
  static final columnNot = 'notification';

  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnStreetName TEXT NOT NULL,
            $columnStreetSection TEXT NOT NULL,
            $columnCityName TEXT NOT NULL,
            $columnNot BIT(1) NOT NULL,
            PRIMARY KEY ($columnStreetName,$columnStreetSection)
          )
          ''');
    print("db was created");
  }

  Future<void> insertPos(PositionInMap pos) async {
    final Database db = await database;
    final List<Map<String, dynamic>> res = await db.query(table,
        where: "street = ? AND section = ?",
        whereArgs: [pos.streetName, pos.section]);
    if (!res.isNotEmpty) {
      Map<String, dynamic> row = {
        DBHelper.columnStreetName: pos.streetName,
        DBHelper.columnStreetSection: pos.section,
        DBHelper.columnCityName: pos.city,
        DBHelper.columnNot: 1,
      };
      await db.insert(table, row);
    }
  }

  //Delete a street from the DB
  Future<void> deletePos(PositionInMap pos) async {
    Database db = await DBHelper.instance.database;
    await db.delete(table,
        where: 'street = ? AND section = ?',
        whereArgs: [pos.streetName, pos.section]);
  }

  //Update the notification boolean
  Future<void> updateNot(PositionInMap pos, bool value) async {
    // Get a reference to the database.
    Database db = await DBHelper.instance.database;

    Map<String, dynamic> row = {
      DBHelper.columnStreetName: pos.streetName,
      DBHelper.columnStreetSection: pos.section,
      DBHelper.columnNot: value ? 1 : 0,
    };
    await db.update(table, row,
        where:
            '${DBHelper.columnStreetName} = ? AND ${DBHelper.columnStreetSection} = ?',
        whereArgs: [pos.streetName, pos.section]);
  }

  Future<List<PositionInMap>> getAllFavourites() async {
    // Get a reference to the database.
    Database db = await DBHelper.instance.database;

    List<Map> res =
        await db.query(table, columns: [columnStreetName, columnStreetSection]);
    List<PositionInMap> list = [];
    for (Map i in res) {
      String street = i["street"];
      String section = i["section"];
      String city = i["city"];
      PositionInMap position = new PositionInMap(street, city, section);
      list.add(position);
    }
    return list;
  }

  Future<bool> checkIfPositionInFavourite(PositionInMap position) async {
    Database db = await DBHelper.instance.database;
    List<Map> res = await db.query(table,
        columns: [columnStreetName, columnStreetSection],
        where:
            '${DBHelper.columnStreetName} = ? AND ${DBHelper.columnStreetSection} = ?',
        whereArgs: [position.streetName, position.section]);
    if (res != null && res.length != 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> getNotification(PositionInMap pos) async {
    // Get a reference to the database.
    Database db = await DBHelper.instance.database;
    List<Map> res = await db.query(table,
        columns: [columnNot],
        where:
            '${DBHelper.columnStreetName} = ? AND ${DBHelper.columnStreetSection} = ?',
        whereArgs: [pos.streetName, pos.section]);
    int value = res[0]["notification"];
    if (value == 1) {
      return true;
    } else if (value == 0) {
      return false;
    } else {
      throw FormatException("Value can only be 0 or 1");
    }
  }
}
