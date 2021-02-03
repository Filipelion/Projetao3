import 'package:Projetao3/profile.dart';
import 'package:Projetao3/workersList.dart';
import 'package:flutter/material.dart';
import 'serviceRegistragion.dart';
import 'src/login.dart';
import 'src/register.dart';
import 'src/registerPhoto.dart';
import 'workersList.dart';
//import 'src/perfilShift.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: _buildRoutes(context),
      initialRoute: '/workers',
      debugShowCheckedModeBanner: false,
    );
  }

  _buildRoutes(context) {
    return {
      '/login': (context) => Login(),
      '/register': (context) => RegisterPage(),
      '/registerPhoto': (context) => RegisterPhotoPage(),
      '/workers': (context) => WorkersPage(),
      '/service_registration': (context) => ServiceRegistration(),
      '/profile': (context) => Profile(),
    };
  }
}
