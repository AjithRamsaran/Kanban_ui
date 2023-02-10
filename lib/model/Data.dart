import 'TaskIds.dart';

/// id : 1
/// name : "TO DO"
/// description : "list of all task to do"
/// company_id : "1"
/// task_ids : [{"id":1,"name":"Add SUV Bug","description":"add sub was not working for a sales people","created_at":"2023-02-06 09:09:00","tags":[{"id":1,"name":"Electric","color":"Green"},{"id":2,"name":"Petrol","color":"Grey"},{"id":3,"name":"Diesel","color":"Yellow"}],"users":[{"id":1,"name":"Ajith","title":"Admin","email":"ajith@gmail.com","phone":"8428056868","country":"India"},{"id":2,"name":"Vikash","title":"Admin","email":"vikash@gmail.com","phone":"8056680856","country":"India"}],"end_time":"None","time_tracker":[],"total_time_spent":0},{"id":2,"name":"Add XUV Bug","description":"bug fix needs to be implemented","created_at":"2023-01-02 01:00:01","tags":[],"users":[],"end_time":"None","time_tracker":[],"total_time_spent":0}]

class Board {
  Board(
      {this.id,
      this.name,
      this.description,
      this.companyId,
      this.taskIds,
      this.isEnd});

  Board.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    companyId = json['company_id'];
    if (json['task_ids'] != null) {
      taskIds = [];
      json['task_ids'].forEach((v) {
        taskIds?.add(Task.fromJson(v));
      });
    }
    isEnd = (json['is_end'] ?? 0) == 1 ? true : false;
  }

  num? id;
  String? name;
  String? description;
  String? companyId;
  List<Task?>? taskIds;
  bool? isEnd;

  Board copyWith(
          {num? id,
          String? name,
          String? description,
          String? companyId,
          List<Task>? taskIds,
          bool? isEnd}) =>
      Board(
          id: id ?? this.id,
          name: name ?? this.name,
          description: description ?? this.description,
          companyId: companyId ?? this.companyId,
          taskIds: taskIds ?? this.taskIds,
          isEnd: isEnd ?? this.isEnd);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['company_id'] = companyId;
    if (taskIds != null) {
      map['task_ids'] = taskIds?.map((v) => v?.toJson()).toList();
    }
    map['is_end'] = isEnd;
    return map;
  }
}
