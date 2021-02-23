import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './custom_widgets/oiaWidgets.dart';
import './infrastructure/constants.dart';
import 'custom_widgets/oiaWidgets.dart';

class WorkerProfile extends StatefulWidget {

  @override
  _WorkerProfileState createState() => _WorkerProfileState();
}

class _WorkerProfileState extends State<WorkerProfile> {
  String _uid;
  List _images;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _uid = ModalRoute.of(context).settings.arguments;

    
    return OiaScaffold(showBottomBar: true, body: Center(child: Text(_uid)),);
  }
}