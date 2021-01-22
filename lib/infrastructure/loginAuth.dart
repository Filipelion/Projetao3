import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class LoginAuth {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookLogin = FacebookLogin();

  User _currentUser;

  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  void authChangeListener() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _currentUser = user;
    });
  }

  Future<bool> userIsInDatabase() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('Usuario')
          .doc(_currentUser.uid)
          .get();
      return documentSnapshot.exists;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isTestDone() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('Pontuacao')
          .doc(_currentUser.uid)
          .get();
      return documentSnapshot.exists;
    } catch (e) {
      return false;
    }
  }

  User getUser() {
    return this._currentUser;
  }

  bool userIsLoggedIn() {
    return this.getUser() != null;
  }

  Future<Map> getGoogleTokens() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    return {
      'idToken': googleSignInAuthentication.idToken,
      'accessToken': googleSignInAuthentication.accessToken
    };
  }

  Future<User> returnFirebaseUser(AuthCredential credential) async {
    final UserCredential authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final User user = authResult.user;
    return user;
  }

  Future<User> signInWithGoogle() async {
    if (this.userIsLoggedIn()) return _currentUser;

    try {
      Map googleTokens = await getGoogleTokens();

      // O AuthCredential vem de qualquer AuthProvider (Facebook, Github, Linkedin, etc...)
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleTokens['idToken'],
          accessToken: googleTokens['accessToken']);

      User user = await returnFirebaseUser(credential);
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<User> signInWithFacebook() async {
    if (this.userIsLoggedIn()) return _currentUser;
    try {
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
}
