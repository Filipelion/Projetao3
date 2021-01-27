import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../infrastructure/constants.dart';
import '../infrastructure/loginAuth.dart';



class OiaWorkersList extends StatefulWidget {
  @override
  _OiaWorkersListState createState() => _OiaWorkersListState();
}

class _OiaWorkersListState extends State<OiaWorkersList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: OiaSidebar(),
          body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return CustomScrollView(
              slivers: [
                OiaFlexibleAppbar(),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }),
    );
  }

  getData() async {
    Future.delayed(Duration(seconds: 2));
    return await Firebase.initializeApp();
  }
}

class OiaFlexibleAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Constants.COR_MOSTARDA,
      iconTheme: IconThemeData(color: Colors.black),
      floating: true,
      expandedHeight: 200,
      flexibleSpace: Container(
        margin: EdgeInsets.only(top: 20.0),
        child: Column(children: [
          Padding(padding: EdgeInsets.symmetric(horizontal: Constants.mediumSpace), child: Row(children: [
            // Image.asset("assets/icons/satellite_icon.png"),
            Text("Oia AppBarFlexible")
          ],),),
          TextField(decoration: InputDecoration(),),
        ],),
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
      appBar: AppBar(backgroundColor: Constants.COR_MOSTARDA, title: Text(widget.appBarTitle??"Oia"),),
      body: widget.body,
      drawer: OiaSidebar(),
    );
  }
}

class OiaSidebar extends StatelessWidget {
  final LoginAuth auth = Authentication.loginAuth;
  
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