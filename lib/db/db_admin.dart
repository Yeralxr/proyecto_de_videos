import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:proyecto_de_videos/models/task_model.dart';
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

  Future<int> insertRawTask(TaskModel model) async {
    Database? db = await checkDatabase();
    int res = await db!.rawInsert(
        "INSERT INTO TASK(title, description, status) VALUES ('${model.title}','${model.description}','${model.status.toString()}')");

    return res;
  }

  Future<int> insertTask(TaskModel model) async {
    Database? db = await checkDatabase();
    int res = await db!.insert(
      "TASK",
      {
        "title": model.title,
        "description": model.description,
        "status": model.status,
      },
    );
    return res;
  }

  getRawTasks() async {
    Database? db = await checkDatabase();
    List tasks = await db!.rawQuery("SELECT * FROM Task");
    print(tasks[0]);
  }

  Future<List<TaskModel>> getTasks() async {
    Database? db = await checkDatabase();
    List<Map<String, dynamic>> tasks = await db!.query("Task");
    List<TaskModel> taskModelList =
        tasks.map((e) => TaskModel.deMapAModel(e)).toList();

    /* 
   task.forEach(
      (element) {
        TaskModel task = TaskModel.deMapAModel(element);
        taskModelList.add(task);
      },
    ); 
    
    */

    return taskModelList;
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

  Future<int> deleteTask(int id) async {
    Database? db = await checkDatabase();
    int res = await db!.delete("TASK", where: "id = $id");
    return res;
  }
}
