abstract class ILoginController {
  Future<bool> googlSignin();
  Future<bool> facebookSignin();
}
