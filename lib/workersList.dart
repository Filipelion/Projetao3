import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './custom_widgets/oiaWidgets.dart';
import './infrastructure/loginAuth.dart';
import './infrastructure/database_integration.dart';
import 'infrastructure/database_integration.dart';
import 'infrastructure/database_integration.dart';

class WorkersPage extends StatefulWidget {
  @override
  _WorkersPageState createState() => _WorkersPageState();
}

class _WorkersPageState extends State<WorkersPage> {
  @override
  void initState() {
    super.initState();
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
  UsuarioController _usuarioController = UsuarioController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(
            Duration(seconds: 4), _usuarioController.getAllWorkers),
        builder: (context, snapshot) {
          if (snapshot.hasData ||
              snapshot.connectionState == ConnectionState.done) {
            print(snapshot.data);
            return WorkerListScreen(
              workers: snapshot.data,
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: SnackBar(
                content: Text("Não foi possível acessar o app."),
              ),
            );
          }

          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}

class WorkerListScreen extends StatefulWidget {
  final List workers;
  const WorkerListScreen({Key key, this.workers}) : super(key: key);

  @override
  _WorkerListScreenState createState() => _WorkerListScreenState();
}

class _WorkerListScreenState extends State<WorkerListScreen> {
  LoginAuth auth = Authentication.loginAuth;
  UsuarioController _usuarioController = UsuarioController();

  bool isLoggedIn = false;
  String uid;

  @override
  void initState() {
    super.initState();
    auth.authChangeListener();
    if (auth.userIsLoggedIn()) {
      setState(() {
        isLoggedIn = true;
        uid = auth.getUid();
      });
    }
  }

  List _getWorkers() {
    return widget.workers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: OiaSidebar(),
      bottomNavigationBar: OiaBottomBar(
        uid: this.uid,
      ),
      body: CustomScrollView(
        slivers: [
          OiaFlexibleAppbar(),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Column(
                children: [
                  Divider(height: 2.0),
                  OiaListTile(
                    title: "Vinícius Vieira",
                    subtitle: "Desenvolvedor",
                  )
                ],
              );
            },
            childCount: _getWorkers().length,
          )),
        ],
      ),
    );
  }
}
