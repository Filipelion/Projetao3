import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  late FirebaseAuth _firebaseAuth;

  FirebaseAuth get auth => _firebaseAuth;

  FirebaseService() {
    Firebase.initializeApp().then(
      (value) => _firebaseAuth = FirebaseAuth.instanceFor(app: value),
    );
  }
}
