import 'Tags.dart';

class GetTag {
  GetTag({
    required this.response,
    required this.data,
  });

  GetTag.fromJson(dynamic json) {
    response = json['response'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(Tag.fromJson(v));
      });
    }
  }

  late String response;
  late List<Tag> data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['response'] = response;
    if (data != null) {
      map['data'] = data.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
