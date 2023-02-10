/// response : "success"
/// data : [{"id":3,"name":"Volvo","description":"An electric car model start up","details":"","status":"1"}]

class OrganisationResponse {
  String? response;
  List<Data>? data;

  OrganisationResponse({
      this.response, 
      this.data});

  OrganisationResponse.fromJson(dynamic json) {
    response = json["response"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["response"] = response;
    if (data != null) {
      map["data"] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 3
/// name : "Volvo"
/// description : "An electric car model start up"
/// details : ""
/// status : "1"

class Data {
  int? id;
  String? name;
  String? description;
  String? details;
  String? status;

  Data({
      this.id, 
      this.name, 
      this.description, 
      this.details, 
      this.status});

  Data.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    description = json["description"];
    details = json["details"];
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["description"] = description;
    map["details"] = details;
    map["status"] = status;
    return map;
  }

}