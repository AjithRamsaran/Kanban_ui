import 'package:equatable/equatable.dart';

/// id : 12
/// name : "Ajith R"
/// title : "Developer"
/// email : "ajith@gmail.com"
/// phoneNumber : "842805696965"
/// countryCode : "91"

class User1 extends Equatable {
  late int id;
  late String name;
  late String title;
  late String email;
  String? phoneNumber;
  String? countryCode;

  User1(
      {required this.id,
      required this.name,
      required this.title,
      required this.email,
      this.phoneNumber,
      this.countryCode});

  User1.fromJson(dynamic json) {
    id = json["id"] ?? 0;
    name = json["name"] ?? "";
    title = json["title"] ?? "";
    email = json["email"] ?? "";
    phoneNumber = json["phoneNumber"] ?? "";
    countryCode = json["countryCode"] ?? "";
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["title"] = title;
    map["email"] = email;
    map["phoneNumber"] = phoneNumber;
    map["countryCode"] = countryCode;
    return map;
  }



  @override
  // TODO: implement props
  List<Object?> get props => [id, name, title, email, phoneNumber, countryCode];


}
