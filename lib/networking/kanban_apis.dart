import '../model/task.dart';

class KanbanApi {
  const KanbanApi();

  Future<List<Task>> getBoards() async {
    return <Task>[];
  }

  Future<void> saveTasks(Task task) async {}

  Future<void> deleteTask(String id) async {}
}
