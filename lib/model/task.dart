import 'package:equatable/equatable.dart';
import 'package:kanban_ui/model/tag.dart';
import 'package:kanban_ui/model/task_status.dart';
import 'package:kanban_ui/model/time_tracking.dart';
import 'package:kanban_ui/model/user.dart';

import 'Users.dart';

/// id : 1
/// taskText : "Make Coffee"
/// users : [{"id":12,"name":"Ajith R","title":"Developer","email":"ajith@gmail.com","phoneNumber":"842805696965","countryCode":"91"}]
/// createdAt : ""
/// completedAt : ""
/// status : ""

/*
class Task extends Equatable {
  late int id;
  late String description;
  late List<User> users;
  late String createdAt;
  String? completedAt;
  late TaskStatus status;
  TimeTracking? timeTracking;
  late List<Tag> tags;

  Task(
      {required this.id,
      required this.description,
      required this.users,
      required this.createdAt,
      this.completedAt,
      required this.status,
      this.timeTracking,
      this.tags = const <Tag>[]});

  Task.fromJson(dynamic json) {
    id = json["id"];
    description = json["taskText"];
    if (json["users"] != null) {
      users = [];
      json["users"].forEach((v) {
        users.add(User.fromJson(v));
      });
    }
    createdAt = json["createdAt"];
    completedAt = json["completedAt"];
    status = TaskStatus.fromJson(json["status"]);
    tags = json["tags"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["taskText"] = description;
    if (users != null) {
      map["users"] = users.map((v) => v.toJson()).toList();
    }
    map["createdAt"] = createdAt;
    map["completedAt"] = completedAt;
    map["status"] = status;
    map["tags"] = tags;
    return map;
  }

  copyWith(
      int? id,
      String? description,
      List<User>? users,
      String? createdAt,
      String? completedAt,
      TaskStatus? status,
      TimeTracking? timeTracking,
      List<Tag>? tags) {
    return Task(
        id: id ?? this.id,
        description: description ?? this.description,
        users: users ?? this.users,
        createdAt: createdAt ?? this.createdAt,
        status: status ?? this.status,
        completedAt: completedAt ?? this.completedAt,
        tags: tags ?? this.tags,
        timeTracking: timeTracking ?? this.timeTracking);
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
      [id, description, users, createdAt, completedAt, status];
}
*/

/// id : 12
/// name : "Ajith R"
/// title : "Developer"
/// email : "ajith@gmail.com"
/// phoneNumber : "842805696965"
/// countryCode : "91"
