import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'src/login.dart';
import 'src/register.dart';
import 'src/registerPhoto.dart';
//import 'src/perfilShift.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: _buildRoutes(context),
      initialRoute: '/login',
    );
  }

  _buildRoutes(context) {
    return {
      '/login': (context) => LoginPage(),
      '/register': (context) => RegisterPage(),
      '/registerPhoto': (context) => RegisterPhotoPage(),
      //'/perfilShift': (context)=> PerfiShift(),
    };
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
        children: [
          SplashScreen(
            seconds: 4,
            backgroundColor: Color(0XFFFFBA00),
            navigateAfterSeconds: _loadNextPage(),
          ),
          Container(
            child: Image.network('assets/icons/logo.svg'),
          ),
        ],
      ),
    );
  }

  _loadNextPage() {
    // TODO: Criar a página inicial que Felipe sugeriu
    // por enquanto:
    return LoginPage();
  }
}
