import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  String uid, nome, email, genero;
  List favoritos;
  DocumentReference servicos;

  Usuario({this.uid, this.nome, this.email, this.genero, this.servicos, this.favoritos});

  Usuario.fromJson(Map<String, dynamic> json) {
    if(json == null) return;
    this.uid = json["uid"];
    this.nome = json["nome"];
    this.genero = json["genero"];
    this.email = json["email"];
    this.servicos = json["servicos"];
    this.favoritos = json["favoritos"];
  }

  Map<String, dynamic> toJson() => {
    "uid" : this.uid,
    "nome" : this.nome,
    "email" : this.email,
    "genero" : this.genero,
    "servicos" : this.servicos,
    "favoritos" : this.favoritos,
  };
}