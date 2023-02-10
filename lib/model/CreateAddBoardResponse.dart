/// response : "success"
/// id : 6

class CreateAddBoardResponse {
  CreateAddBoardResponse({
      this.response, 
      this.id,});

  CreateAddBoardResponse.fromJson(dynamic json) {
    response = json['response'];
    id = json['id'];
  }
  String? response;
  num? id;
CreateAddBoardResponse copyWith({  String? response,
  num? id,
}) => CreateAddBoardResponse(  response: response ?? this.response,
  id: id ?? this.id,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['response'] = response;
    map['id'] = id;
    return map;
  }

}