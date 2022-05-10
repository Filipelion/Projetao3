import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Projetao3/core/locator.dart';
import 'package:Projetao3/repository/professional_skills_repository.dart';
import 'package:Projetao3/views/components/button_component.dart';
import 'package:Projetao3/views/providers/worker_viewmodel.dart';
import 'package:Projetao3/views/screens/base_screen.dart';
import 'package:Projetao3/views/shared/utils.dart';
import '../shared/constants.dart';
import '../../services/image_service.dart';

class WorkerProfileScreen extends StatefulWidget {
  @override
  _WorkerProfileScreenState createState() => _WorkerProfileScreenState();
}

class _WorkerProfileScreenState extends State<WorkerProfileScreen> {
  String? _descricao;
  late num _valorMedio;

  late WorkerViewModel _workerViewModel;

  final imageProvider = ImageService();
  ProfessionalSkillsRepository _skillsRepository =
      locator<ProfessionalSkillsRepository>();

  // TODO: Those attributes will be used on the service images carousel.
  Future<List>? _imagens;
  List? _imagensURL;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _workerViewModel = Provider.of<WorkerViewModel>(context);

    var _tag = _workerViewModel.tag;

    if (_tag == null) {
      throw Exception("A tag não pode ser nula");
    }

    setState(() {
      _skillsRepository.get(_workerViewModel.uid!).then((value) {
        var skills = value.list;

        var skill = skills.where((element) => element.name == _tag).first;
        _descricao = skill.description;
        _valorMedio = skill.meanValue ?? 0;
      });

      _imagens = Future.delayed(
        Duration(seconds: 4),
        () => imageProvider.getServiceImages(_workerViewModel.uid!, _tag),
      );
    });

    return BaseScreen(
      showBottomBar: true,
      appBarTitle: _workerViewModel.name ?? "",
      body: FutureBuilder(
          future: _imagens,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _imagensURL = snapshot.data as List;
                return _buildBody();
                break;
              case ConnectionState.none:
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Não foi possível recuperar as imagens...")));
                return Container();
                break;
              default:
                return Center(
                  child: CircularProgressIndicator(),
                );
                break;
            }
          }),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Constants.SMALL_HEIGHT_BOX,
          // _buildCarousel(_imagensURL),
          Constants.LARGE_HEIGHT_BOX,
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(Constants.smallSpace),
            width: Utils.screenDimensions(context).size.width * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Descrição",
                  style: TextStyle(
                      fontSize: Constants.mediumFontSize,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Constants.SMALL_HEIGHT_BOX,
                Text(
                  _descricao ?? "",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: Constants.regularFontSize),
                ),
              ],
            ),
          ),
          Constants.MEDIUM_HEIGHT_BOX,
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(Constants.smallSpace),
            width: Utils.screenDimensions(context).size.width * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Valor Médio",
                  style: TextStyle(
                      fontSize: Constants.mediumFontSize,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Constants.SMALL_HEIGHT_BOX,
                Text(
                  _valorMedio == 0 || _valorMedio == null
                      ? "Sem preço definido"
                      : "R\$ $_valorMedio",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: Constants.regularFontSize),
                ),
              ],
            ),
          ),
          Constants.LARGE_HEIGHT_BOX,
          ButtonComponent(
            title: "Encontrar no mapa",
            onPressed: () {
              Navigator.pushNamed(context, '/map');
            },
          ),
          // TODO: Implementar tela de salvar contato
          ButtonComponent(
            title: "Salvar contato",
            onPressed: () {},
          ),
          Constants.MEDIUM_HEIGHT_BOX,
        ],
      ),
    );
  }

  // _buildCarousel(List imagens) {
  //   throw UnimplementedError("Carrossel não implementado!! Procurar lib.");

  //   return SizedBox(
  //     height: Utils.screenDimensions(context).size.height * 0.35,
  //     width: Utils.screenDimensions(context).size.width * 0.8,
  //     child: Carousel(
  //       images: imagens.map((e) => Image.network(e)).toList(),
  //       borderRadius: true,
  //       autoplay: false,
  //       animationDuration: Duration(milliseconds: 600),
  //     ),
  //   );
  // }
}
