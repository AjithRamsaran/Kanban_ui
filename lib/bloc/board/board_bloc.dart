import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kanban_ui/model/board.dart';
import 'package:kanban_ui/repository/kanban_repository.dart';
import 'package:meta/meta.dart';

import '../../model/task.dart';

part 'board_event.dart';

part 'board_state.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  BoardBloc({required this.kanbanRepository})
      : super(BoardState(operationStatus: OperationStatus.initial)) {
    on<BoardStarted>(getBoards);
  }

  KanbanRepository kanbanRepository;

  Future<void> getBoards(BoardStarted event, Emitter<BoardState> emit) async {
    emit(state.copyWith(status: OperationStatus.loading, tasks: []));
    try {
      emit(state.copyWith(
          status: OperationStatus.success,
          tasks: await kanbanRepository.getBoards()));
    } catch (e) {
      emit(state.copyWith(status: OperationStatus.failure, tasks: []));
    }
  }
}
