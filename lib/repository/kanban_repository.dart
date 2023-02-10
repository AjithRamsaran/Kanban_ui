import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:kanban_ui/model/GetAllBoardResponse.dart';
import 'package:kanban_ui/model/GetAllUserResponse.dart';
import 'package:kanban_ui/model/GetTag.dart';
import 'package:kanban_ui/model/task_status.dart';
import 'package:kanban_ui/networking/kanban_apis.dart';

import '../model/CreateAddBoardResponse.dart';
import '../model/Data.dart';
import '../model/Tags.dart';
import '../model/TaskIds.dart';
import '../model/Users.dart';
import '../model/tag.dart';
import '../utils/export.dart';

class KanbanRepository {
  final KanbanApi kanbanApi;

  List<Board> boards = [];
  List<User> users = [];

  KanbanRepository({required this.kanbanApi});

  Future<List<Board>> getBoards() async {
    var response = await kanbanApi.getBoards(1);
    GetAllBoardResponse res = GetAllBoardResponse.fromJson(response);
    boards = res.data ?? [];
    /*if (!isFromExport) {
      unawaited(exportFile());
    }*/
    //Future.delayed(Duration(seconds: 2));
    return boards; /*List.generate(
        3,
        (index) => Board(id: index, title: "Board name $index", tasks: List.generate(index, (index1) => Task(
            id: index * 10 +index1,
            description: "Task ${index * 10 + index1}",
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
                createdAt: "2023-02-06 14:23:30")))));*/
  }

  Future<bool> addBoard(String name, String description, bool isEnd) async {
    try {
      var response =
      await kanbanApi.createNewBoard(1, description, name, isEnd);
      CreateAddBoardResponse res = CreateAddBoardResponse.fromJson(response);

      if (res.response == "success") {
        boards.add(Board(
            companyId: "1",
            description: description,
            id: res.id,
            name: name,
            taskIds: [],
            isEnd: isEnd));
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
    /*boards = res.data ?? [];
    try {
      boards
          .add(Board(name: title, taskIds: [], id: DateTime.now().microsecond));
      //await Future.delayed(Duration(microseconds: 1))
      return true;
    } catch (e) {
      return false;
    }*/
  }

  Future<bool> addTask(String title, int boardId, String description,
      List<User> users, List<Tag> tags) async {
    try {
      var response = await kanbanApi.createNewTask(
          title, description, tags, users, boardId);

      CreateAddBoardResponse res = CreateAddBoardResponse.fromJson(response);
      if (res != null && res.response == "success") {
        return true;
      }

      /* Board b = boards.firstWhere((element) => element.id == boardId);
      b.taskIds?.add(Task(
          id: b.id! * 10,
          description: title,
          users: [],
          createdAt: DateTime.now().toString(),
          timeTracker: [
            TaskStatus(
                status: b.name ?? "",
                createdAt: DateTime.now().toString(),
                endAt: "",
                id: b.id! * 10)
          ]));*/
      /*boards
          .add(Board(title: title, tasks: [], id: DateTime.now().microsecond));*/
      //await Future.delayed(Duration(microseconds: 1))
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateTask(int taskId, String title, int boardId,
      String description, List<User> users, List<Tag> tags) async {
    try {
      var response = await kanbanApi.updateTask(
          taskId, title, description, tags, users, boardId);
      CreateAddBoardResponse res = CreateAddBoardResponse.fromJson(response);
      if (res.response == "success") {
        return true;
      }

      /* Board b = boards.firstWhere((element) => element.id == boardId);
      b.taskIds?.add(Task(
          id: b.id! * 10,
          description: title,
          users: [],
          createdAt: DateTime.now().toString(),
          timeTracker: [
            TaskStatus(
                status: b.name ?? "",
                createdAt: DateTime.now().toString(),
                endAt: "",
                id: b.id! * 10)
          ]));*/
      /*boards
          .add(Board(title: title, tasks: [], id: DateTime.now().microsecond));*/
      //await Future.delayed(Duration(microseconds: 1))
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> changeTaskByBoardId(int taskId,
      int boardId,
      int moveToBoardId,) async {
    try {
      var response = await kanbanApi.changeTaskByBoardId(
          taskId.toString(), boardId.toString(), moveToBoardId.toString());

      CreateAddBoardResponse res = CreateAddBoardResponse.fromJson(response);
      if (res != null && res.response == 'success') {
        return true;
      }
      /*Board b = boards.firstWhere((element) => element.id == boardId);
      Task? t = b.taskIds?.firstWhere((element) => element?.id == taskId);
      b.taskIds?[b.taskIds?.indexOf(t) ?? 0] = t?.copyWith(
          id: taskId,
          name: name,
          tags: tags,
          createdAt: null,
          description: description,
          endTime: null,
          timeTracker: null,
          totalTimeSpent: null,
          users: users);*/
      //await Future.delayed(Duration(microseconds: 1))
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<String> exportFile() async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await Export.getCsv(
          await getBoards(), await getUsers(), await getTags());
    }
    return "";
  }

  Future<List<Tag>> getTags() async {
    var response = await kanbanApi.getAllTags();
    GetTag res = GetTag.fromJson(response);

    return res.data ??
        []; /*List.generate(
        3,
        (index) => Board(id: index, title: "Board name $index", tasks: List.generate(index, (index1) => Task(
            id: index * 10 +index1,
            description: "Task ${index * 10 + index1}",
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
                createdAt: "2023-02-06 14:23:30")))));*/
  }

  Future<void> saveTasks(Task task) async {}

  Future<void> deleteTask(String id) async {}

  Future<List<User>> getUsers() async {
    var response = await kanbanApi.getAllUsers();
    GetAllUserResponse res = GetAllUserResponse.fromJson(response);

    return res.data ?? [];
  }
}
