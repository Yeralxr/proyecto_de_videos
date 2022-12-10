import 'package:flutter/material.dart';
import 'package:proyecto_de_videos/pages/home_pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "taskdbApp",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
