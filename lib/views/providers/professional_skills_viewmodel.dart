import 'package:flutter/material.dart';
import 'package:Projetao3/models/professional_skill.dart';
import 'package:Projetao3/models/professional_skills_list.dart';

class ProfessionalSkillsViewModel extends ChangeNotifier {
  late String id;
  late ProfessionalSkillsList _skills;

  ProfessionalSkillsList get() => this._skills;

  ProfessionalSkill? getSkill(String tipo) {
    try {
      var skill =
          this._skills.list.firstWhere((element) => element.name == tipo);

      return skill;
    } catch (e) {
      return null;
    }
  }

  void save(String tipo, ProfessionalSkill skill) {
    var index = this._skills.list.indexWhere((element) => element.name == tipo);
    this._skills.list[index] = skill;

    notifyListeners();
  }

  void remove(String tipo) {
    this._skills.list.removeWhere((element) => element.name == tipo);
    notifyListeners();
  }

  List<String> tipos() {
    return this._skills.list.map((e) => e.name).toList();
  }
}
