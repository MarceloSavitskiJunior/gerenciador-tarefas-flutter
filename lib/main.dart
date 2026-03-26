import 'package:flutter/material.dart';
import 'package:gerenciador_tarefas/pages/list_tasks_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gerenciador de Tarefas',
      theme: ThemeData(
        colorScheme: .fromSeed(
            seedColor: Color(0xFF00A255),
            brightness: Brightness.dark,
        ),
      ),
      home: ListTasksPage(),
    );
  }
}