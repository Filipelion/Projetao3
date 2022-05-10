import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:Projetao3/core/locator.dart';
import 'package:Projetao3/models/generic_user.dart';
import 'package:Projetao3/models/professional_skill.dart';
import 'package:Projetao3/models/professional_skills_list.dart';
import 'package:Projetao3/repository/professional_skills_repository.dart';
import 'package:Projetao3/repository/user_repository.dart';
import 'package:Projetao3/services/login_service.dart';
import 'package:Projetao3/services/tags_service.dart';
import 'package:Projetao3/views/shared/utils.dart';

class UserController {
  final _repository = locator<UserRepository>();
  final _skillsRepository = locator<ProfessionalSkillsRepository>();
  final _loginService = locator<LoginService>();
  final _tagsService = locator<TagsService>();

  Future<Position> userLocation(String id) async =>
      await _repository.getUserLocation(id);

  authenticationStateMonitor() {
    // Verify if the user login state has changed;
    _loginService.authChangeListener();
  }

  Future<bool> userExists(String uid) async =>
      await _repository.userExists(uid);

  bool isLoggedIn() => _loginService.userIsLoggedIn();
  String? get uid => _loginService.getUid();
  String? get email => _loginService.getUserEmail();
  String? get userName => _loginService.getUserProfileName();
  String? get photo => _loginService.getUserProfilePhoto();

  Future<ProfessionalSkillsList>? getSkills(String uid) async =>
      await _repository.getUserSkillsList(uid);

  Future<List> getTags(String tag) async {
    var tags = await _tagsService.getSameClusterTags(tag: tag);
    return tags['tags'];
  }

  Future<void> saveUser(GenericUser user) async => await _repository.save(user);

  Future<void> saveSkills(ProfessionalSkillsList skills) async =>
      await _skillsRepository.save(skills);

  Future<List<GenericUser>> listAllWorkers(String tag) async =>
      await _repository.getAllWorkers(tag);

  Future<void> addSkill(
          ProfessionalSkill skill, ProfessionalSkillsList occupations) async =>
      await _skillsRepository.addSkill(skill, occupations);

  Future<GenericUser> updateLocationAndLastSeen() async {
    String vistoUltimo = Utils.setLastSeen();
    Map localizacao = await updateCurrentGeolocation(uid!);

    Map<String, dynamic> data = {
      'visto_ultimo': vistoUltimo,
      'localizacao': localizacao,
    };

    GenericUser user = await _repository.getUser(uid!);
    user.lastSeen = DateTime.now();
    user.position = Position.fromMap(data);

    var updatedUser = await _repository.update(uid!, user.toJson());
    print("Posição atualizada com sucesso!");

    return user;
  }

  Future<Map> updateCurrentGeolocation(String uid) async =>
      await _repository.updateCurrentGeolocation(uid);
}
