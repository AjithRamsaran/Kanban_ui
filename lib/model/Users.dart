import 'package:equatable/equatable.dart';

/// id : 1
/// name : "Ajith"
/// title : "Admin"
/// email : "ajith@gmail.com"
/// phone : "8428056868"
/// country : "India"

class User extends Equatable{
  User({
      this.id, 
      this.name, 
      this.title, 
      this.email, 
      this.phone, 
      this.country,});

  User.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    title = json['title'];
    email = json['email'];
    phone = json['phone'];
    country = json['country'];
  }
  num? id;
  String? name;
  String? title;
  String? email;
  String? phone;
  String? country;
User copyWith({  num? id,
  String? name,
  String? title,
  String? email,
  String? phone,
  String? country,
}) => User(  id: id ?? this.id,
  name: name ?? this.name,
  title: title ?? this.title,
  email: email ?? this.email,
  phone: phone ?? this.phone,
  country: country ?? this.country,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['title'] = title;
    map['email'] = email;
    map['phone'] = phone;
    map['country'] = country;
    return map;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id,name,title,email,phone,country];



}