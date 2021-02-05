import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './loginAuth.dart';

class Usuario {
  String uid, nome, email, genero;
  Map servicos, favoritos;

  Usuario(
      {this.uid,
      this.nome,
      this.email,
      this.genero,
      this.servicos,
      this.favoritos});

  Usuario.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    this.uid = json["uid"];
    this.nome = json["nome"];
    this.genero = json["genero"];
    this.email = json["email"];
    this.servicos = json["servicos"];
    this.favoritos = json["favoritos"];
  }

  Map<String, dynamic> toJson() => {
        "uid": this.uid,
        "nome": this.nome,
        "email": this.email,
        "genero": this.genero,
        "servicos": this.servicos,
        "favoritos": this.favoritos,
      };
}

class UsuarioController {
  CollectionReference _usuarios;

  UsuarioController() {
    this._usuarios = FirebaseFirestore.instance.collection("Usuario");
  }

  Future<DocumentSnapshot> getUsuarioByID(String id) {
    return this._usuarios.doc(id).get();
  }

  FutureOr<Usuario> getUsuarioData(String id) async {
    try {
      // Tentando recuperar os dados do usuário do banco de dados
      DocumentSnapshot snapshot = await this.getUsuarioByID(id);
      Map usuarioData = snapshot.data();
      // TODO: Analisar o que tem de errado aqui
      Usuario usuario = Usuario.fromJson(usuarioData);
      return usuario;
    } catch (e) {
      // Caso não dê para recuperar do CloudFirestore, os datas serão extraídos da autenticação
      User user = Authentication.loginAuth.getUser();
      Usuario usuario =
          Usuario(uid: user.uid, nome: user.displayName, email: user.email);
      return usuario;
    }
  }

  FutureOr<bool> usuarioIsInDatabase(String id) async {
    DocumentSnapshot documentSnapshot = await this.getUsuarioByID(id);
    try {
      return documentSnapshot.exists;
    } catch (e) {
      return false;
    }
  }

  void saveUsuario(Usuario usuario) async {
    String uid = usuario.uid;
    Map usuarioData = usuario.toJson();
    _usuarios.doc(uid).set(usuarioData);
  }

  removeUsuario(String id) async {
    return await _usuarios.doc(id).delete();
  }
}

class DatabaseIntegration {
  static final UsuarioController usuarioController = UsuarioController();
}
