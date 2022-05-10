import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Projetao3/models/professional_skill.dart';
import 'package:Projetao3/models/professional_skills_list.dart';
import 'package:Projetao3/repository/shared/tables_name.dart';
import 'dart:async';

// TODO: Kill file
class ProfessionalSkillsRepository {
  final _tableName = TablesName.CartaServicos;
  late CollectionReference _servicos;

  ProfessionalSkillsRepository() {
    this._servicos = FirebaseFirestore.instance.collection(_tableName);
  }

  Future<ProfessionalSkillsList> get(String id) async {
    ProfessionalSkillsList cartaServicos =
        await this._servicos.doc(id).get().then((value) {
      var data = json.decode(value.data().toString()) as List;
      var skills = data
          .map(
            (item) => ProfessionalSkill.fromJson(item),
          )
          .toList();

      return ProfessionalSkillsList(id: id, list: skills);
    });
    print("Testando a função get de CartaServicosController");
    return cartaServicos;
  }

  Future<DocumentReference> addSkill(
    ProfessionalSkill skill,
    ProfessionalSkillsList occupations,
  ) async {
    // Adding a service to the end of the list.
    var data = occupations.list;
    data.add(skill);

    occupations.list = data;
    return await save(occupations);
  }

  Future<DocumentReference> save(ProfessionalSkillsList cartaServicos) async {
    var data = cartaServicos.list;
    String id = cartaServicos.id;

    DocumentReference reference = this._servicos.doc(id);
    await reference.set(data);

    return reference;
  }

  Future<bool> isInDatabase(String id) async {
    DocumentSnapshot snapshot = await this._servicos.doc(id).get();
    try {
      return snapshot.exists;
    } catch (e) {
      return false;
    }
  }
}
