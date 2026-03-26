import 'package:gerenciador_tarefas/model/task.dart';

import '../database/database_provider.dart';

class TaskDao{
  final dbProvider = DatabaseProvider.instace;

  Future<bool> save(Task task) async {
    final db = await dbProvider.database;
    final values = task.toMap();
    if(task.id == null){
      task.id = await db.insert(Task.TABLE_NAME, values);
      return true;
    }else{
      final registrosAtualizados = await db.update(
          Task.TABLE_NAME,
          values,
          where: '${Task.ID} = ?', whereArgs: [task.id]
      );
      return registrosAtualizados > 0;
    }
  }

  Future<bool> exclude(id) async {
    final db = await dbProvider.database;
    final actualizedRegisters = await db.delete(Task.TABLE_NAME, where: '${Task.ID} = ?', whereArgs: id);

    return actualizedRegisters > 0;
  }

  Future<List<Task>> list() async {
    final db = await dbProvider.database;
    final items = await db.query(Task.TABLE_NAME,
      columns: [
        Task.ID,
        Task.DESCRIPTION,
        Task.DELIVERY_AT
      ]);

    return items.map((m) => Task.fromMap(m)).toList();
  }

}