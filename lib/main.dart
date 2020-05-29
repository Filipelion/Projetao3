import 'package:flutter/material.dart';
import 'src/login.dart';
import 'src/register.dart';
import 'src/registerPhoto.dart';
//import 'src/perfilShift.dart';

void main() => runApp( MyApp());

class MyApp extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/login': (context)=> LoginPage(),
        '/register': (context)=> RegisterPage(),
        '/registerPhoto': (context)=> RegisterPhotoPage(),
        //'/perfilShift': (context)=> PerfiShift(),
      },
      initialRoute: '/login',
    );
  }

}
