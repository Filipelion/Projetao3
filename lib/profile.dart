import 'package:flutter/material.dart';
import 'custom_widgets/oiaWidgets.dart';
import 'infrastructure/constants.dart';
import 'infrastructure/loginAuth.dart';

class Profile extends StatefulWidget {
  List<String> tags;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  LoginAuth auth;
  bool isLoggedIn = true;
  TextEditingController _controllerNome;
  List _generos = ['Feminino', 'Masculino', 'Não binário', 'Prefiro não dizer'];
  String _dropdownValue;

  // List categorias;

  @override
  void initState() {
    // TODO: implement initState
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
            child: Column(children: [
              TextFormField(
                controller: _controllerNome,
                decoration: InputDecoration(
                  labelText: "Nome",
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
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
                onPressed: () {},
              ),
              Constants.MEDIUM_HEIGHT_BOX,
            ]),
          ),
        ],
      ),
    );
  }
}
