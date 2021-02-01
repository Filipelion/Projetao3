import 'package:flutter/material.dart';
import 'custom_widgets/oiaWidgets.dart';
import 'infrastructure/constants.dart';
import 'infrastructure/loginAuth.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  LoginAuth auth;
  bool isLoggedIn = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth = Authentication.loginAuth;
    auth.authChangeListener();
    if (auth.userIsLoggedIn()) {
      setState(() {
        isLoggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return OiaScaffold(
      appBarTitle: "Perfil",
      body: isLoggedIn
          ? _buildBody()
          : Center(child: CircularProgressIndicator()),
      showBottomBar: true,
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Constants.LARGE_HEIGHT_BOX,
          Center(
            child: OiaRoundedImage(
              width: 120,
              height: 120,
              borderWidth: 5,
              image: NetworkImage(auth.getUserProfilePhoto()),
            ),
          )
        ],
      ),
    );
  }
}
