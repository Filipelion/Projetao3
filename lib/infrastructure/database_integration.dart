import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import './loginAuth.dart';
import './usuario.dart';
import 'cartaServico.dart';
import './geolocation_integration.dart';
import 'package:intl/intl.dart';

class UsuarioController {
  CollectionReference _usuarios;

  UsuarioController() {
    this._usuarios = FirebaseFirestore.instance.collection("Usuario");
  }

  Future<DocumentReference> _getDocumentReference(String id) async {
    return this._usuarios.doc(id);
  }

  Future<DocumentSnapshot> _getUsuarioByID(String id) async {
    DocumentReference reference = await this._getDocumentReference(id);
    return reference.get();
  }

  Future<Usuario> getUsuarioData(String id) async {
    try {
      // Tentando recuperar os dados do usuário do banco de dados
      DocumentSnapshot snapshot = await this._getUsuarioByID(id);
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

  FutureOr<List<Map>> getAllWorkers(String tag) async {
    QuerySnapshot snapshot = await _usuarios.get();
    List<Map> workers = [];

    for (var worker in snapshot.docs) {
      Map<String, dynamic> workerData = worker.data();
      DocumentReference ref = workerData["servicos"];
      DocumentSnapshot servicos = await ref.get();
      if (servicos.data().keys.contains(tag)) workers.add(workerData);
    }

    return workers;
  }

  FutureOr<bool> usuarioIsInDatabase(String id) async {
    DocumentSnapshot documentSnapshot = await this._getUsuarioByID(id);
    try {
      return documentSnapshot.exists;
    } catch (e) {
      return false;
    }
  }

  void saveUsuario(Usuario usuario) async {
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

  Future<Map> updateCurrentGeolocation(String uid) async {
    final geolocation = GeolocationIntegration();
    Position position = await geolocation.getCurrentLocation();

    Map<String, dynamic> localizacaoData = position.toJson();
    return localizacaoData;
  }

  Future<Position> getUsuarioLocation(String id) async {
    Usuario usuario = await this.getUsuarioData(id);
    return Position.fromMap(usuario.localizacao);
  }

  Future<void> update(String uid, Map<String, dynamic> data) async {
    DocumentReference ref = await this._getDocumentReference(uid);
    ref.update(data);
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
