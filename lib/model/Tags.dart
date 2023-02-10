import 'package:equatable/equatable.dart';

/// id : 1
/// name : "Electric"
/// color : "Green"

class Tag extends Equatable {
  Tag({
    this.id,
    this.name,
    this.color,
  });

  Tag.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    color = json['color'];
  }

  num? id;
  String? name;
  String? color;

  Tag copyWith({
    num? id,
    String? name,
    String? color,
  }) =>
      Tag(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['color'] = color;
    return map;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, color];
}
