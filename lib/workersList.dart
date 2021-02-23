import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './custom_widgets/oiaWidgets.dart';
import './infrastructure/loginAuth.dart';
import './infrastructure/database_integration.dart';
import 'infrastructure/database_integration.dart';
import 'infrastructure/database_integration.dart';
import 'infrastructure/constants.dart';

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
  String _uid;

  final _searchKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  String _textOnSearch = "Sem classificação";

  @override
  void initState() {
    super.initState();
    auth.authChangeListener();
    if (auth.userIsLoggedIn()) {
      setState(() {
        isLoggedIn = true;
        _uid = auth.getUid();
      });
    }
  }

  List _getWorkers() {
    return widget.workers;
  }

  @override
  Widget build(BuildContext context) {
    List<Map> workers = _getWorkers();
    return Scaffold(
      drawer: OiaSidebar(),
      bottomNavigationBar: OiaBottomBar(
        uid: this._uid,
      ),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Column(
                children: [
                  Divider(height: 2.0),
                  OiaListTile(
                    title: workers[index]['nome'],
                    subtitle: _textOnSearch,
                    onTap: () {
                      // TODO: é preciso passar o nome da profissão
                      String uid = workers[index]['uid'];
                      Navigator.pushNamed(context, '/worker_info', arguments: uid);
                    },
                  )
                ],
              );
            },
            childCount: workers.length,
          )),
        ],
      ),
    );
  }

  _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Constants.COR_MOSTARDA,
      iconTheme: IconThemeData(color: Colors.black),
      floating: true,
      expandedHeight: 200,
      flexibleSpace: Container(
        margin: EdgeInsets.only(
            top: Constants.mediumSpace, bottom: Constants.largeSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Constants.mediumSpace),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    "assets/icons/satellite_icon.png",
                    width: 50,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text(
                      "Encontre\nprofissionais",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: Constants.regularFontSize),
                    ),
                  )
                ],
              ),
            ),
            Constants.LARGE_HEIGHT_BOX,
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Form(
                key: _searchKey,
                child: Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: _searchController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            focusColor: Colors.white,
                            hoverColor: Colors.white,
                            hintText: "Buscar...",
                            prefixIcon: Icon(Icons.search),
                            isDense: true,
                            fillColor: Colors.white,   
                        ),
                        validator: (value) {
                          if(value.isEmpty) return "Insira o nome da profissão";
                        },
                      ),
                    ),
                    Constants.SMALL_WIDTH_BOX,
                    IconButton(icon: Icon(Icons.send), onPressed: _onSaveFields)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onSaveFields() {
    if (_searchKey.currentState.validate()) {
      _searchKey.currentState.save();
      setState(() {
        _textOnSearch = _searchController.text;
      });
      _searchKey.currentState.reset();
    }
  }
}
