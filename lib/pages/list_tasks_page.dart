import 'package:flutter/material.dart';
import 'package:gerenciador_tarefas/dao/task_dao.dart';
import 'package:gerenciador_tarefas/widgets/content_form_dialog.dart';

import '../model/task.dart';
import 'filter_page.dart';

class ListTasksPage extends StatefulWidget {
  @override
  _ListTasksPageState createState() => _ListTasksPageState();
}

class _ListTasksPageState extends State<ListTasksPage> {

  static const DELETE_ACTION = 'deletar';
  static const EDIT_ACTION = "editar";

  final _tasks = <Task>[];
  final _dao = TaskDao();
  late var lastId = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      floatingActionButton: FloatingActionButton(
        onPressed: _openForm,
        tooltip: "Nova tarefa",
        child: const Icon(Icons.add, color: Colors.black),
      ),
      appBar: _createAppBar(),
      body: _createBody(),
    );
  }

  void _openFilter(){
    final navigator = Navigator.of(context);
    navigator.pushNamed(FilterPage.ROUTE_NAME).then((alterouValores){
      if (alterouValores == true){

      }
    });
  }

  void _fetchList() async {
    final items = await _dao.list();
    setState(() {
      _tasks.clear();

      if (items.isNotEmpty) {
        _tasks.addAll(items);
      }
    });
  }

  AppBar _createAppBar() {
    return AppBar(
      title: const Text("Tarefas"),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w500
      ),
      actions: [
        IconButton(
          onPressed: _openFilter,
          icon: Icon(Icons.list, color: Theme.of(context).colorScheme.primary),
        )
      ],
    );
  }

  Widget _createBody() {
    if (_tasks.isEmpty) {
      return Center(
        child: Text(
          "Nenhuma tarefa encontrada.",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    List<PopupMenuEntry<String>>criarItemMenuPopUp(){
      return [
        PopupMenuItem<String>(
            value: EDIT_ACTION,
            child: Row(
              children: [
                Icon(Icons.edit, color: Colors.black),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('Editar'),
                )
              ],
            )
        ),

        PopupMenuItem<String>(
            value: EDIT_ACTION,
            child: const Row(
              children: [
                Icon(Icons.edit, color: Colors.red),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('Deletar'),
                )
              ],
            )
        ),

      ];
    }

    void _exclude(int index) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.warning),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text("Atenção!"),
                  )
                ],
              ),
              content: Text("Esse registro será removido permanentemente!"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Cancelar")
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _tasks.removeAt(index);
                      });
                    },
                    child:const Text('Ok')
                )
              ],
            );
          }
      );
    }

    return ListView.separated(
      itemCount: _tasks.length,
      itemBuilder: (BuildContext context, int index) {
        final task = _tasks[index];

        return Card(
          color: Theme.of(context).colorScheme.surfaceContainer,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              "${task.id} - ${task.description}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              "Prazo: ${task.formatedDeliveryAt}",
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.primary, size: 16),
            onTap: () {
              _openForm(task: task);
            },

          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          Divider(color: Colors.grey.shade900),
    );
  }

  void _openForm({Task? task}) {
    final key = GlobalKey<ContentFormDialogState>();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surfaceBright,
            title: Text(
              task != null ? "Editar tarefa: ${task.id}" : "Criar tarefa",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            content: ContentFormDialog(key: key, actualTask: task),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancelar",
                    style: TextStyle(color: Colors.white70),
                  )
              ),
              TextButton(
                onPressed: () {
                  if (key.currentState != null && key.currentState!.validatedData()) {
                    setState(() {
                      final newTask = key.currentState!.newTask;
                      _dao.save(newTask).then((sucess) => {
                        if (sucess) _fetchList()
                      });
                    });

                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  "Salvar",
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              )
            ],
          );
        }
    );
  }
}