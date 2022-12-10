import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBAdmin {
  Database? myDatabase;

  //Singleton

  static final DBAdmin db = DBAdmin._();
  DBAdmin._();
  //
  checkDatabase() {
    if (myDatabase != null) {
      return myDatabase;
    }

    myDatabase = initDatabase(); // Creacion de la base de datos
    return myDatabase;
  }

  initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "TaskDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database dbx, int version) async {
      //crecion de tablas
      await dbx.execute(
          "CREATE TABLE TASK(id INTEGER PRIMARY KEY AUTOINGREMENT, title TEXT, description TEXT, status TEXT)");
    });
  }
}
