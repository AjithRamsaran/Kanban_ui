part of 'board_bloc.dart';

enum OperationStatus { initial, loading, success, failure }

enum TaskType { nothing, addTask, addBoard, moveTask, updateTask }

enum ActionStatus { normal, loading, hide }

class BoardState extends Equatable {
  final OperationStatus operationStatus;
  List<Board>? boards;
  final List<Tag>? tags;
  final List<User>? users;
  ActionStatus isAddNewOrUpdateTask;

  bool isAddNewBoardLoading;

  ActionStatus generalLoaderAtBottom;
  bool isChangingTaskboard;
  String message;

  //TaskType taskType = TaskType.nothing;

  BoardState(
      /*this.taskType, */
      {required this.operationStatus,
      this.boards = const [],
      this.tags,
      this.users,
      this.generalLoaderAtBottom = ActionStatus.normal,
      this.isAddNewBoardLoading = false,
      this.isAddNewOrUpdateTask = ActionStatus.normal,
      this.isChangingTaskboard = false,
      this.message = ''});

  BoardState copyWith(
      {OperationStatus? status,
      List<Board>? boards,
      List<Tag>? tags,
      List<User>? users,
      TaskType,
        ActionStatus? generalLoader,
      bool? isAddNewBoardLoader,
      bool? isChangingTaskboard,
      ActionStatus? isAddNewTaskStatus,
      String? exportPath}) {
    BoardState b = BoardState(
        generalLoaderAtBottom: generalLoader ?? this.generalLoaderAtBottom,
        isAddNewBoardLoading: isAddNewBoardLoader ?? this.isAddNewBoardLoading,
        isAddNewOrUpdateTask: isAddNewTaskStatus ?? this.isAddNewOrUpdateTask,
        isChangingTaskboard: isChangingTaskboard ?? this.isChangingTaskboard,
        operationStatus: status ?? this.operationStatus,
        boards: boards ?? this.boards,
        tags: tags ?? this.tags,
        users: users ?? this.users,
        message: exportPath ?? this.message);
    return b;
  }

  @override
  List<Object> get props {
    return [
      operationStatus,
      generalLoaderAtBottom,
      isAddNewBoardLoading,
      isAddNewOrUpdateTask
    ];
  }
}

class AddTaskState extends Equatable {
  final OperationStatus operationStatus;

  //final Board? board;
  //final List<Tag>? tags;
  //final List<User>? users;

  AddTaskState(
      {required this.operationStatus /*, this.board, this.tags, this.users*/
      });

  AddTaskState copyWith(
      {OperationStatus? status,
      Board? board,
      List<Tag>? tags,
      List<User>? users}) {
    AddTaskState b = AddTaskState(
      operationStatus: status ?? this.operationStatus,
      /* boards: tasks ?? this.board,
        tags: tags ?? this.tags,
        users: users ?? this.users*/
    );
    return b;
  }

  @override
  List<Object> get props {
    return [operationStatus];
  }
}
