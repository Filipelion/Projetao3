import 'package:Projetao3/core/interfaces/models/base_model.dart';

class ProfessionalSkill implements BaseModel {
  String name, description;
  num? meanValue;
  List? images;

  ProfessionalSkill(
      {required this.name,
      required this.description,
      this.meanValue,
      this.images});

  factory ProfessionalSkill.fromJson(Map<String, dynamic> json) =>
      ProfessionalSkill(
        name: json["tipo"]!,
        description: json["descricao"],
        meanValue: json["valorMedio"] ?? 0,
        images: json["imagens"] ?? [],
      );

  Map<String, dynamic> toJson() => {
        "tipo": this.name,
        "descricao": this.description,
        "valorMedio": this.meanValue,
        "imagens": this.images,
      };
}
