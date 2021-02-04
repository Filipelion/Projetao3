import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './loginAuth.dart';

class Servico {
  String tipo, descricao;
  num valorMedio;
  Map imagens;

  Servico({this.tipo, this.descricao,  this.valorMedio, this.imagens});

  Servico.fromJson(Map<String, dynamic> json) {
    if(json == null) return;
    this.tipo = json["tipo"] ?? "";
    this.descricao = json["descricao"] ?? "";
    this.valorMedio = json["valorMedio"] ?? "";
    this.imagens = json["imagens"] ?? {};
  }

  Map<String, dynamic> toJson() => {
    "tipo" : this.tipo,
    "descricao" : this.descricao,
    "valorMedio" : this.valorMedio,
    "imagens" : this.imagens,
  };
}

class CartaServicos {
  String id;
  Map<String, dynamic>  cartaServicos; 

  CartaServicos({this.id, this.cartaServicos});

  Map<String, dynamic> get() {
    return this.cartaServicos;
  }

  Map save(String tipo, Map<String, dynamic> data) {
    this.cartaServicos[tipo] = data;
    return this.cartaServicos;
  }

  Map remove(String tipo) {
    cartaServicos.remove(tipo);
    return this.cartaServicos;
  }

  List titles() {
    return cartaServicos.keys.toList();
  }
}


class CartaServicosController {
  CollectionReference _servicos;

  CartaServicosController() {
    this._servicos = FirebaseFirestore.instance.collection("Servicos");
  }

  FutureOr<CartaServicos> get(String id) async {
    DocumentSnapshot snapshot = await this._servicos.doc(id).get();
    Map data = snapshot.data();
    return CartaServicos(id: id, cartaServicos: data);
  }

  FutureOr<DocumentReference> save(CartaServicos cartaServicos) async {
    Map data = cartaServicos.get();
    String id = cartaServicos.id;

    DocumentReference reference = this._servicos.doc(id);
    reference.set(data).then((value)  {
      return reference;
    });
  }

}