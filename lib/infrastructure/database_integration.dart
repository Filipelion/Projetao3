import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './loginAuth.dart';
import './usuario.dart';
import 'cartaServico.dart';

class UsuarioController {
  CollectionReference _usuarios;

  UsuarioController() {
    this._usuarios = FirebaseFirestore.instance.collection("Usuario");
  }

  Future<DocumentSnapshot> getUsuarioByID(String id) {
    return this._usuarios.doc(id).get();
  }

  Future<Usuario> getUsuarioData(String id) async {
    try {
      // Tentando recuperar os dados do usuário do banco de dados
      DocumentSnapshot snapshot = await this.getUsuarioByID(id);
      Map usuarioData = snapshot.data();
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

  Future<List> getAllWorkers() async {
    QuerySnapshot snapshot = await _usuarios.get();
    snapshot.docs.map((document) {
      Map<String, dynamic> workerData = document.data();
      return workerData;
    }).toList();
  }

  FutureOr<bool> usuarioIsInDatabase(String id) async {
    DocumentSnapshot documentSnapshot = await this.getUsuarioByID(id);
    try {
      return documentSnapshot.exists;
    } catch (e) {
      return false;
    }
  }

  Stream<QuerySnapshot> getUsuarioSnapshots() {
    return this._usuarios.snapshots();
  }

  void saveUsuario(Usuario usuario) async {
    String uid = usuario.uid;
    Map usuarioData = usuario.toJson();
    _usuarios.doc(uid).set(usuarioData);
  }

  removeUsuario(String id) async {
    return await _usuarios.doc(id).delete();
  }

  Future<CartaServicos> getUsuarioCartaServicos(String id) async {
    Usuario usuario = await this.getUsuarioData(id);
    DocumentReference snapshot = usuario.servicos;
    print("Testando a função getUsuarioCartaServicos..");

    try {
      DocumentSnapshot data = await snapshot.get();
      return CartaServicos(id: id, cartaServicos: data.data());
    } catch (e) {
      return CartaServicos(id: id, cartaServicos: {});
    }
  }
}

class CartaServicosController {
  CollectionReference _servicos;

  CartaServicosController() {
    this._servicos = FirebaseFirestore.instance.collection("CartaServicos");
  }

  Future<CartaServicos> get(String id) async {
    CartaServicos cartaServicos =
        await this._servicos.doc(id).get().then((value) {
      Map data = value.data();
      return CartaServicos(id: id, cartaServicos: data);
    });
    print("Testando a função get de CartaServicosController");
    return cartaServicos;
  }

  FutureOr<DocumentReference> save(CartaServicos cartaServicos) async {
    Map data = cartaServicos.get();
    String id = cartaServicos.id;

    DocumentReference reference = this._servicos.doc(id);
    await reference.set(data);

    return reference;
  }

  FutureOr<bool> isInDatabase(String id) async {
    DocumentSnapshot snapshot = await this._servicos.doc(id).get();
    try {
      return snapshot.exists;
    } catch (e) {
      return false;
    }
  }
}

class DatabaseIntegration {
  static final UsuarioController usuarioController = UsuarioController();
  static final CartaServicosController cartaServicosController =
      CartaServicosController();
}
