part of 'board_bloc.dart';

@immutable
abstract class BoardEvent {}

class AddTaskEvent extends BoardEvent {

}

class DeleteTaskEvent extends BoardEvent {

}


class UpdateTaskEvent extends BoardEvent {

}

class BoardStarted extends BoardEvent {

}