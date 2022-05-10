import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:Projetao3/repository/professional_skills_repository.dart';
import 'package:Projetao3/repository/user_repository.dart';
import 'package:Projetao3/services/firebase_service.dart';
import 'package:Projetao3/services/geolocation_service.dart';
import 'package:Projetao3/services/image_service.dart';
import 'package:Projetao3/services/login_service.dart';
import 'package:Projetao3/services/tags_service.dart';
import 'package:Projetao3/views/controllers/login_controller.dart';
import 'package:Projetao3/views/controllers/user_controller.dart';

GetIt locator = GetIt.instance;

setupLocator() {
  // Create repositories instances
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => ProfessionalSkillsRepository());

  // Create services instances
  locator.registerLazySingleton(() => GeolocationService());
  locator.registerLazySingleton(
    () => LoginService(firebaseAuth: FirebaseAuth.instance),
  );
  locator.registerLazySingleton(() => TagsService());
  locator.registerLazySingleton(() => ImageService());
  locator.registerLazySingleton(() => FirebaseService());

  // Create controllers instances
  locator.registerLazySingleton(() => LoginController());
  locator.registerLazySingleton(() => UserController());
}
