import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:Projetao3/views/screens/base_screen.dart';
import 'package:Projetao3/views/shared/utils.dart';
import '../../custom_widgets/oiaWidgets.dart';

import '../../services/login_service.dart';
import '../shared/constants.dart';
import '../../services/firestore_service.dart';
import '../../models/cartaServico.dart';
import '../../services/tags_service.dart';

class ServiceRegistration extends StatefulWidget {
  @override
  _ServiceRegistrationState createState() => _ServiceRegistrationState();
}

class _ServiceRegistrationState extends State<ServiceRegistration> {
  LoginService auth = locator<LoginService>();
  List servicosUsuario = [];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  String textoEmBusca;

  UsuarioController _usuarioController = UsuarioController();
  CartaServicos _cartaServicos = CartaServicos();
  TagsService _serverIntegration = TagsService();

  bool _userIsLoggedIn = false;
  bool _wasAddedNewServico = false;

  List _tags;

  @override
  void initState() {
    super.initState();
    auth.authChangeListener();
    if (auth.userIsLoggedIn() && !_userIsLoggedIn) {
      setState(() {
        _userIsLoggedIn = true;
      });

      String uid = auth.getUid();
      _usuarioController.getUsuarioCartaServicos(uid).then((value) {
        setState(() {
          servicosUsuario = value.tipos();
          _cartaServicos = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return BaseScreen(
      appBarTitle: auth.getUserProfileName(),
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
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "Pesquisar serviço...",
                          border: OutlineInputBorder(),
                          fillColor: Constants.COR_MOSTARDA,
                          isDense: true,
                        ),
                        onChanged: (texto) {
                          setState(() {
                            this.textoEmBusca = texto;
                          });
                        },
                        validator: (String texto) {
                          if (texto.isEmpty) return "O texto não pode ser nulo";
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          String tag = this.textoEmBusca;
                          Map retorno = await _serverIntegration
                              .getSameClusterTags(tag: tag);

                          setState(() {
                            _controller.clear();
                            this._tags = retorno['tags'];
                          });

                          _buildModalBottomSheet(context);
                          // TODO: Mostrar as tags em um pop-up
                        }
                      },
                    )
                  ],
                ),
              ),
              Constants.SMALL_HEIGHT_BOX,
              Flexible(
                child: _buildList(),
              ),
              OiaLargeButton(
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
    return ListView.builder(
      physics: PageScrollPhysics(),
      reverse: true,
      itemCount: servicosUsuario.length,
      itemBuilder: (context, index) {
        return Container(
          child: Column(
            children: [
              ListTile(
                title: Text(servicosUsuario[index]),
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
    String id = auth.getUid();

    if (await DatabaseIntegration.usuarioController.usuarioIsInDatabase(id) &&
        !_wasAddedNewServico) {
      Navigator.popAndPushNamed(context, '/workers');
    } else {
      Navigator.pushNamed(context, '/profile', arguments: _cartaServicos);
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
                        itemCount: _tags.length, // required
                        itemBuilder: (int index) {
                          final item = _tags[index];

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
                                  _tags.removeAt(index);
                                });
                                //required
                                return true;
                              },
                            ), // OR null,
                            onPressed: (item) {
                              print(item.title);
                              setState(() {
                                servicosUsuario.add(item.title);
                                _cartaServicos.save(item.title, {});
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
}
