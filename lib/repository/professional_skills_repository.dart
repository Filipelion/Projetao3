import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Projetao3/infrastructure/usuario.dart';
import 'package:Projetao3/services/login_service.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import '../services/login_service.dart';
import '../infrastructure/usuario.dart';
import '../models/cartaServico.dart';
import '../services/geolocation_service.dart';
import 'package:intl/intl.dart';

// TODO: Kill file
class ProfessionalSkillsRepository {
  late CollectionReference _servicos;

  ProfessionalSkillsRepository() {
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
