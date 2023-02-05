part of 'board_bloc.dart';

enum OperationStatus { initial, loading, success, failure }

class BoardState extends Equatable {
  final OperationStatus operationStatus;
  final List<Board>? boards;

  BoardState({required this.operationStatus, this.boards});

  BoardState copyWith({OperationStatus? status, List<Board>? tasks}) {
    return BoardState(
      operationStatus: status ?? this.operationStatus,
      boards: tasks ?? this.boards,
    );
  }

  @override
  List<Object> get props {
    return [operationStatus];
  }
}
