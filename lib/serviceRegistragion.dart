import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './custom_widgets/oiaWidgets.dart';
import './infrastructure/loginAuth.dart';
import './infrastructure/constants.dart';
import 'infrastructure/constants.dart';

import './infrastructure/database_integration.dart';
import 'infrastructure/cartaServico.dart';

class ServiceRegistration extends StatefulWidget {
  @override
  _ServiceRegistrationState createState() => _ServiceRegistrationState();
}

class _ServiceRegistrationState extends State<ServiceRegistration> {
  LoginAuth auth = Authentication.loginAuth;
  List servicosUsuario = [];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  String textoEmBusca;

  UsuarioController _usuarioController = UsuarioController();
  CartaServicos _cartaServicos = CartaServicos();

  bool _userIsLoggedIn = false;
  bool _wasAddedNewServico = false;

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
                        validator: (String texto) {
                          if (texto == null) return "O texto não pode ser nulo";
                          return null;
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            _controller.clear();
                            String tag = this.textoEmBusca;
                            if (!servicosUsuario.contains(tag))
                              servicosUsuario.add(tag);
                            _wasAddedNewServico = true;
                            _cartaServicos.save(tag, {});
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
              Divider(),
            ],
          ),
        );
      },
    );
  }

  _goToProfile() async {
    String id = auth.getUid();

    // if (_cartaServicos == null) {
    //   Map servicosData = {};
    //   servicosUsuario.map((e) => servicosData[e] = {});

    //   _cartaServicos = CartaServicos(id: id, cartaServicos: servicosData);
    // }

    if (await DatabaseIntegration.usuarioController.usuarioIsInDatabase(id) &&
        !_wasAddedNewServico) {
      Navigator.popAndPushNamed(context, '/workers');
    } else {
      Navigator.pushNamed(context, '/profile', arguments: _cartaServicos);

      // Navigator.pushNamed(context, '/profile', arguments: servicosUsuario);
    }
  }
}
