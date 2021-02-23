import 'package:Projetao3/crudServico/crudServico.dart';
import 'package:Projetao3/perfil_visualizacao.dart';
import 'package:Projetao3/profile.dart';
import 'package:Projetao3/workersList.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'serviceRegistragion.dart';
import 'src/login.dart';
import 'src/register.dart';
import 'src/registerPhoto.dart';
import 'workersList.dart';
//import 'src/perfilShift.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      '/worker_info' : (context) => WorkerProfile(),
    };
  }
}
