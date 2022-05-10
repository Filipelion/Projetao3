import 'package:flutter/material.dart';
import 'package:Projetao3/models/professional_skills_list.dart';

class UserViewModel extends ChangeNotifier {
  late bool _isLoggedIn;

  String? _uid;
  ProfessionalSkillsList? _skillsList;

  String? _selectedSkill;
  String? get selectedSkill => _selectedSkill;

  void setSelectedSkill(String skillName, {notify: false}) {
    _selectedSkill = skillName;

    if (notify) {
      notifyListeners();
    }
  }

  // Login methods
  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  // Uid methods
  String? get uid => _uid;
  void setUid(String? value, {notify: true}) {
    _uid = value;

    if (notify) {
      notifyListeners();
    }
  }

  // Professional Skills;
  ProfessionalSkillsList? get professionalSkills => _skillsList;
  void setSkills(ProfessionalSkillsList skills, {notify = false}) {
    _skillsList = skills;

    if (notify) {
      notifyListeners();
    }
  }
}
