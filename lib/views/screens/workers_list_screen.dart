import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Projetao3/core/locator.dart';
import 'package:Projetao3/models/generic_user.dart';
import 'package:Projetao3/views/components/bottom_navigation_component.dart';
import 'package:Projetao3/views/components/list_item_component.dart';
import 'package:Projetao3/views/components/sidebar_component.dart';
import 'package:Projetao3/views/controllers/user_controller.dart';
import 'package:Projetao3/views/controllers/worker_controller.dart';
import 'package:Projetao3/views/providers/worker_viewmodel.dart';
import 'package:Projetao3/views/shared/utils.dart';
import '../shared/constants.dart';

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
  late WorkerViewModel _workerViewModel;

  var _userController = locator<UserController>();
  var _workerController = locator<WorkerController>();

  List? _suggestedTags;
  Future<List<GenericUser>>? _workers;

  final _searchKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  String _searchTag = "Sem classificação";

  bool isLoggedIn = false;

  String? _uid;

  @override
  void initState() {
    super.initState();

    _userController.authenticationStateMonitor();

    if (_userController.isLoggedIn()) {
      setState(() {
        isLoggedIn = true;
        _uid = _userController.uid;
      });
    } else {
      setState(() {
        isLoggedIn = false;
      });
    }

    _workers = _userController.listAllWorkers(_searchTag);
    _userController.listAllWorkers(_searchTag);
  }

  @override
  Widget build(BuildContext context) {
    _workerViewModel = Provider.of<WorkerViewModel>(context);

    return FutureBuilder(
        future: _userController.updateLocationAndLastSeen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Scaffold(
              drawer: SidebarComponent(),
              bottomNavigationBar: isLoggedIn
                  ? BottomNavigationComponent()
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
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return Center(
              child: Container(
                child:
                    Text("Não foi possível listar os prestadores de serviços."),
              ),
            );
          }
        });
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
                            if (value != null && value.isEmpty)
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
    if (_searchKey.currentState != null &&
        _searchKey.currentState!.validate()) {
      _searchKey.currentState!.save();
      setState(() {
        _searchTag = _searchController.text;
        _workers = _userController.listAllWorkers(_searchTag);
      });
      _searchKey.currentState!.reset();

      Map clusterData = await _workerController.getTags(_searchTag);
      this._suggestedTags = clusterData['tags'];
      print(this._suggestedTags);
    }
  }

  _buildFutureBuilder() {
    return FutureBuilder(
        future: _workers,
        builder: (context, AsyncSnapshot<List<GenericUser>?> snapshot) {
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
                : _buildSliverList(snapshot.data!);
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
        String workerName = workers[index]['nome'];
        return Column(
          children: [
            Divider(height: 2.0),
            ListItemComponent(
              title: workerName,
              subtitle: _searchTag,
              onTap: () {
                String uid = workers[index]['uid'];

                _workerViewModel.setWorker({
                  'uid': uid,
                  'tag': _searchTag,
                  'nome': workerName,
                });

                Navigator.pushNamed(context, '/worker_info');
              },
            )
          ],
        );
      },
      childCount: workers.length,
    ));
  }
}
