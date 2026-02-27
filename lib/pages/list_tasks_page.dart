import 'package:flutter/material.dart';
import 'package:gerenciador_tarefas/widgets/content_form_dialog.dart';

import '../model/task.dart';

class ListTasksPage extends StatefulWidget {

  @override
  _ListTasksPageState createState() => _ListTasksPageState();
}

class _ListTasksPageState extends State<ListTasksPage> {

  final _tasks = <Task>[
  ];

  late var lastId = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      floatingActionButton: FloatingActionButton(
        onPressed: _openForm,
        tooltip: "Nova tarefa",
        child: const Icon(Icons.add),
      ),
      appBar: _createAppBar(),
      body: _createBody(),
    );
  }

  AppBar _createAppBar() {
    return AppBar(
      titleTextStyle: TextStyle(color: Colors.white, fontSize: double.tryParse("24")),
      title: Text("Tarefas"),
      centerTitle: true,
      backgroundColor: Colors.amber,
      actions: [
        IconButton(
            onPressed: null,
            icon: Icon(Icons.list)
        )
      ],
    );
  }

  Widget _createBody() {
    if (_tasks.isEmpty) {
      return const Center(
        child: Text("Nenhuma tarefa encontrada.",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        )
      );
    }

    return ListView.separated(
        itemCount: _tasks.length,
        itemBuilder: (BuildContext context, int index) {
          final task = _tasks[index];
          return Card(
            color: Colors.amberAccent,
            child: ListTile(
              title: Text("${task.id} - ${task.description}"),
              subtitle: Text("Prazo: ${task.formatedDeliveryAt}"),
              onTap: () {
                _openForm(task: task);
              },
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(
          color: Colors.black,
        )
    );
  }

  void _openForm( { Task? task, int? index } ) {
    final key = GlobalKey<ContentFormDialogState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(task != null ? "Editar tarefa: ${task.id}" : "Criar tarefa"),
            content: ContentFormDialog(key: key, actualTask: task),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancelar")
              ),
              TextButton(
                  onPressed: () {
                    if (key.currentState != null && key.currentState!.validatedData()) {
                      setState(() {
                        final newTask = key.currentState!.newTask;
                        if (index == null) {
                          newTask.id = ++ lastId;
                          _tasks.add(newTask);
                        } else {
                          _tasks[index] = newTask;
                        }
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Salvar"),
              )
            ],
          );
        }
    );
  }

}