import 'package:Projetao3/core/interfaces/models/base_model.dart';
import 'package:Projetao3/models/professional_skills_list.dart';

/*
 * This class is the arguments that will be passed 
 * to the /servicos screen
 */

// TODO: Kill this class!! Use the skills provider instead.

class SkillsCrudArguments {
  String skillName;
  ProfessionalSkillsList skillsList;

  SkillsCrudArguments({
    required this.skillName,
    required this.skillsList,
  });
}
