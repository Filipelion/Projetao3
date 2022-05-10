import 'package:provider/provider.dart';
import 'package:Projetao3/core/enums/gender.dart';
import 'package:Projetao3/core/locator.dart';
import 'package:flutter/material.dart';
import 'package:Projetao3/models/generic_user.dart';
import 'package:Projetao3/models/professional_skills_list.dart';
import 'package:Projetao3/views/components/button_component.dart';
import 'package:Projetao3/views/components/card_component.dart';
import 'package:Projetao3/views/components/circular_image_component.dart';
import 'package:Projetao3/views/controllers/user_controller.dart';
import 'package:Projetao3/views/providers/user_viewmodel.dart';
import 'package:Projetao3/views/screens/base_screen.dart';
import '../shared/constants.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late TextEditingController _controllerNome;
  final _formKey = GlobalKey<FormState>();

  // Dropdown de gêneros
  List _generos = ['Feminino', 'Masculino', 'Não binário', 'Prefiro não dizer'];
  late String _dropdownValue;

  // Dados do usuario
  UserController _userController = locator<UserController>();

  GenericUser? _user;
  ProfessionalSkillsList? _skills;

  late UserViewModel _userViewModel;

  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _userController.authenticationStateMonitor();

    String controllerText = _userController.userName ?? "";
    _controllerNome = TextEditingController(text: controllerText);

    isLoggedIn = _userController.isLoggedIn();
  }

  _onSaveFields() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String? uid = _userController.uid;
      String nome = _controllerNome.value.text.toString();
      String genero = _dropdownValue;
      String? email = _userController.email;

      if (_skills != null) {
        await _userController.saveSkills(_skills!);

        _user = GenericUser(
          uid: uid!,
          name: nome,
          gender: Gender.Other, // TODO: remember to mock out this.
          email: email!,
          skills: _skills!.list,
        );
      }

      _userController.saveUser(_user!);

      Navigator.pushNamed(context, '/workers');
    }
  }

  @override
  Widget build(BuildContext context) {
    _userViewModel = Provider.of<UserViewModel>(context);

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
    _skills = _userViewModel.professionalSkills;

    List _categorias =
        _skills != null ? _skills!.list.map((e) => e.name).toList() : [];

    return SingleChildScrollView(
      child: Column(
        children: [
          Constants.LARGE_HEIGHT_BOX,
          if (_userController.photo != null)
            Center(
              child: CircularImageComponent(
                width: 120,
                height: 120,
                borderWidth: 5,
                image: NetworkImage(_userController.photo!),
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
                onChanged: (String? newValue) {
                  setState(() {
                    _dropdownValue = newValue!;
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
                          _userViewModel.setSelectedSkill(tipo);
                          _userViewModel.setSkills(_skills!);

                          Navigator.pushNamed(context, '/servico');
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
