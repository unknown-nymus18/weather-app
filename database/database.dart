import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';

class DataBase {
  List db = [];
  var box = Hive.box('myBox');

  void initializeDatabase() {
    db = ['ACCRA'];
    updateData();
  }

  void addData(String place) {
    if (!db.contains(place.toUpperCase())) {
      db.add(place.toUpperCase());
    }
    updateData();
  }

  bool removeData(String place) {
    if (db.remove(place)) {
      updateData();
      return true;
    }
    return false;
  }

  void updateData() {
    box.put('data', db);
  }

  void loadData() {
    db = box.get('data');
  }

  ValueListenable listenable() {
    return box.listenable();
  }
}
