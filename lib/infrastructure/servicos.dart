import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './loginAuth.dart';

class Servico {
  String nome, descricao, id;
  num valorMedio;
  Map imagens;

  Servico({this.nome, this.descricao, this.id, this.valorMedio, this.imagens});
}