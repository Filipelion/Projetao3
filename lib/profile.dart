import 'dart:async';

import 'package:flutter/material.dart';
import 'custom_widgets/oiaWidgets.dart';
import 'infrastructure/constants.dart';
import 'infrastructure/loginAuth.dart';
import './infrastructure/database_integration.dart';
import './infrastructure/usuario.dart';

class Profile extends StatefulWidget {
  List<String> tags;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  LoginAuth auth;
  bool isLoggedIn = true;
  TextEditingController _controllerNome;
  final _formKey = GlobalKey<FormState>();

  // Dropdown de gêneros
  List _generos = ['Feminino', 'Masculino', 'Não binário', 'Prefiro não dizer'];
  String _dropdownValue;

  // Dados do usuario
  UsuarioController _usuarioController = DatabaseIntegration.usuarioController;
  FutureOr<Usuario> _usuario;

  @override
  void initState() {
    super.initState();
    auth = Authentication.loginAuth;
    auth.authChangeListener();
    _controllerNome = TextEditingController(text: auth.getUserProfileName());
    if (auth.userIsLoggedIn()) {
      setState(() {
        isLoggedIn = true;
      });
    }
  }

  _onSaveFields() {
    if(_formKey.currentState.validate()) {
      _formKey.currentState.save();
      String uid = auth.getUid();
      String nome = _controllerNome.value.text.toString();
      String genero = _dropdownValue;
      String email = auth.getUserEmail();
      
      _usuario = Usuario(
        uid: uid,
        nome: nome,
        genero: genero,
        email: email,

      );
      _usuarioController.saveUsuario(_usuario);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OiaScaffold(
      appBarTitle: "Perfil",
      body: isLoggedIn
          ? _buildBody(context)
          : Center(child: CircularProgressIndicator()),
      showBottomBar: true,
    );
  }

  _buildBody(context) {
    List _categorias = ModalRoute.of(context).settings.arguments;
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
                      return OiaClickableCard(
                        title: _categorias[index],
                        onTap: () {},
                      );
                    })),
              ),
              Constants.SMALL_HEIGHT_BOX,
              OiaLargeButton(
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
}
