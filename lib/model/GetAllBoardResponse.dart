import 'Data.dart';

/// response : "success"
/// data : [{"id":1,"name":"TO DO","description":"list of all task to do","company_id":"1","task_ids":[{"id":1,"name":"Add SUV Bug","description":"add sub was not working for a sales people","created_at":"2023-02-06 09:09:00","tags":[{"id":1,"name":"Electric","color":"Green"},{"id":2,"name":"Petrol","color":"Grey"},{"id":3,"name":"Diesel","color":"Yellow"}],"users":[{"id":1,"name":"Ajith","title":"Admin","email":"ajith@gmail.com","phone":"8428056868","country":"India"},{"id":2,"name":"Vikash","title":"Admin","email":"vikash@gmail.com","phone":"8056680856","country":"India"}],"end_time":"None","time_tracker":[],"total_time_spent":0},{"id":2,"name":"Add XUV Bug","description":"bug fix needs to be implemented","created_at":"2023-01-02 01:00:01","tags":[],"users":[],"end_time":"None","time_tracker":[],"total_time_spent":0}]},{"id":2,"name":"PENDING","description":"list of all Pending task","company_id":"1","task_ids":"[]","tasks":[]},{"id":3,"name":"DONE","description":"list of all Completed task","company_id":"1","task_ids":[{"id":4,"name":"Add RUV Bug","description":"bug fix needs to be implemented","created_at":"2023-01-02 02:00:01","tags":[{"id":1,"name":"Electric","color":"Green"}],"users":[{"id":4,"name":"Vijay","title":"Admin","email":"vijay@gmail.com","phone":"8667351099","country":"India"}],"end_time":"2023-02-06 23:05:23","time_tracker":[{"timeSpent":1265,"lastUpdatedTime":"2023-02-06 23:05:01","from":"1","to":"2"},{"timeSpent":0,"lastUpdatedTime":"2023-02-06 23:05:23","from":"2","to":"3"}],"total_time_spent":1265}]},{"id":4,"name":"TECH DEBT","description":"all tech debt task","company_id":"1","task_ids":[{"id":3,"name":"Add AUV Bug","description":"bug fix needs to be implemented","created_at":"2023-01-02 02:00:01","tags":[{"id":1,"name":"Electric","color":"Green"}],"users":[{"id":4,"name":"Vijay","title":"Admin","email":"vijay@gmail.com","phone":"8667351099","country":"India"}],"end_time":"None","time_tracker":[],"total_time_spent":0}]}]

class GetAllBoardResponse {
  GetAllBoardResponse({
      this.response, 
      this.data,});

  GetAllBoardResponse.fromJson(dynamic json) {
    response = json['response'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Board.fromJson(v));
      });
    }
  }
  String? response;
  List<Board>? data;
GetAllBoardResponse copyWith({  String? response,
  List<Board>? data,
}) => GetAllBoardResponse(  response: response ?? this.response,
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