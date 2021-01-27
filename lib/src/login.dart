import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../infrastructure/constants.dart';
import '../infrastructure/loginAuth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseAuth firebaseAuth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _connectToFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return LoginPage(firebaseAuth: firebaseAuth);
          } else if (snapshot.connectionState == ConnectionState.none) {
            Scaffold.of(context).showBottomSheet((context) => Text(
                "App temporariamente indisponível. Tente novamente mais tarde"));
          }
          return _buildLoadingPage();
        },
      ),
    );
  }

  Future<FirebaseApp> _connectToFirebase() async {
    FirebaseApp defaultApp = await Firebase.initializeApp();
    firebaseAuth = FirebaseAuth.instanceFor(app: defaultApp);
    return defaultApp;
  }

  Widget _buildLoadingPage() {
    return Container(
      color: Constants.COR_MOSTARDA,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  final FirebaseAuth firebaseAuth;
  const LoginPage({Key key, this.firebaseAuth}) : super(key: key);
  
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginAuth auth;
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    auth = LoginAuth(firebaseAuth: widget.firebaseAuth);
    auth.authChangeListener();
  }

  void _googleSignIn() {

    auth.signInWithGoogle().then((value) {
        if(value != null) {
          _showLoadingSnackbar();
          _goToWorkersPage();
        } else {
          _showErrorSnackbar();
        }
        print(value.toString());
    });
  }

  void _facebookSignIn() {
    auth.signInWithFacebook().then((value) {
      if(value != null) {
          print(value.toString());
          _showLoadingSnackbar();
          _goToWorkersPage();
          
        } else {
          _showErrorSnackbar();
        }
    });
  }

  _goToWorkersPage() {
    Navigator.popAndPushNamed(context, '/workers');
  }

  _showLoadingSnackbar() {
    _scaffoldState.currentState
        .showSnackBar(SnackBar(content: Text("Fazendo login...")));
  }

  _showErrorSnackbar() {
    _scaffoldState.currentState.showSnackBar(SnackBar(
        content: Text(
            "Não foi possível realizar o login. Tente novamente mais tarde.")));
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldState,
      backgroundColor: Constants.COR_MOSTARDA,
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: Constants.extraLargeSpace,
        ),
        width: screen.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                this._buildLogo(),
                Constants.LARGE_HEIGHT_BOX,
                Text(
                  "Smart Work!",
                  style: TextStyle(fontSize: Constants.largeFontSize),
                ),
              ],
            ),
            Wrap(
              direction: Axis.vertical,
              children: [
                Container(
                  width: screen.width * 0.8,
                  height: Constants.extraLargeSpace,
                  child: RaisedButton(
                    // TODO: ADICIONAR A LOGO DO GOOGLE PARA ESTE BOTÃO
                    child: Text(
                      "Login com Google",
                      style: TextStyle(
                          color: Constants.COR_MOSTARDA,
                          fontSize: Constants.smallFontSize),
                    ),
                    onPressed: _googleSignIn,
                    color: Colors.black,
                  ),
                ),
                Constants.SMALL_HEIGHT_BOX,
                Container(
                  width: screen.width * 0.8,
                  height: Constants.extraLargeSpace,
                  child: RaisedButton(
                    // TODO: ADICIONAR A LOGO DO FACEBOOK PARA ESTE BOTÃO
                    child: Text(
                      "Login com Facebook",
                      style: TextStyle(fontSize: Constants.smallFontSize),
                    ),
                    onPressed: _facebookSignIn,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      "assets/icons/logo.png",
      scale: 0.8,
    );
  }
}
