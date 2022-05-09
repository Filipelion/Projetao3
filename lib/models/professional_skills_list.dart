/*
 * This class is a representation of the 'Carta Serviços' table.
 * It contains a list of the professional skills the worker has.
 * 
 * To get a specific professional skill, you must pass the type of service
 */

import 'package:Projetao3/core/interfaces/models/base_model.dart';
import 'package:Projetao3/models/professional_skill.dart';

class ProfessionalSkillsList implements BaseModel {
  String id;
  List<ProfessionalSkill> list;

  ProfessionalSkillsList({required this.id, required this.list});

  factory ProfessionalSkillsList.fromJson(Map<String, dynamic> json) =>
      ProfessionalSkillsList(
        id: json["id"],
        list: json["servicos"] == null
            ? []
            : List.from(json["servicos"])
                .map((skill) => ProfessionalSkill.fromJson(skill))
                .toList(),
      );

  //TODO: Test this method. It might cause an error in the future.
  //TODO: Date: 10/04/2022
  Map<String, dynamic> toJson() => {
        "id": this.id,
        "servicos": this.list.map((service) => service.toJson()).toList()
      };
}
