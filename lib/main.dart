import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Projetao3/core/locator.dart';
import 'views/screens/serviceRegistragion.dart';
import 'views/screens/login.dart';
import 'views/screens/register.dart';
import 'models/registerPhoto.dart';
import './workersList.dart';
import 'views/screens/crudServico.dart';
import 'views/screens/perfil_visualizacao.dart';
import 'views/screens/profile.dart';
import 'views/screens/map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  setupLocator();

  runApp(MyApp());
}

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
      '/servico': (context) => CrudServico(),
      '/worker_info': (context) => WorkerProfile(),
      '/map': (context) => MapScreen(),
    };
  }
}
