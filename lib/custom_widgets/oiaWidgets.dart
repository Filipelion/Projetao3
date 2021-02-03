import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../infrastructure/constants.dart';
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
                      "Encontre\nprofissionais",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: Constants.regularFontSize),
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
  final bool showBottomBar;
  const OiaScaffold(
      {Key key, this.appBarTitle, this.body, this.showBottomBar = false})
      : super(key: key);
  @override
  _OiaScaffoldState createState() => _OiaScaffoldState();
}

class _OiaScaffoldState extends State<OiaScaffold> {
  LoginAuth auth = Authentication.loginAuth;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    auth.authChangeListener();
    if(auth.userIsLoggedIn()) {
      setState(() {
        _isLoggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.COR_MOSTARDA,
        title: Text(
          widget.appBarTitle ?? "Oia",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(child: widget.body, padding: EdgeInsets.symmetric(horizontal: Constants.largeSpace),),
      drawer: OiaSidebar(),
      bottomNavigationBar: widget.showBottomBar && _isLoggedIn ? OiaBottomBar() : null,
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
              Constants.SMALL_HEIGHT_BOX,
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
    ImageProvider userProfilePicture = NetworkImage(auth.getUserProfilePhoto(), scale: 1.5,);
    String userName = auth.getUserProfileName() ?? "Usuário Anônimo";
    String userEmail = auth.getUserEmail() ?? "-";

    return DrawerHeader(
      decoration: BoxDecoration(color: Constants.COR_MOSTARDA),
      child: Column(children: [
        OiaRoundedImage(
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

class OiaBottomBar extends StatefulWidget {
  @override
  _OiaBottomBarState createState() => _OiaBottomBarState();
}

class _OiaBottomBarState extends State<OiaBottomBar> {
  List _routes = ['/workers', '/service_registration', '/profile'];
  int _currentIndex = 0;

  void _navigateToRoute(int index) {
    setState(() {
      _currentIndex = index;
    });

    String route = _routes[index];
    // Indo para a próxima tela
    if(index == 2) {
      // TODO: Recuperar os serviços de um usuário e passar em uma lista para a tela de perfil.
      Navigator.pushNamed(context, route, arguments: ["teste"]);   
    } else {
      Navigator.pushNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        unselectedIconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Constants.COR_MOSTARDA,
        currentIndex: _currentIndex,
        selectedIconTheme: IconThemeData(color: Constants.COR_VINHO),
        selectedLabelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        onTap: _navigateToRoute,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Anunciar"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil")
        ]);
  }
}

class OiaLargeButton extends StatelessWidget {
  String title;
  Function onPressed;

  OiaLargeButton({this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: RaisedButton(
        child: Text(
          this.title,
          style: TextStyle(
              fontSize: Constants.regularFontSize, color: Colors.white),
        ),
        onPressed: this.onPressed,
        color: Constants.COR_VINHO,
      ),
    );
  }
}

class OiaRoundedImage extends StatelessWidget {
  double width, height, borderWidth;
  ImageProvider image;
  Color color;

  OiaRoundedImage({
    Key key,
    this.width,
    this.height,
    this.borderWidth,
    this.image,
    this.color = Constants.COR_MOSTARDA
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      width: this.width,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: this.color,
            width: this.borderWidth,
          ),
          image: DecorationImage(
            image: this.image,
            fit: BoxFit.fill,
          )),
    );
  }
}

class OiaClickableCard extends StatelessWidget {
  final String title;
  final Function onTap;

  const OiaClickableCard({Key key, this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(child: Center(child: Text(this.title),), color: Colors.yellow[200],),
      onTap: this.onTap,
    );
  }
}