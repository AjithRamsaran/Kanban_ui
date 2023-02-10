import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kanban_ui/model/board.dart';
import 'package:kanban_ui/repository/kanban_repository.dart';
import 'package:meta/meta.dart';

import '../../model/Data.dart';
import '../../model/Tags.dart';
import '../../model/Users.dart';
import '../../model/tag.dart';
import '../../model/task.dart';
import '../../model/user.dart';

part 'board_event.dart';

part 'board_state.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  BoardBloc({required this.kanbanRepository})
      : super(BoardState(operationStatus: OperationStatus.initial)) {
    on<BoardStarted>(getBoards);
    on<AddBoardEvent>(addBoard);
    on<DeleteBoardEvent>(deleteBoard);
    on<AddTaskEvent>(addTask);
    on<DeleteTaskEvent>(deleteTask);
    on<MoveTaskEvent>(changeTaskByBoardId);
    on<ExportTaskEvent>(exportFile);
    on<UpdateTaskEvent>(updateTask);
  }

  Repository kanbanRepository;

  Future<void> getBoards(BoardStarted event, Emitter<BoardState> emit) async {
    emit(state.copyWith(status: OperationStatus.loading));
    try {
      emit(state.copyWith(
          status: OperationStatus.success,
          boards: await kanbanRepository.getBoards(),
          tags: await kanbanRepository.getTags(),
          users: await kanbanRepository.getUsers()));
      print(state.users);
    } catch (e) {
      emit(state.copyWith(status: OperationStatus.failure, boards: []));
    }
  }

  Future<void> addBoard(AddBoardEvent event, Emitter<BoardState> emit) async {
    emit(state.copyWith(status: OperationStatus.loading));
    bool value = await kanbanRepository.addBoard(
        event.title, event.description, event.isEnd);
    try {
      if (value) {
        emit(state.copyWith(
            status: OperationStatus.success,
            boards: await kanbanRepository.getBoards()));
      } else {
        emit(state.copyWith(
            status: OperationStatus.failure,
            boards: await kanbanRepository.getBoards()));
      }
    } catch (e) {
      emit(state.copyWith(status: OperationStatus.failure));
    }
  }

  Future<void> deleteBoard(
      DeleteBoardEvent event, Emitter<BoardState> emit) async {}

  Future<void> addTask(AddTaskEvent event, Emitter<BoardState> emit) async {
    emit(state.copyWith(isAddNewTaskStatus: ActionStatus.loading));
    bool value = await kanbanRepository.addTask(
        event.title, event.boardId, event.description, event.users, event.tags);
    try {
      if (value) {
        emit(state.copyWith(
            status: OperationStatus.success,
            boards: await kanbanRepository.getBoards(),
            isAddNewTaskStatus: ActionStatus.hide));
        emit(state.copyWith(isAddNewTaskStatus: ActionStatus.normal));
      } else {
        emit(state.copyWith(
            status: OperationStatus.failure,
            boards: await kanbanRepository.getBoards(),
            isAddNewTaskStatus: ActionStatus.normal));
      }
    } catch (e) {
      emit(state.copyWith(
          status: OperationStatus.failure,
          isAddNewTaskStatus: ActionStatus.normal));
    }
  }

/*
  Future<void> changeTaskByBoardId(UpdateTaskEvent event, Emitter<BoardState> emit) async {
    emit(state.copyWith(isAddNewTaskStatus: AddTaskStatus.loading));
    bool value = await kanbanRepository.changeTaskByBoardId(event.taskId,event.boardId,event.moveToBoardId
        );
    try {
      if (value) {
        emit(state.copyWith(
            status: OperationStatus.success,
            boards: await kanbanRepository.getBoards(),
            isAddNewTaskStatus: AddTaskStatus.hide));
        emit(state.copyWith(isAddNewTaskStatus: AddTaskStatus.normal));
      } else {
        emit(state.copyWith(
            status: OperationStatus.failure,
            boards: await kanbanRepository.getBoards(),
            isAddNewTaskStatus: AddTaskStatus.normal));
      }
    } catch (e) {
      emit(state.copyWith(
          status: OperationStatus.failure,
          isAddNewTaskStatus: AddTaskStatus.normal));
    }
  }
*/

  Future<void> deleteTask(
      DeleteTaskEvent event, Emitter<BoardState> emit) async {}

  Future<void> changeTaskByBoardId(
      MoveTaskEvent event, Emitter<BoardState> emit) async {
    emit(state.copyWith(isChangingTaskboard: true));
    bool value = await kanbanRepository.changeTaskByBoardId(
        event.taskId, event.boardId, event.moveToBoardId);
    try {
      if (value) {
        emit(state.copyWith(
            status: OperationStatus.success,
            boards: await kanbanRepository.getBoards(),
            isChangingTaskboard: false));
      } else {
        emit(state.copyWith(
            status: OperationStatus.failure,
            boards: await kanbanRepository.getBoards()));
      }
    } catch (e) {
      emit(state.copyWith(
        status: OperationStatus.failure,
      ));
    }
  }

  Future<void> exportFile(
      ExportTaskEvent event, Emitter<BoardState> emit) async {
    emit(state.copyWith(generalLoader: ActionStatus.loading));
    String value = await kanbanRepository.exportFile();
    try {
      if (value.isNotEmpty) {
        emit(state.copyWith(
            generalLoader: ActionStatus.normal,
            exportPath: "File saved: " + value));
      } else {
        emit(state.copyWith(
            generalLoader: ActionStatus.normal, exportPath: "Download failed"));
      }
    } catch (e) {
      emit(state.copyWith(
          generalLoader: ActionStatus.normal, exportPath: "Download failed"));
    }
  }

  Future<void> updateTask(
      UpdateTaskEvent event, Emitter<BoardState> emit) async {
    emit(state.copyWith(isAddNewTaskStatus: ActionStatus.loading));
    bool value = await kanbanRepository.updateTask(event.taskId, event.title,
        event.boardId, event.description, event.users, event.tags);
    try {
      if (value) {
        emit(state.copyWith(
            status: OperationStatus.success,
            boards: await kanbanRepository.getBoards(),
            isAddNewTaskStatus: ActionStatus.hide));
        emit(state.copyWith(isAddNewTaskStatus: ActionStatus.normal));
      } else {
        emit(state.copyWith(
            status: OperationStatus.failure,
            boards: await kanbanRepository.getBoards(),
            isAddNewTaskStatus: ActionStatus.normal));
      }
    } catch (e) {
      emit(state.copyWith(
          status: OperationStatus.failure,
          isAddNewTaskStatus: ActionStatus.normal));
    }
  }
}
