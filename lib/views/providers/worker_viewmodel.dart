import 'package:flutter/material.dart';
import 'package:Projetao3/models/worker.dart';

class WorkerViewModel extends ChangeNotifier {
  String? _uid, _tag, _name;

  void setWorker(Map<String, dynamic> data, {notify: true}) {
    _uid = data["uid"];
    _tag = data["tag"];
    _name = data["name"];

    if (notify) notifyListeners();
  }

  String? get uid => _uid;
  void setUid(String value, {notify: true}) {
    _uid = value;
    if (notify) notifyListeners();
  }

  String? get tag => _tag;
  void setTag(String value, {notify: true}) {
    _tag = value;
    if (notify) notifyListeners();
  }

  String? get name => _name;
  void setName(String value, {notify: true}) {
    _name = value;
    if (notify) notifyListeners();
  }
}
