import 'package:equatable/equatable.dart';

/// id : 1
/// name : "Task status"

class TaskStatus extends Equatable{
  late int id;
  late String status;
  late String createdAt;
  String? endAt;

  TaskStatus(
      {required this.id,
      required this.status,
      required this.createdAt,
      this.endAt});

  TaskStatus.fromJson(dynamic json) {
    id = json["id"] ?? 0;
    status = json["status"] ?? "";
    createdAt = json["createdAt"] ?? "";
    endAt = json["endAt"] ?? "";
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["status"] = status;
    map["createdAt"] = createdAt;
    map["endAt"] = endAt;
    return map;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, status, createdAt, endAt];
}
