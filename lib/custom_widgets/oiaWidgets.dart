import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../infrastructure/constants.dart';
import '../infrastructure/loginAuth.dart';

class OiaFlexibleAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Constants.COR_MOSTARDA,
      iconTheme: IconThemeData(color: Colors.black),
      floating: true,
      expandedHeight: 200,
      flexibleSpace: Container(
        margin: EdgeInsets.only(
            top: Constants.mediumSpace, bottom: Constants.largeSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Constants.mediumSpace),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    "assets/icons/satellite_icon.png",
                    width: 50,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text(
                      "Encontre profissionais",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: Constants.mediumFontSize),
                    ),
                  )
                ],
              ),
            ),
            Constants.MEDIUM_HEIGHT_BOX,
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusColor: Colors.white,
                    hoverColor: Colors.white,
                    hintText: "Buscar...",
                    prefixIcon: Icon(Icons.search),
                    fillColor: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OiaScaffold extends StatefulWidget {
  final String appBarTitle;
  final Widget body;
  const OiaScaffold({Key key, this.appBarTitle, this.body}) : super(key: key);
  @override
  _OiaScaffoldState createState() => _OiaScaffoldState();
}

class _OiaScaffoldState extends State<OiaScaffold> {
  LoginAuth auth = Authentication.loginAuth;

  @override
  void initState() {
    super.initState();
    auth.authChangeListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.COR_MOSTARDA,
        title: Text(widget.appBarTitle ?? "Oia"),
      ),
      body: widget.body,
      drawer: OiaSidebar(),
    );
  }
}

class OiaSidebar extends StatefulWidget {
  @override
  _OiaSidebarState createState() => _OiaSidebarState();
}

class _OiaSidebarState extends State<OiaSidebar> {
  LoginAuth auth = Authentication.loginAuth;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    auth.authChangeListener();
    if (auth.userIsLoggedIn()) {
      isLoggedIn = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      return Drawer(
        child: ListView(
          children: [
            OiaSidebarHeader(
              auth: auth,
            ),
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
                auth.signOut();
                setState(() {
                  isLoggedIn = false;
                });
              },
            ),
          ],
        ),
      );
    }

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
              FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  "Fazer login",
                  style: TextStyle(color: Colors.white),
                ),
                color: Constants.COR_VINHO,
              )
            ]),
      ),
    );
  }
}

class OiaSidebarHeader extends StatelessWidget {
  final LoginAuth auth;
  const OiaSidebarHeader({Key key, this.auth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Image userProfilePicture = Image.network(
          auth.getUserProfilePhoto(),
          scale: 1.5,
        ) ??
        Image.asset('name');
    String userName = auth.getUserProfileName() ?? "Usuário Anônimo";
    String userEmail = auth.getUserEmail() ?? "-";

    return DrawerHeader(
      child: Column(children: [
        Container(
          child: userProfilePicture,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0)),
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

class OiaBottomBar extends StatefulWidget {
  @override
  _OiaBottomBarState createState() => _OiaBottomBarState();
}

class _OiaBottomBarState extends State<OiaBottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        unselectedIconTheme: IconThemeData(color: Colors.black),
        selectedIconTheme: IconThemeData(color: Constants.COR_VINHO),
        backgroundColor: Constants.COR_MOSTARDA,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add), label: "Adicionar trabalho"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil")
        ]);
  }
}
