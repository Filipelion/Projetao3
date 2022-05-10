import 'package:Projetao3/core/locator.dart';
import 'package:Projetao3/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:Projetao3/views/controllers/login_controller.dart';
import 'package:Projetao3/views/shared/utils.dart';
import '../shared/constants.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginPage(),
      // body: FutureBuilder(
      //   future: _connectToFirebase(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
      //     } else if (snapshot.connectionState == ConnectionState.none) {
      //       Scaffold.of(context).showBottomSheet((context) => Text(
      //           "App temporariamente indisponível. Tente novamente mais tarde"));
      //     }
      //     return _buildLoadingPage();
      //   },
      // ),
    );
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
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController _loginController = locator<LoginController>();
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  UserRepository _userRepository = locator<UserRepository>();

  @override
  void initState() {
    super.initState();
  }

  _goToNextPage(String id) async {
    debugPrint("goToNextPage was called");
    if (await _userRepository.userExists(id)) {
      Navigator.popAndPushNamed(context, '/workers');
    } else {
      Navigator.popAndPushNamed(context, '/service_registration');
    }
  }

  _showLoadingSnackbar() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Fazendo login...")));
  }

  _showErrorSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "Não foi possível realizar o login. Tente novamente mais tarde.")));
  }

  @override
  Widget build(BuildContext context) {
    Size screen = Utils.screenDimensions(context).size;
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
                  child: ElevatedButton(
                    // TODO: ADICIONAR A LOGO DO GOOGLE PARA ESTE BOTÃO
                    child: Text(
                      "Login com Google",
                      style: TextStyle(
                          color: Constants.COR_MOSTARDA,
                          fontSize: Constants.smallFontSize),
                    ),
                    onPressed: () async => _loginController.googlSignin(),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black)),
                  ),
                ),
                Constants.SMALL_HEIGHT_BOX,
                Container(
                  width: screen.width * 0.8,
                  height: Constants.extraLargeSpace,
                  child: ElevatedButton(
                    // TODO: ADICIONAR A LOGO DO FACEBOOK PARA ESTE BOTÃO
                    child: Text(
                      "Login com Facebook",
                      style: TextStyle(fontSize: Constants.smallFontSize),
                    ),
                    onPressed: () async =>
                        await _loginController.facebookSignin(),
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
