import 'package:Projetao3/core/interfaces/models/base_model.dart';

class Worker implements BaseModel {
  String uid, tag, name;

  Worker({
    required this.uid,
    required this.tag,
    required this.name,
  });

  factory Worker.fromJson(Map<String, dynamic> json) => Worker(
        uid: json["uid"],
        tag: json["tag"],
        name: json["name"],
      );

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
