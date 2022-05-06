import 'package:flutter/material.dart';
import 'package:Projetao3/core/locator.dart';
import 'package:Projetao3/repository/professional_skills_repository.dart';
import 'package:Projetao3/views/shared/utils.dart';
import './custom_widgets/oiaWidgets.dart';
import 'services/login_service.dart';
import 'services/firestore_service.dart';
import 'views/shared/constants.dart';
import 'services/tags_service.dart';
import 'views/shared/constants.dart';

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
  ProfessionalSkillsRepository _usuarioController =
      locator<ProfessionalSkillsRepository>();
  LoginService auth = locator<LoginService>();

  TagsService _serverIntegration = TagsService();
  List _suggestedTags;
  Future<List<Map>> _workers;

  final _searchKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  String _textOnSearch = "Sem classificação";

  bool isLoggedIn = false;
  String _uid;
  @override
  void initState() {
    super.initState();

    auth.authChangeListener();
    if (auth.userIsLoggedIn()) {
      setState(() {
        isLoggedIn = true;
        _uid = auth.getUid();
        this._updateLocationAndLastSeen();
      });
    } else {
      setState(() {
        isLoggedIn = false;
      });
    }
    _workers = _usuarioController.getAllWorkers(_textOnSearch);
  }

  Future<void> _updateLocationAndLastSeen() async {
    String vistoUltimo = _usuarioController.setVistoUltimo();
    Map localizacao =
        await _usuarioController.updateCurrentGeolocation(this._uid);

    Map<String, dynamic> data = {
      'visto_ultimo': vistoUltimo,
      'localizacao': localizacao,
    };

    _usuarioController.update(this._uid, data);
    print("Posição atualizada com sucesso!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: OiaSidebar(),
      bottomNavigationBar: isLoggedIn
          ? OiaBottomBar()
          : Container(
              height: 0,
              width: 0,
            ),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildFutureBuilder(),
        ],
      ),
    );
  }

  _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Constants.COR_MOSTARDA,
      iconTheme: IconThemeData(color: Colors.black),
      floating: true,
      expandedHeight: 260,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          margin: EdgeInsets.only(
              top: Constants.mediumSpace, bottom: Constants.largeSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: Constants.mediumSpace),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(
                      "assets/icons/satellite_icon.png",
                      width: 50,
                    ),
                    Container(
                      width: Utils.screenDimensions(context).size.width * 0.4,
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
                width: Utils.screenDimensions(context).size.width * 0.8,
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
                            if (value.isEmpty)
                              return "Insira o nome da profissão";
                          },
                        ),
                      ),
                      Constants.SMALL_WIDTH_BOX,
                      IconButton(
                          icon: Icon(Icons.send), onPressed: _onSaveFields)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onSaveFields() async {
    if (_searchKey.currentState.validate()) {
      _searchKey.currentState.save();
      setState(() {
        _textOnSearch = _searchController.text;
        _workers = _usuarioController.getAllWorkers(_textOnSearch);
      });
      _searchKey.currentState.reset();

      Map clusterData =
          await _serverIntegration.getSameClusterTags(tag: this._textOnSearch);
      this._suggestedTags = clusterData['tags'];
      print(this._suggestedTags);
    }
  }

  _buildFutureBuilder() {
    return FutureBuilder(
        future: _workers,
        builder: (context, snapshot) {
          if (snapshot.hasData ||
              snapshot.connectionState == ConnectionState.done) {
            print(snapshot.data);
            return snapshot.data == []
                ? Center(
                    child: Text(
                      "Resultados não encontrados",
                      style: TextStyle(fontSize: Constants.mediumFontSize),
                    ),
                  )
                : _buildSliverList(snapshot.data);
          } else if (snapshot.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Não foi possível acessar o app."),
            ));
            return SliverToBoxAdapter(child: Container());
          }

          return SliverToBoxAdapter(
            child: Column(
              children: [
                Constants.LARGE_HEIGHT_BOX,
                Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        });
  }

  _buildSliverList(List workers) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (context, index) {
        String nomeUsuario = workers[index]['nome'];
        return Column(
          children: [
            Divider(height: 2.0),
            OiaListTile(
              title: nomeUsuario,
              subtitle: _textOnSearch,
              onTap: () {
                String uid = workers[index]['uid'];
                Map args = {
                  'uid': uid,
                  'tag': _textOnSearch,
                  'nome': nomeUsuario
                };

                Navigator.pushNamed(context, '/worker_info', arguments: args);
              },
            )
          ],
        );
      },
      childCount: workers.length,
    ));
  }
}
