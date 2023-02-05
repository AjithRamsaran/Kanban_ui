import 'package:kanban_ui/model/board.dart';
import 'package:kanban_ui/model/task_status.dart';
import 'package:kanban_ui/model/user.dart';
import 'package:kanban_ui/networking/kanban_apis.dart';

import '../model/task.dart';

class KanbanRepository {
  final KanbanApi kanbanApi;

  KanbanRepository({required this.kanbanApi});

  Future<List<Board>> getBoards() async {
    await kanbanApi.getBoards();
    Future.delayed(Duration(seconds: 2));
    return List.generate(
        10,
        (index) => Board(id: index, title: "Board name $index", tasks: List.generate(index, (index1) => Task(
            id: index1,
            taskText: "Task $index1",
            users: [
              User(
                  id: index1,
                  name: "Ajith $index1",
                  title: "SDE $index1",
                  email: "")
            ],
            createdAt: "2023-02-06 14:23:30",
            status: TaskStatus(
                id: index1 * 10,
                status: "Todo",
                createdAt: "2023-02-06 14:23:30")))));
  }

  Future<void> saveTasks(Task task) async {}

  Future<void> deleteTask(String id) async {}
}
