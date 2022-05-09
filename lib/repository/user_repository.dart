import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Projetao3/core/enums/gender.dart';
import 'package:Projetao3/core/locator.dart';
import 'package:Projetao3/models/generic_user.dart';
import 'package:Projetao3/models/professional_skill.dart';
import 'package:Projetao3/models/professional_skills_list.dart';
import 'package:Projetao3/repository/shared/tables_name.dart';
import 'package:Projetao3/services/login_service.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import '../services/login_service.dart';
import '../services/geolocation_service.dart';
import 'package:intl/intl.dart';

// TODO: Kill file
class UserRepository {
  final String _tableName = TablesName.User;
  late CollectionReference _usuarios;

  UserRepository() {
    this._usuarios = FirebaseFirestore.instance.collection(_tableName);
  }

  Future<DocumentReference> _getDocumentReference(String id) async {
    return this._usuarios.doc(id);
  }

  Future<DocumentSnapshot> _getUsuarioByID(String id) async {
    DocumentReference reference = await this._getDocumentReference(id);
    return reference.get();
  }

  Future<GenericUser> getUser(String id) async {
    try {
      // Tentando recuperar os dados do usuário do banco de dados
      DocumentSnapshot snapshot = await this._getUsuarioByID(id);

      GenericUser? user = snapshot.data() as GenericUser;
      return user;
    } catch (e) {
      // Caso não dê para recuperar do CloudFirestore, os datas serão extraídos da autenticação
      User? user = locator<LoginService>().getUser();

      // TODO: Gender param is mocked.
      GenericUser usuario = GenericUser(
        uid: user!.uid,
        name: user.displayName!,
        email: user.email!,
        gender: Gender.Other,
      );

      return usuario;
    }
  }

  FutureOr<List<GenericUser>> getAllWorkers(String tag) async {
    QuerySnapshot snapshot = await _usuarios.get();
    List<GenericUser> workers = [];

    for (var user in snapshot.docs) {
      Object? workerData = user.data();

      DocumentReference ref = (workerData! as dynamic)["servicos"];

      var skillsData = await ref.get().then((value) => value.data() as dynamic);
      var skills = List<ProfessionalSkill>.from(skillsData);

      var worker = workerData as GenericUser;
      worker.skills = skills;

      var hasTag = skills.where((element) => element.name == tag).isNotEmpty;

      if (hasTag) {
        workers.add(workerData);
      }
    }

    return workers;
  }

  FutureOr<bool> userExists(String id) async {
    DocumentSnapshot documentSnapshot = await this._getUsuarioByID(id);
    try {
      return documentSnapshot.exists;
    } catch (e) {
      return false;
    }
  }

  void saveUsuario(GenericUser usuario) async {
    String uid = usuario.uid;
    Map usuarioData = usuario.toJson();
    usuarioData['visto_ultimo'] = this.setVistoUltimo();
    usuarioData['localizacao'] = await this.updateCurrentGeolocation(uid);

    _usuarios.doc(uid).set(usuarioData);
  }

  removeUsuario(String id) async {
    return await _usuarios.doc(id).delete();
  }

  String setVistoUltimo() {
    // Atualizando o horário
    DateTime now = DateTime.now();
    final formatter = DateFormat('dd/MM/yyyy');
    String today = formatter.format(now);

    return today;
  }

  Future<ProfessionalSkillsList> getUserSkillsList(String id) async {
    try {
      GenericUser user = await this.getUser(id);
      List<ProfessionalSkill>? skills = user.skills;

      print("Testando a função getUsuarioCartaServicos..");

      return ProfessionalSkillsList(id: id, list: skills ?? []);
    } catch (e) {
      return ProfessionalSkillsList(id: id, list: []);
    }
  }

  Future<Map> updateCurrentGeolocation(String uid) async {
    final geolocation = GeolocationService();
    Position position = await geolocation.getCurrentLocation();

    Map<String, dynamic> localizacaoData = position.toJson();
    return localizacaoData;
  }

  Future<Position> getUsuarioLocation(String id) async {
    GenericUser user = await this.getUser(id);
    return user.position!;
  }

  Future<void> update(String uid, Map<String, dynamic> data) async {
    DocumentReference ref = await this._getDocumentReference(uid);
    ref.update(data);
  }
}
