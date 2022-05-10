import 'package:provider/provider.dart';
import 'package:Projetao3/core/locator.dart';
import 'package:Projetao3/models/professional_skill.dart';
import 'package:Projetao3/models/professional_skills_list.dart';
import 'package:Projetao3/views/components/button_component.dart';
import 'package:Projetao3/views/controllers/user_controller.dart';
import 'package:Projetao3/views/providers/user_viewmodel.dart';
import 'package:Projetao3/views/screens/base_screen.dart';
import 'package:Projetao3/views/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/image_service.dart';

class SkillsCrud extends StatefulWidget {
  @override
  _SkillsCrudState createState() => _SkillsCrudState();
}

class _SkillsCrudState extends State<SkillsCrud> {
  late ProfessionalSkillsList _skillsList;
  late String _tipo;
  String? uid;
  Future<List>? _imagens;
  List _imagensURL = [];

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _valorMedioController, _descricaoController;
  String? _valorMedio, _descricao;

  late UserViewModel _userViewModel;

  UserController _userController = locator<UserController>();

  final imageProvider = ImageService();

  @override
  void initState() {
    super.initState();
    _userController.authenticationStateMonitor();

    uid = _userController.uid;

    _valorMedioController = TextEditingController(text: _valorMedio);
    _descricaoController = TextEditingController(text: _descricao);
  }

  _onSaveFields() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String valorMedioText = _valorMedioController.value.text;
      num valorMedio = valorMedioText != "" ? num.parse(valorMedioText) : 0;

      String descricao = _descricaoController.value.text;

      ProfessionalSkill skill = ProfessionalSkill(
        name: _tipo,
        images: _imagensURL,
        meanValue: valorMedio,
        description: descricao,
      );

      _userController.addSkill(skill, _skillsList);

      Navigator.pushNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    _userViewModel = Provider.of<UserViewModel>(context);

    _tipo = _userViewModel.selectedSkill!;

    setState(() {
      if (uid != null) {
        _imagens = Future.delayed(
          Duration(seconds: 4),
          () => imageProvider.getServiceImages(uid!, _tipo),
        );
      }

      ProfessionalSkill skill =
          _skillsList.list.where((element) => element.name == _tipo).first;

      _valorMedio = skill.meanValue.toString();
      _descricao = skill.description;

      _valorMedioController = TextEditingController(text: _valorMedio);
      _descricaoController = TextEditingController(text: _descricao);
    });

    return BaseScreen(
      appBarTitle: _tipo,
      body: _buildBody(),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Constants.LARGE_HEIGHT_BOX,
            Text(
              _tipo,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Constants.mediumFontSize,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Constants.MEDIUM_HEIGHT_BOX,
            Text(
              "Adicione informações sobre o serviço abaixo. Fale um pouco sobre a sua experiência, preço dos serviços, formas de pagamento e regiões onde você atua.",
              textAlign: TextAlign.justify,
            ),
            Constants.LARGE_HEIGHT_BOX,
            TextFormField(
              controller: _valorMedioController,
              decoration: InputDecoration(
                isDense: true,
                labelText: "Valor Médio (R\$)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            Constants.MEDIUM_HEIGHT_BOX,
            TextFormField(
              controller: _descricaoController,
              decoration: InputDecoration(
                isDense: true,
                labelText: "Descrição",
                border: OutlineInputBorder(),
              ),
              maxLines: 6,
            ),
            Constants.MEDIUM_HEIGHT_BOX,
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(Constants.smallSpace),
              child: Column(
                children: [
                  Constants.MEDIUM_HEIGHT_BOX,
                  Text(
                    "Imagens",
                    style: TextStyle(
                      fontSize: Constants.regularFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Constants.SMALL_HEIGHT_BOX,
                  Text("Adicione as imagens do serivço abaixo:"),
                  Constants.MEDIUM_HEIGHT_BOX,
                  TextButton.icon(
                      onPressed: () {
                        if (uid != null)
                          imageProvider
                              .sendImage(ImageSource.camera, _tipo, uid!)
                              .then((value) {
                            if (value != null) {
                              print(value);
                              setState(() {
                                _imagensURL.add(value);
                                print(_imagensURL);
                              });
                            }
                          });
                      },
                      icon: Icon(Icons.camera),
                      label: Text("Adicionar imagem")),
                  Constants.MEDIUM_HEIGHT_BOX,
                  FutureBuilder<List<dynamic>>(
                      future: _imagens,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.done:
                            _imagensURL = snapshot.data ?? [];
                            return _buildGridView();
                          case ConnectionState.none:
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "Não foi possível recuperar as imagens...",
                              ),
                            ));
                            return Container();
                          default:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                        }
                      })
                ],
              ),
            ),
            Constants.MEDIUM_HEIGHT_BOX,
            ButtonComponent(title: "Salvar", onPressed: _onSaveFields),
            Constants.LARGE_HEIGHT_BOX,
          ],
        ),
      ),
    );
  }

  _buildGridView() {
    return GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(_imagensURL.length, (index) {
          String imageURL = _imagensURL[index];

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(imageURL),
              ),
            ),
          );
        }));
  }
}
