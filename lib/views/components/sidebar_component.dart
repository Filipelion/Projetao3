import 'package:flutter/material.dart';
import 'package:Projetao3/core/locator.dart';
import 'package:Projetao3/services/login_service.dart';
import 'package:Projetao3/views/components/circular_image_component.dart';
import 'package:Projetao3/views/shared/constants.dart';

class SidebarComponent extends StatefulWidget {
  @override
  _SidebarComponentState createState() => _SidebarComponentState();
}

class _SidebarComponentState extends State<SidebarComponent> {
  bool isLoggedIn = false;

  LoginService _loginService = locator<LoginService>();

  @override
  void initState() {
    super.initState();
    _loginService.authChangeListener();
    if (_loginService.userIsLoggedIn()) {
      isLoggedIn = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn ? _buildLoggedView(context) : _buildGuestView(context);
  }

  _buildLoggedView(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          _buildSidebarHeader(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Configurações"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.people),
            title: Text("Profissionais"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            tileColor: Colors.red,
            title: Text(
              "Sair",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              _loginService.signOut();
              setState(() {
                isLoggedIn = false;
              });
            },
          ),
        ],
      ),
    );
  }

  _buildGuestView(BuildContext context) {
    return Drawer(
      child: Center(
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
      ),
    );
  }

  _buildSidebarHeader() {
    String? profilePic = _loginService.getUserProfilePhoto();

    if (profilePic == null) {
      throw UnimplementedError(
          "Implementar uma imagem padrão para quando o usuário não possuir foto de perfil.");
    }

    ImageProvider userProfilePicture = NetworkImage(
      profilePic,
      scale: 1.5,
    );

    String userName = _loginService.getUserProfileName() ?? "Usuário Anônimo";
    String userEmail = _loginService.getUserEmail() ?? "-";

    return DrawerHeader(
      decoration: BoxDecoration(color: Constants.COR_MOSTARDA),
      child: Column(children: [
        CircularImageComponent(
          width: 70,
          height: 70,
          borderWidth: 3,
          color: Colors.black87,
          image: userProfilePicture,
        ),
        Constants.SMALL_HEIGHT_BOX,
        Text(
          userName,
          style: TextStyle(fontSize: Constants.mediumFontSize),
        ),
        // Constants.SMALL_HEIGHT_BOX,
        Text(
          userEmail,
          style: TextStyle(fontSize: Constants.smallFontSize),
        ),
      ]),
    );
  }
}
