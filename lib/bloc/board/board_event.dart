part of 'board_bloc.dart';

@immutable
abstract class BoardEvent {}

class BoardStarted extends BoardEvent {}

class AddBoardEvent extends BoardEvent {
  late final String title;
  late final String description;
  late bool isEnd;

  //late final String companyId;

  AddBoardEvent(this.title, this.description, this.isEnd);
}

class DeleteBoardEvent extends BoardEvent {
  late final int id;

  DeleteBoardEvent(this.id);
}

class AddTaskEvent extends BoardEvent {
  late final int boardId;
  late final String title;
  late final String description;
  late final List<User> users;
  late final List<Tag> tags;

  AddTaskEvent(
      {required this.title,
      required this.boardId,
      required this.description,
      required this.tags,
      required this.users});
}

class DeleteTaskEvent extends BoardEvent {
  late final int id;

  DeleteTaskEvent(this.id);
}

class UpdateTaskEvent extends BoardEvent {
  late final int taskId;
  late final int boardId;
  late final String title;
  late final String description;
  late final List<User> users;
  late final List<Tag> tags;

  UpdateTaskEvent(
      {required this.taskId,
      required this.title,
      required this.boardId,
      required this.description,
      required this.tags,
      required this.users});
}

class MoveTaskEvent extends BoardEvent {
  int boardId;
  int moveToBoardId;
  int taskId;

  MoveTaskEvent(
      {required this.boardId,
      required this.taskId,
      required this.moveToBoardId});
}

class ExportTaskEvent extends BoardEvent {
  /* List<User> users;
  List<Board> boards;
  List<Tag> tags;*/
  ExportTaskEvent(
      /*{required this.boards, required this.users,required this.tags}*/);
}
