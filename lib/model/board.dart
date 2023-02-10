import 'package:kanban_ui/model/task.dart';

/// id : 1
/// title : "Board title"
/// tasks : [{"id":1}]

/*
class Board {
  late int _id;
  late String _title;
  late List<Task> _tasks;

  int get id => _id;

  String get title => _title;

  List<Task> get tasks => _tasks;

  Board({required int id, required String title, required List<Task> tasks}) {
    _id = id;
    _title = title;
    _tasks = tasks;
  }

  Board.fromJson(dynamic json) {
    _id = json["id"];
    _title = json["title"];
    if (json["tasks"] != null) {
      _tasks = [];
      json["tasks"].forEach((v) {
        _tasks.add(Task.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["title"] = _title;
    if (_tasks != null) {
      map["tasks"] = _tasks.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
*/
