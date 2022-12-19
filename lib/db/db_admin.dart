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
  Future<Database?> checkDatabase() async {
    if (myDatabase != null) {
      return myDatabase;
    }

    myDatabase = await initDatabase(); // Creacion de la base de datos
    return myDatabase;
  }

  Future<Database?> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "TaskDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database dbx, int version) async {
      //crecion de tablas
      await dbx.execute(
          "CREATE TABLE task(id INTEGER PRIMARY KEY AUTOINGREMENT, title TEXT, description TEXT, status TEXT)");
    });
  }

  insertRawTask() async {
    Database? db = await checkDatabase();
    int res = await db!.rawInsert(
        "INSERT INTO TASK(title, description, status) VALUES ('salir de compras','al centro comercial','false')");

    print(res);
  }

  insertTask() async {
    Database? db = await checkDatabase();
    int res = await db!.insert(
      "TASK",
      {
        "title": "comprar el nuevo disco",
        "description": "nuevo discode epica",
        "status": "false",
      },
    );
    print(res);
  }

  getRawTasks() async {
    Database? db = await checkDatabase();
    List tasks = await db!.rawQuery("SELECT * FROM Task");
    print(tasks[0]);
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    Database? db = await checkDatabase();
    List<Map<String, dynamic>> tasks = await db!.query("Task");
    return tasks;
  }

  //metodo update

  updateRawTask() async {
    Database? db = await checkDatabase();
    int res = await db!.rawUpdate(
        "UPDATE TASK SET title = 'ultimas compras',description = 'comestibles',status ='true' WHERE id = 2");
    print(res);
  }

  updateTask() async {
    Database? db = await checkDatabase();
    int res = await db!.update(
      "Task",
      {
        "title": "ir al cine",
        "description": "el fin de semana en la tarde",
        "status": "false",
      },
      where: "id = 2",
    );
  }

  deleteRawTask() async {
    Database? db = await checkDatabase();
    int res = await db!.rawDelete("DELETE FROM TASK WHERE id = 2");
    print(res);
  }

  deleteTask() async {
    Database? db = await checkDatabase();
    int res = await db!.delete("TASK", where: "id = 3");
    print(res);
  }
}
