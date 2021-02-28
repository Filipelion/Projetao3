import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  String uid, nome, email, genero, visto_ultimo;
  List favoritos;
  DocumentReference servicos;
  Map localizacao;

  Usuario({
    this.uid,
    this.nome,
    this.email,
    this.genero,
    this.servicos,
    this.favoritos,
    this.localizacao,
    this.visto_ultimo,
  });

  Usuario.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    this.uid = json["uid"];
    this.nome = json["nome"];
    this.genero = json["genero"];
    this.email = json["email"];
    this.servicos = json["servicos"];
    this.favoritos = json["favoritos"];
    this.localizacao = json["localizacao"];
    this.visto_ultimo = json["visto_ultimo"];
  }

  Map<String, dynamic> toJson() => {
        "uid": this.uid,
        "nome": this.nome,
        "email": this.email,
        "genero": this.genero,
        "servicos": this.servicos,
        "favoritos": this.favoritos,
        "localizacao": this.localizacao,
        "visto_ultimo": this.visto_ultimo,
      };
}
