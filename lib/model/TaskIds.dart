import 'package:kanban_ui/model/task_status.dart';

import 'Tags.dart';
import 'Users.dart';

/// id : 1
/// name : "Add SUV Bug"
/// description : "add sub was not working for a sales people"
/// created_at : "2023-02-06 09:09:00"
/// tags : [{"id":1,"name":"Electric","color":"Green"},{"id":2,"name":"Petrol","color":"Grey"},{"id":3,"name":"Diesel","color":"Yellow"}]
/// users : [{"id":1,"name":"Ajith","title":"Admin","email":"ajith@gmail.com","phone":"8428056868","country":"India"},{"id":2,"name":"Vikash","title":"Admin","email":"vikash@gmail.com","phone":"8056680856","country":"India"}]
/// end_time : "None"
/// time_tracker : []
/// total_time_spent : 0

class Task {
  Task({
      this.id, 
      this.name, 
      this.description, 
      this.createdAt, 
      this.tags, 
      this.users, 
      this.endTime,
      this.totalTimeSpent,});

  Task.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    createdAt = json['created_at'];
    if (json['tags'] != null) {
      tags = [];
      json['tags'].forEach((v) {
        tags?.add(Tag.fromJson(v));
      });
    }
    if (json['users'] != null) {
      users = [];
      json['users'].forEach((v) {
        users?.add(User.fromJson(v));
      });
    }
    endTime = json['end_time'];

    totalTimeSpent = json['total_time_spent'];
  }
  num? id;
  String? name;
  String? description;
  String? createdAt;
  List<Tag>? tags;
  List<User>? users;
  String? endTime;num? totalTimeSpent;
Task copyWith({  num? id,
  String? name,
  String? description,
  String? createdAt,
  List<Tag>? tags,
  List<User>? users,
  String? endTime,
  List<TaskStatus>? timeTracker,
  num? totalTimeSpent,
}) => Task(  id: id ?? this.id,
  name: name ?? this.name,
  description: description ?? this.description,
  createdAt: createdAt ?? this.createdAt,
  tags: tags ?? this.tags,
  users: users ?? this.users,
  endTime: endTime ?? this.endTime,
  totalTimeSpent: totalTimeSpent ?? this.totalTimeSpent,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['created_at'] = createdAt;
    if (tags != null) {
      map['tags'] = tags?.map((v) => v.toJson()).toList();
    }
    if (users != null) {
      map['users'] = users?.map((v) => v.toJson()).toList();
    }
    map['end_time'] = endTime;

    map['total_time_spent'] = totalTimeSpent;
    return map;
  }

}