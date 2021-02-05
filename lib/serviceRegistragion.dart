import 'package:Projetao3/infrastructure/servicos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './custom_widgets/oiaWidgets.dart';
import './infrastructure/loginAuth.dart';
import './infrastructure/constants.dart';
import 'infrastructure/constants.dart';
import './infrastructure/database_integration.dart';

class ServiceRegistration extends StatefulWidget {
  @override
  _ServiceRegistrationState createState() => _ServiceRegistrationState();
}

class _ServiceRegistrationState extends State<ServiceRegistration> {
  LoginAuth auth = Authentication.loginAuth;
  List<String> servicosUsuario = [];
  Usuario usuario;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  String textoEmBusca;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth.authChangeListener();
  }

  @override
  Widget build(BuildContext context) {
    return OiaScaffold(
      appBarTitle: auth.getUserProfileName(),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: Constants.mediumSpace),
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
                        validator: (texto) {
                          if (texto == null) return "O texto não pode ser nulo";
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            _controller.clear();
                            servicosUsuario.add(this.textoEmBusca);
                          });
                        }
                      },
                    )
                  ],
                ),
              ),
              Constants.SMALL_HEIGHT_BOX,
              // IconButton(icon: , onPressed: null)
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
    return FutureBuilder(
        future: _getCartaServicos(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
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
                        // contentPadding: EdgeInsets.symmetric(vertical: Constants.smallSpace),
                        tileColor: Colors.grey[100],
                        dense: true,
                      ),
                      Divider()
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.connectionState == ConnectionState.none) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: Constants.largeSpace),
              child: Center(
                child: Text("Não foi possível conectar com o banco de dados"),
              ),
            );
          }
          return Container(
              margin: EdgeInsets.symmetric(vertical: Constants.largeSpace),
              child: CircularProgressIndicator());
        });
  }

  _getCartaServicos() async {
    UsuarioController usuarioController = UsuarioController();
    String uid = auth.getUid();

    if (usuarioController.usuarioIsInDatabase(uid)) {
      usuario = await usuarioController.getUsuarioData(uid);
    } else {
      // Convertendo os servicos para um objeto Map
      Map servicosData = {};
      servicosUsuario.forEach((tipo) {
        servicosData[tipo] = {};
      });

      // TODO: revisar essa parte

      usuario = Usuario.fromJson({
        "uid": uid,
        "nome": auth.getUserProfileName(),
        // TODO: seviços precisa ser uma referencia para o firebase
        "email": auth.getUserEmail(),
        "servicos": servicos,
      });
    }
    print(usuario.toJson().toString());
    print("a");
    // setState(() {
    //   servicosUsuario = servicos.keys.toList();
    // });
  }

  _goToProfile() async {
    String id = auth.getUid();
    if (await DatabaseIntegration.usuarioController.usuarioIsInDatabase(id)) {
      Navigator.popAndPushNamed(context, '/workers');
    } else {
      Navigator.pushNamed(context, '/profile', arguments: servicosUsuario);
    }
  }
}
