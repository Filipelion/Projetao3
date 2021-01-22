import 'package:flutter/material.dart';
import '../infrastructure/constants.dart';
import '../infrastructure/loginAuth.dart';

class LoginPage extends StatelessWidget {
  final _auth = LoginAuth();
  final _scaffoldState = GlobalKey<ScaffoldState>();

  _googleSignIn() {
    _auth.signInWithGoogle().then((value) {
      if (value != null) {
        _showLoadingSnackbar();
      } else {
        _showErrorSnackbar();
      }
    });
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
                  "Seja bem vindo!",
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
                          fontSize: Constants.mediumFontSize),
                    ),
                    onPressed: () {},
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
                        style: TextStyle(fontSize: Constants.mediumFontSize),
                      ),
                      onPressed: () {}),
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
