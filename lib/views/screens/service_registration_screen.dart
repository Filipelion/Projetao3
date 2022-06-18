import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:provider/provider.dart';
import 'package:Projetao3/core/locator.dart';
import 'package:Projetao3/models/professional_skills_list.dart';
import 'package:Projetao3/views/components/button_component.dart';
import 'package:Projetao3/views/controllers/user_controller.dart';
import 'package:Projetao3/views/controllers/worker_controller.dart';
import 'package:Projetao3/views/providers/user_viewmodel.dart';
import 'package:Projetao3/views/screens/base_screen.dart';
import 'package:Projetao3/views/shared/utils.dart';
import '../shared/constants.dart';

class ServiceRegistration extends StatefulWidget {
  @override
  _ServiceRegistrationState createState() => _ServiceRegistrationState();
}

class _ServiceRegistrationState extends State<ServiceRegistration> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tagTextController = TextEditingController();
  String? searchText;

  UserController _userController = locator<UserController>();
  // WorkerController _workerController = locator<WorkerController>();

  late UserViewModel _userViewModel;

  bool _wasAddedNewServico = false;

  List? _tags;

  @override
  void initState() {
    super.initState();

    _userController.authenticationStateMonitor();
  }

  @override
  Widget build(BuildContext context) {
    _userViewModel = Provider.of<UserViewModel>(context);

    _loginViewHandler();

    var _uid = _userViewModel.uid;

    return FutureBuilder(
        future: _loadSkills(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _buildBody();
          } else if (snapshot.hasError) {
            return Container(
              child: Text("Erro ao requisitar os serviços."),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  _buildBody() {
    return BaseScreen(
      appBarTitle: _userController.userName ?? "",
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: Constants.mediumSpace),
          height: Utils.screenDimensions(context).size.height * 0.8,
          child: Column(
            children: <Widget>[
              Text(
                "Quais serviços você faz?",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Constants.regularFontSize),
              ),
              Constants.MEDIUM_HEIGHT_BOX,
              Form(
                key: _formKey,
                child: Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: _tagTextController,
                        decoration: InputDecoration(
                          hintText: "Pesquisar serviço...",
                          border: OutlineInputBorder(),
                          fillColor: Constants.COR_MOSTARDA,
                          isDense: true,
                        ),
                        onChanged: (text) {
                          setState(() {
                            this.searchText = text;
                          });
                        },
                        validator: (String? text) {
                          if (text != null && text.isEmpty)
                            return "O texto não pode ser nulo";
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () async => await _searchTag(),
                    )
                  ],
                ),
              ),
              Constants.SMALL_HEIGHT_BOX,
              Flexible(
                child: _buildList(),
              ),
              ButtonComponent(
                title: "Continuar",
                onPressed: _goToProfile,
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildList() {
    var skills = _userViewModel.professionalSkills!.list;

    return ListView.builder(
      physics: PageScrollPhysics(),
      reverse: true,
      itemCount: skills.length,
      itemBuilder: (context, index) {
        return Container(
          child: Column(
            children: [
              ListTile(
                title: Text(skills[index].name),
                tileColor: Colors.grey[100],
                dense: true,
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }

  _goToProfile() async {
    String? id = _userController.uid;
    bool userExists = id != null ? await _userController.userExists(id) : false;

    if (userExists && !_wasAddedNewServico) {
      Navigator.popAndPushNamed(context, '/workers');
    } else {
      Navigator.pushNamed(context, '/profile');
    }
  }

  _buildModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext build) {
          return Container(
            padding: EdgeInsets.all(Constants.mediumSpace),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: Colors.white70,
            ),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Constants.MEDIUM_HEIGHT_BOX,
                      Text(
                        'Profissões similares',
                        style: TextStyle(
                          fontSize: Constants.mediumFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Constants.SMALL_HEIGHT_BOX,
                      Text(
                        'Nós separamos uma lista de profissões nas quais talvez você esteja trabalhando no momento. Olha só:',
                        style: TextStyle(fontSize: Constants.regularFontSize),
                        textAlign: TextAlign.center,
                      ),
                      Constants.MEDIUM_HEIGHT_BOX,
                      Tags(
                        itemCount: _tags?.length ?? 0, // required
                        itemBuilder: (int index) {
                          final item = _tags![index];

                          return ItemTags(
                            // Each ItemTags must contain a Key. Keys allow Flutter to
                            // uniquely identify widgets.
                            key: Key(index.toString()),
                            index: index, // required
                            title: item,
                            active: false,
                            textStyle: TextStyle(
                              fontSize: Constants.smallFontSize,
                            ),
                            combine: ItemTagsCombine.withTextBefore,
                            // image: ItemTagsImage(
                            //     image: AssetImage(
                            //         "img.jpg") // OR NetworkImage("https://...image.png")
                            //     ), // OR null,
                            icon: ItemTagsIcon(
                              icon: Icons.add,
                            ), // OR null,
                            removeButton: ItemTagsRemoveButton(
                              onRemoved: () {
                                // Remove the item from the data source.
                                setState(() {
                                  // required
                                  _tags!.removeAt(index);
                                });
                                //required
                                return true;
                              },
                            ), // OR null,
                            onPressed: (item) {
                              print(item.title);
                              setState(() {
                                _wasAddedNewServico = true;
                              });
                            },
                            onLongPressed: (item) => print(item),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  _loginViewHandler() {
    // Handles the view depending on user is logged in or not.
    var isLoggedIn = _userController.isLoggedIn();

    isLoggedIn ? _userViewModel.login() : _userViewModel.logout();

    var uid = _userController.uid;
    _userViewModel.setUid(uid);
  }

  Future<void> _searchTag() async {
    if (_formKey.currentState!.validate()) {
      if (searchText != null) {
        String searchTag = this.searchText!;
        var tags = await _userController.getTags(searchTag);

        setState(() {
          _tagTextController.clear();
          this._tags = tags;
        });
      }

      _buildModalBottomSheet(context);
      // TODO: Mostrar as tags em um pop-up
    }
  }

  Future<ProfessionalSkillsList?> _loadSkills() async {
    if (_userController.isLoggedIn()) {
      String uid = _userController.uid!;
      var skills = await _userController.getSkills(uid);

      if (skills != null) {
        _userViewModel.setSelectedSkill(skills.toString());
      }

      return skills;
    }

    return null;
  }
}
