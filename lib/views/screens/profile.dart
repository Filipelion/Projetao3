import 'dart:async';

import 'package:Projetao3/models/crudServicosArgs.dart';
import 'package:Projetao3/models/cartaServico.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Projetao3/views/components/button_component.dart';
import 'package:Projetao3/views/components/card_component.dart';
import 'package:Projetao3/views/screens/base_screen.dart';
import '../../custom_widgets/oiaWidgets.dart';
import '../../models/cartaServico.dart';
import '../shared/constants.dart';
import '../../services/login_service.dart';
import '../../services/firestore_service.dart';
import '../../infrastructure/usuario.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  LoginService auth;
  bool isLoggedIn = true;
  TextEditingController _controllerNome;
  final _formKey = GlobalKey<FormState>();

  // Dropdown de gêneros
  List _generos = ['Feminino', 'Masculino', 'Não binário', 'Prefiro não dizer'];
  String _dropdownValue;

  // Dados do usuario
  final _usuarioController = DatabaseIntegration.usuarioController;
  final _cartaServicosController = DatabaseIntegration._skillsRepository;

  FutureOr<Usuario> _usuario;
  CartaServicos _cartaServicos;

  @override
  void initState() {
    super.initState();
    auth = locator<LoginService>();
    auth.authChangeListener();
    String controllerText = !isLoggedIn ? "" : auth.getUserProfileName();
    _controllerNome = TextEditingController(text: controllerText);
    if (auth.userIsLoggedIn()) {
      setState(() {
        isLoggedIn = true;
      });
    }
  }

  _onSaveFields() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      String uid = auth.getUid();
      String nome = _controllerNome.value.text.toString();
      String genero = _dropdownValue;
      String email = auth.getUserEmail();
      DocumentReference servicos =
          await _cartaServicosController.save(_cartaServicos);

      _usuario = Usuario(
        uid: uid,
        nome: nome,
        genero: genero,
        email: email,
        servicos: servicos,
      );
      _usuarioController.saveUsuario(_usuario);
      Navigator.pushNamed(context, '/workers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBarTitle: "Perfil",
      body: isLoggedIn
          ? _buildBody(context)
          : Center(child: CircularProgressIndicator()),
      showBottomBar: true,
    );
  }

  _buildBody(context) {
    if (!isLoggedIn) {
      return _buildRedirectToLogin();
    } else {
      return _buildProfilePage();
    }
  }

  _buildProfilePage() {
    _cartaServicos = ModalRoute.of(context).settings.arguments;
    List _categorias = _cartaServicos.tipos();

    return SingleChildScrollView(
      child: Column(
        children: [
          Constants.LARGE_HEIGHT_BOX,
          Center(
            child: OiaRoundedImage(
              width: 120,
              height: 120,
              borderWidth: 5,
              image: NetworkImage(auth.getUserProfilePhoto()),
            ),
          ),
          Constants.LARGE_HEIGHT_BOX,
          Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                controller: _controllerNome,
                decoration: InputDecoration(
                  labelText: "Nome",
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                validator: (value) {
                  if (value == null) return "Insira um valor não nulo";
                },
              ),
              Constants.SMALL_HEIGHT_BOX,
              DropdownButtonFormField(
                value: _dropdownValue,
                items: _generos
                    .map<DropdownMenuItem<String>>((genero) =>
                        DropdownMenuItem(value: genero, child: Text(genero)))
                    .toList(),
                onChanged: (String newValue) {
                  setState(() {
                    _dropdownValue = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) return "Selecione uma opção";
                },
                hint: Text("Gênero"),
                decoration: InputDecoration(
                    labelText: "Gênero",
                    border: OutlineInputBorder(),
                    isDense: true),
              ),
              Constants.LARGE_HEIGHT_BOX,
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Categorias",
                      style: TextStyle(
                          fontSize: Constants.mediumFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  TextSpan(
                      text:
                          "\n\nClique nos botões abaixo para poder editar as informações sobre os serviços que você realiza.",
                      style: TextStyle(fontSize: Constants.smallFontSize))
                ], style: TextStyle(color: Colors.grey)),
                textAlign: TextAlign.center,
              ),
              Constants.MEDIUM_HEIGHT_BOX,
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(Constants.smallSpace),
                child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(_categorias.length, (index) {
                      String tipo = _categorias[index];

                      return CardComponent(
                        title: tipo,
                        onTap: () {
                          CrudServicoArgs args = CrudServicoArgs(
                              tipo: tipo, cartaServicos: _cartaServicos);
                          Navigator.pushNamed(context, '/servico',
                              arguments: args);
                        },
                      );
                    })),
              ),
              Constants.SMALL_HEIGHT_BOX,
              ButtonComponent(
                title: "Salvar",
                onPressed: _onSaveFields,
              ),
              Constants.MEDIUM_HEIGHT_BOX,
            ]),
          ),
        ],
      ),
    );
  }

  _buildRedirectToLogin() {
    return Center(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Faça login para ter acesso a todas as funcionalidades do aplicativo",
              textAlign: TextAlign.center,
            ),
            Constants.SMALL_HEIGHT_BOX,
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text(
                "Fazer login",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Constants.COR_VINHO)),
            )
          ]),
    );
  }
}
