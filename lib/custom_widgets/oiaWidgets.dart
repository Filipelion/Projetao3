import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../infrastructure/constants.dart';
import '../infrastructure/loginAuth.dart';

class OiaScaffold extends StatefulWidget {
  final String appBarTitle;
  final Widget body;
  const OiaScaffold({Key key, this.appBarTitle, this.body}) : super(key: key);
  @override
  _OiaScaffoldState createState() => _OiaScaffoldState();
}

class _OiaScaffoldState extends State<OiaScaffold> {
  LoginAuth _auth;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth = LoginAuth(firebaseAuth: firebaseAuth);
    _auth.authChangeListener();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Constants.COR_MOSTARDA, title: Text(widget.appBarTitle??"Oia"),),
      body: widget.body,
      drawer: OiaSidebar(auth: _auth,),
    );
  }
}


class OiaSidebar extends StatelessWidget {
  final LoginAuth auth;
  const OiaSidebar({Key key, this.auth}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
  print(auth.getUser().toString());
    if (auth.userIsLoggedIn()) {
      return Drawer(
        child: ListView(children: [
          OiaSidebarHeader(auth: auth,),
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
            title: Text("Sair", style: TextStyle(color: Colors.white),),
            onTap: () {
              auth.signOut();
            },
          ),
        ],),
      );
    }
    
    return Drawer(
          child: Center(child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("Faça login para ter acesso a todas as funcionalidades do aplicativo",  textAlign: TextAlign.center,),
        FlatButton(onPressed: () {
          Navigator.pushNamed(context, '/login');
        }, child: Text("Fazer login", style: TextStyle(color: Colors.white),), color: Constants.COR_VINHO,)
      ]),),
    );
  }
}

class OiaSidebarHeader extends StatelessWidget {
  final LoginAuth auth;
  const OiaSidebarHeader({Key key, this.auth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Image userProfilePicture = Image.network(auth.getUserProfilePhoto(), scale: 1.5,) ?? Image.asset('name');
    String userName = auth.getUserProfileName() ?? "Usuário Anônimo";
    String userEmail = auth.getUserEmail() ?? "-";

    return DrawerHeader(
      child: Column(children: [
        Container(child: userProfilePicture, decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0)),),
        Constants.SMALL_HEIGHT_BOX,
        Text(userName, style: TextStyle(fontSize: Constants.mediumFontSize),),
        // Constants.SMALL_HEIGHT_BOX,
        Text(userEmail, style: TextStyle(fontSize: Constants.smallFontSize),),
      ]),
    );
  }
}