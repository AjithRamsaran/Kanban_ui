import 'package:kanban_ui/model/task_status.dart';

/// id : 1
/// taskId : 2
/// timeTrackings : [{"id":3,"status":"Status","createdAt":"","endAt":""}]

class TimeTracking {
  late int id;
  late int taskId;
  late List<TaskStatus> timeTrackings;

  TimeTracking({
      required this.id,
      required this.taskId,
      required this.timeTrackings});

  TimeTracking.fromJson(dynamic json) {
    id = json["id"];
    taskId = json["taskId"];
    if (json["timeTrackings"] != null) {
      timeTrackings = [];
      json["timeTrackings"].forEach((v) {
        timeTrackings.add(TaskStatus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["taskId"] = taskId;
    if (timeTrackings != null) {
      map["timeTrackings"] = timeTrackings.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 3
/// status : "Status"
/// createdAt : ""
/// endAt : ""