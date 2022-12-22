import 'package:flutter/material.dart';
import 'package:proyecto_de_videos/db/db_admin.dart';
import 'package:proyecto_de_videos/models/task_model.dart';

class MyFormWidget extends StatefulWidget {
  const MyFormWidget({super.key});

  @override
  State<MyFormWidget> createState() => _MyFormWidgetState();
}

class _MyFormWidgetState extends State<MyFormWidget> {
  final _formkey = GlobalKey<FormState>();
  bool isFinished = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  addTask() {
    if (_formkey.currentState!.validate()) {
      TaskModel taskModel = TaskModel(
        title: _titleController.text,
        description: _descriptionController.text,
        status: isFinished.toString(),
      );

      DBAdmin.db.insertTask(taskModel).then(
        (value) {
          if (value > 0) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                duration: const Duration(microseconds: 1400),
                content: Row(
                  children: const [
                    Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text("Tarea registrada con exito")
                  ],
                ),
              ),
            );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formkey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("agregar tarea"),
            const SizedBox(
              height: 6.0,
            ),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(hintText: "Titulo"),
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "el campo es obligatorio";
                }
                if (value.length < 6) {
                  return "debe tener minimo 6 caracter";
                }

                return null;
              },
            ),
            const SizedBox(
              height: 6.0,
            ),
            TextFormField(
              controller: _descriptionController,
              maxLines: 2,
              decoration: InputDecoration(hintText: "Descripcion"),
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "el campo es obligatorio";
                }

                return null;
              },
            ),
            const SizedBox(
              height: 6.0,
            ),
            Row(
              children: [
                const Text("estado: "),
                const SizedBox(
                  width: 6.0,
                ),
                Checkbox(
                  value: isFinished,
                  onChanged: (value) {
                    isFinished = value!;
                    setState(() {});
                  },
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("cancelar"),
                ),
                SizedBox(
                  width: 10.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    addTask();
                  },
                  child: Text("Aceptar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
