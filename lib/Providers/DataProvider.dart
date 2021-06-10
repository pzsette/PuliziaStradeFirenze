import 'package:flutter/material.dart';
import 'package:pulizia_strade/Models/PositionInMap.dart';
import 'package:pulizia_strade/Repository/favourites_db.dart';

class DataProvider with ChangeNotifier {
  final DBHelper dbHelper;
  List<PositionInMap> _items = [];
  final tableName = 'my_table';

  DataProvider(this.dbHelper) {
    if (dbHelper != null) fetchAndSetData();
  }

  List<PositionInMap> get items {
    return _items;
  }

  fetchAndSetData() async {
    if (dbHelper.database != null) {
      // do not execute if db is not instantiate
      _items = await dbHelper.getAllFavourites();
      notifyListeners();
    }
  }

  void insertPosition(PositionInMap position) {
    if (dbHelper.database != null) {
      _items.add(position);
      dbHelper.insertPos(position);
      notifyListeners();
    }
  }

  void deletePosition(PositionInMap position) {
    if (dbHelper.database != null) {
      _items.removeWhere((element) =>
          element.section == position.section &&
          element.streetName == position.streetName &&
          element.city == position.city);
      dbHelper.deletePos(position);
      notifyListeners();
    }
  }
}
