import 'package:Projetao3/core/interfaces/controllers/ilogin_controller.dart';
import 'package:Projetao3/core/locator.dart';
import 'package:Projetao3/services/login_service.dart';

class LoginController implements ILoginController {
  late LoginService _service;

  LoginController() {
    this._service = locator<LoginService>();
    _service.authChangeListener();
  }

  @override
  Future<bool> facebookSignin() async {
    var user = await _service.signInWithFacebook();
    return user != null;
  }

  @override
  Future<bool> googlSignin() async {
    var user = await _service.signInWithGoogle();
    return user != null;
  }
}
