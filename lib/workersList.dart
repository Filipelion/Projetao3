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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return WorkerListScreen();
          } else if (snapshot.connectionState == ConnectionState.none) {
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
        ],
      ),
    );
  }
}
