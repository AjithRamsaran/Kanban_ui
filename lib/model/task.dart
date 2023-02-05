import 'package:equatable/equatable.dart';
import 'package:kanban_ui/model/task_status.dart';
import 'package:kanban_ui/model/time_tracking.dart';
import 'package:kanban_ui/model/user.dart';

/// id : 1
/// taskText : "Make Coffee"
/// users : [{"id":12,"name":"Ajith R","title":"Developer","email":"ajith@gmail.com","phoneNumber":"842805696965","countryCode":"91"}]
/// createdAt : ""
/// completedAt : ""
/// status : ""

class Task extends Equatable {
  late int id;
  late String taskText;
  late List<User> users;
  late String createdAt;
  String? completedAt;
  late TaskStatus status;
  TimeTracking? timeTracking;

  Task(
      {required this.id,
      required this.taskText,
      required this.users,
      required this.createdAt,
      this.completedAt,
      required this.status, this.timeTracking});

  Task.fromJson(dynamic json) {
    id = json["id"];
    taskText = json["taskText"];
    if (json["users"] != null) {
      users = [];
      json["users"].forEach((v) {
        users.add(User.fromJson(v));
      });
    }
    createdAt = json["createdAt"];
    completedAt = json["completedAt"];
    status = TaskStatus.fromJson(json["status"]);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["taskText"] = taskText;
    if (users != null) {
      map["users"] = users.map((v) => v.toJson()).toList();
    }
    map["createdAt"] = createdAt;
    map["completedAt"] = completedAt;
    map["status"] = status;
    return map;
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
      [id, taskText, users, createdAt, completedAt, status];
}

/// id : 12
/// name : "Ajith R"
/// title : "Developer"
/// email : "ajith@gmail.com"
/// phoneNumber : "842805696965"
/// countryCode : "91"
