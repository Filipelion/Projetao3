import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  String uid, nome, email;
  Map servicos, favoritos;

  Usuario({this.uid, this.nome, this.email, this.servicos, this.favoritos});

  Usuario.fromJson(Map<String, dynamic> json) {
    if(json == null) return;
    this.uid = json["uid"];
    this.uid = json["nome"];
    this.email = json["email"];
    this.servicos = json["servicos"];
    this.favoritos = json["favoritos"];
  }

  Map<String, dynamic> toJson() => {
    "uid" : this.uid,
    "nome" : this.nome,
    "email" : this.email,
    "servicos" : this.servicos,
    "favoritos" : this.favoritos,
  };
}

class UsuarioController {
  CollectionReference _usuarios;

  UsuarioController() {
    this._usuarios = FirebaseFirestore.instance.collection("Usuario");
  }

  DocumentReference getUsuarioByID(String id) {
    return this._usuarios.doc(id);
  }

  Future<bool> usuarioIsInDatabase(String id) {
    return this.getUsuarioByID(id).snapshots().isEmpty;
  }

  
}

class DatabaseIntegration {
  static final UsuarioController usuarioController = UsuarioController();
}