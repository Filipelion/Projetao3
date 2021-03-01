import 'package:Projetao3/crudServico/crudServicosArgs.dart';
import 'package:Projetao3/infrastructure/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../custom_widgets/oiaWidgets.dart';
import '../infrastructure/cartaServico.dart';
import '../infrastructure/imageProvider.dart';
import '../infrastructure/loginAuth.dart';

class CrudServico extends StatefulWidget {
  @override
  _CrudServicoState createState() => _CrudServicoState();
}

class _CrudServicoState extends State<CrudServico> {
  CartaServicos _cartaServicos;
  String _tipo, uid;
  Future<List> _imagens;
  List _imagensURL = [];
  LoginAuth auth = Authentication.loginAuth;

  final _formKey = GlobalKey<FormState>();

  TextEditingController _valorMedioController, _descricaoController;
  String _valorMedio, _descricao;

  final imageProvider = OiaImageProvider();
  @override
  void initState() {
    super.initState();
    auth.authChangeListener();
    uid = auth.getUid();
    _imagens = Future.delayed(
      Duration(seconds: 4),
      () => imageProvider.getAllImagesOfAService(uid, _tipo),
    );
  }

  _onSaveFields() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      String valorMedioText = _valorMedioController.value.text;
      num valorMedio = valorMedioText != "" ? num.parse(valorMedioText) : 0;

      String descricao = _descricaoController.value.text;

      Map<String, dynamic> json = {
        'tipo': _tipo,
        'imagens': _imagensURL,
        'valorMedio': valorMedio,
        'descricao': descricao,
      };

      Servico _servico = Servico.fromJson(json);
      Map<String, dynamic> servicoData = _servico.toJson();
      _cartaServicos.save(_tipo, servicoData);
      print(_cartaServicos.get().toString());
      Navigator.pushNamed(context, '/profile', arguments: _cartaServicos);
    }
  }

  @override
  Widget build(BuildContext context) {
    CrudServicoArgs args = ModalRoute.of(context).settings.arguments;
    setState(() {
      _cartaServicos = args.cartaServicos;
      _tipo = args.tipo;

      Servico _servico = _cartaServicos.getServico(_tipo);
      _valorMedio = _servico.valorMedio.toString();
      _descricao = _servico.descricao;
      _valorMedioController = TextEditingController(text: _valorMedio);
      _descricaoController = TextEditingController(text: _descricao);
    });

    return OiaScaffold(
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
                        imageProvider
                            .sendImage(ImageSource.camera, _tipo, uid)
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
                            break;
                          case ConnectionState.none:
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Não foi possível recuperar as imagens...")));
                            return null;
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
            OiaLargeButton(
              title: "Salvar",
              onPressed: _onSaveFields,
            ),
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
