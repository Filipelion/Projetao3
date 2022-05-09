import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// TODO: Find a way to log in with Facebook.
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class LoginService {
  FirebaseAuth firebaseAuth;
  LoginService({this.firebaseAuth});

  GoogleSignIn _googleSignIn = GoogleSignIn();
  FacebookLogin _facebookLogin = FacebookLogin();

  User? _currentUser;

  Future<void> signOut() async {
    return await firebaseAuth.signOut();
  }

  void authChangeListener() {
    firebaseAuth.authStateChanges().listen((user) {
      _currentUser = user;
    });
  }

  User getUser() {
    return this._currentUser;
  }

  bool userIsLoggedIn() {
    return this.getUser() != null;
  }

  Future<User> returnFirebaseUser(AuthCredential credential) async {
    /* Recebe como parâmetros as credenciais geradas pelo método de autenticação 
    (no caso, Google ou Facebook) e retorna um Firebase User */
    final UserCredential authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final User user = authResult.user;
    this._currentUser = user;
    return user;
  }

  Future<User?> signInWithGoogle() async {
    print("SignIn method called...");
    if (this.userIsLoggedIn()) return _currentUser;

    try {
      print("Trying to sign in");

      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      Map googleTokens = {
        'idToken': googleSignInAuthentication.idToken,
        'accessToken': googleSignInAuthentication.accessToken
      };

      // O AuthCredential vem de qualquer AuthProvider (Facebook, Github, Linkedin, etc...)
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleTokens['idToken'],
          accessToken: googleTokens['accessToken']);

      User user = await returnFirebaseUser(credential);
      print(user.toString());

      return user;
    } catch (e) {
      print("Aconteceu um erro: $e");
      return null;
    }
  }

  Future<User?> signInWithFacebook() async {
    if (this.userIsLoggedIn()) return _currentUser;

    try {
      print("Getting Facebook Login Result...");
      final FacebookLoginResult loginResult =
          await _facebookLogin.logIn(["email"]);
      final String accessToken = loginResult.accessToken.token;
      final AuthCredential credential =
          FacebookAuthProvider.credential(accessToken);

      User user = await returnFirebaseUser(credential);
      return user;
    } catch (e) {
      print("Aconteceu um erro: $e");
      return null;
    }
  }

  String getUserProfilePhoto() {
    return this.getUser().photoURL;
  }

  String getUserProfileName() {
    return this.getUser().displayName;
  }

  String getUserEmail() {
    return this.getUser().email;
  }

  String getUid() {
    return this.getUser().uid;
  }
}
