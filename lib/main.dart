import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Projetao3/core/locator.dart';
import 'package:Projetao3/views/providers/instances.dart';
import 'package:Projetao3/views/screens/register_photo_screen.dart';
import 'views/screens/service_registration_screen.dart';
import 'views/screens/login_screen.dart';
import 'views/screens/register_screen.dart';
import 'views/screens/workers_list_screen.dart';
import 'views/screens/skills_crud.dart';
import 'views/screens/worker_profile_screen.dart';
import 'views/screens/profile_screen.dart';
import 'views/screens/map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  setupLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: Providers.instances(),
      child: MaterialApp(
        routes: _buildRoutes(context),
        initialRoute: '/workers',
        debugShowCheckedModeBanner: false,
      ),
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
      '/servico': (context) => SkillsCrud(),
      '/worker_info': (context) => WorkerProfile(),
      '/map': (context) => MapScreen(),
    };
  }
}
