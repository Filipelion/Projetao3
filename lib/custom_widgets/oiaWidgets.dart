import 'package:flutter/material.dart';
import '../infrastructure/cartaServico.dart';
import '../infrastructure/constants.dart';
import '../infrastructure/database_integration.dart';
import '../infrastructure/loginAuth.dart';

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
  String uid;

  @override
  void initState() {
    super.initState();
    auth.authChangeListener();
    if (auth.userIsLoggedIn()) {
      setState(() {
        _isLoggedIn = true;
        uid = auth.getUid();
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
      body: Container(
        child: widget.body,
        padding: EdgeInsets.symmetric(horizontal: Constants.largeSpace),
      ),
      drawer: OiaSidebar(),
      bottomNavigationBar:
          widget.showBottomBar && _isLoggedIn ? OiaBottomBar() : null,
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
}

class OiaSidebarHeader extends StatelessWidget {
  final LoginAuth auth;
  const OiaSidebarHeader({Key key, this.auth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImageProvider userProfilePicture = NetworkImage(
      auth.getUserProfilePhoto(),
      scale: 1.5,
    );
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
  LoginAuth _auth = Authentication.loginAuth;
  bool _isLoggedIn = false;
  String _uid;

  @override
  void initState() {
    super.initState();
    _auth.authChangeListener();
    if (_auth.userIsLoggedIn()) {
      setState(() {
        _uid = _auth.getUid();
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
        final cartaServicosController = CartaServicosController();
        Future<CartaServicos> cartaServicos = cartaServicosController.get(_uid);
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

class OiaLargeButton extends StatelessWidget {
  final String title;
  final Function onPressed;

  const OiaLargeButton({this.title, this.onPressed});

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
  final double width, height, borderWidth;
  final ImageProvider image;
  final Color color;

  const OiaRoundedImage(
      {Key key,
      this.width,
      this.height,
      this.borderWidth,
      this.image,
      this.color = Constants.COR_MOSTARDA})
      : super(key: key);

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
      child: Card(
        child: Center(
          child: Text(
            this.title,
            textAlign: TextAlign.center,
          ),
        ),
        color: Colors.yellow[200],
      ),
      onTap: this.onTap,
    );
  }
}

class OiaListTile extends StatelessWidget {
  final String title, subtitle;
  final Function onTap;

  const OiaListTile({Key key, this.title, this.subtitle, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white54,
      title: Text(
        this.title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        this.subtitle,
        style: TextStyle(fontSize: Constants.smallFontSize),
      ),
      onTap: this.onTap,
    );
  }
}
