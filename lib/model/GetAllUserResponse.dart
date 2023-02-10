import 'package:kanban_ui/model/Users.dart';



class GetAllUserResponse {
  GetAllUserResponse({
      required this.response,
      required this.data,});

  GetAllUserResponse.fromJson(dynamic json) {
    response = json['response'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(User.fromJson(v));
      });
    }
  }
  late String response;
  late List<User> data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['response'] = response;
    if (data != null) {
      map['data'] = data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}