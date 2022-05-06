import 'package:flutter/material.dart';
import 'package:Projetao3/core/locator.dart';
import 'package:Projetao3/repository/professional_skills_repository.dart';
import 'package:Projetao3/services/login_service.dart';
import 'package:Projetao3/views/shared/constants.dart';

class BottomNavigationComponent extends StatefulWidget {
  @override
  _BottomNavigationComponentState createState() =>
      _BottomNavigationComponentState();
}

class _BottomNavigationComponentState extends State<BottomNavigationComponent> {
  List _routes = ['/workers', '/service_registration', '/profile'];
  int _currentIndex = 0;
  LoginService _loginService = locator<LoginService>();
  bool _isLoggedIn = false;
  String _uid;

  @override
  void initState() {
    super.initState();
    _loginService.authChangeListener();
    if (_loginService.userIsLoggedIn()) {
      setState(() {
        _uid = _loginService.getUid();
        _isLoggedIn = true;
      });
    } else {
      setState(() {
        _isLoggedIn = false;
      });
    }
  }

  void _navigateToRoute(int index) {
    setState(() {
      _currentIndex = index;
    });

    String route = _routes[index];

    try {
      if (index == 2) {
        ProfessionalSkillsRepository _skillsRepository =
            locator<ProfessionalSkillsRepository>();

        Future<CartaServicos> cartaServicos = _skillsRepository.get(_uid);

        cartaServicos.then((value) {
          Navigator.pushNamed(context, route, arguments: value);
        });
      } else {
        Navigator.pushNamed(context, route);
      }
    } catch (e) {
      print(
          "Não foi possível acessar a tela seguinte pois o usuário não está logado: $e");
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        unselectedIconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Constants.COR_MOSTARDA,
        currentIndex: _currentIndex,
        selectedIconTheme: IconThemeData(color: Constants.COR_VINHO),
        selectedLabelStyle:
            TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        onTap: _navigateToRoute,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Anunciar"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil")
        ]);
  }
}
