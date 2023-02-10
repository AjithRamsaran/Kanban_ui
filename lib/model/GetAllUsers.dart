import 'package:kanban_ui/model/Users.dart';

/// response : "success"
/// data : [{"id":1,"name":"Ajith","title":"Admin","email":"ajith@gmail.com","phone":"8428056868","country":"India"},{"id":2,"name":"Vikash","title":"Admin","email":"vikash@gmail.com","phone":"8056680856","country":"India"},{"id":3,"name":"Prasanna","title":"Admin","email":"prasanna@gmail.com","phone":"8667351013","country":"India"},{"id":4,"name":"Vijay","title":"Admin","email":"vijay@gmail.com","phone":"8667351099","country":"India"},{"id":5,"name":"Rohit","title":"Admin","email":"rohit@gmail.com","phone":"9876351099","country":"India"},{"id":6,"name":"roshan","title":"Admin","email":"roshan@gmail.com","phone":"8765438291","country":"India"}]

class GetAllUsers {
  GetAllUsers({
      this.response, 
      this.data,});

  GetAllUsers.fromJson(dynamic json) {
    response = json['response'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(User.fromJson(v));
      });
    }
  }
  String? response;
  List<User>? data;
GetAllUsers copyWith({  String? response,
  List<User>? data,
}) => GetAllUsers(  response: response ?? this.response,
  data: data ?? this.data,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['response'] = response;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// name : "Ajith"
/// title : "Admin"
/// email : "ajith@gmail.com"
/// phone : "8428056868"
/// country : "India"

