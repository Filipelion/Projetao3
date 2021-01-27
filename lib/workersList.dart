import 'package:Projetao3/infrastructure/constants.dart';
import 'package:flutter/material.dart';
import './custom_widgets/oiaWidgets.dart';

class WorkersPage extends StatefulWidget {
  @override
  _WorkersPageState createState() => _WorkersPageState();
}

class _WorkersPageState extends State<WorkersPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return WorkersList();
  }
}

class WorkersList extends StatefulWidget {
  @override
  _WorkersListState createState() => _WorkersListState();
}

class _WorkersListState extends State<WorkersList> {
  @override
  Widget build(BuildContext context) {
    return OiaWorkersList();
  }
}
