import 'package:geolocator/geolocator.dart';
import 'package:Projetao3/core/interfaces/models/base_model.dart';
import 'package:Projetao3/models/professional_skill.dart';

class User implements BaseModel {
  String uid, name, email, gender;
  DateTime? lastSeen;
  List<User>? favorites;
  List<ProfessionalSkill>? skills;
  Position? position;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.gender,
    this.skills,
    this.favorites,
    this.position,
    this.lastSeen,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        uid: json["uid"],
        name: json["nome"],
        gender: json["genero"],
        email: json["email"],
        skills: json["servicos"] == null
            ? null
            : List.from(json["favoritos"])
                .map((user) => ProfessionalSkill.fromJson(user))
                .toList(),
        favorites: json["favoritos"] == null
            ? null
            : List.from(json["favoritos"])
                .map((user) => User.fromJson(user))
                .toList(),
        position: json["localizacao"] == null
            ? null
            : Position.fromMap(json["localizacao"]),
        lastSeen: json["visto_ultimo"] == null
            ? null
            : DateTime.parse(json["visto_ultimo"]),
      );

  Map<String, dynamic> toJson() => {
        "uid": this.uid,
        "nome": this.name,
        "email": this.email,
        "genero": this.gender,
        "servicos": this.skills?.map((e) => e.toJson()).toList(),
        "favoritos": this.favorites?.map((e) => e.toJson()).toList(),
        "localizacao": this.position?.toJson(),
        "visto_ultimo": this.lastSeen?.toIso8601String(),
      };
}
