import 'package:flutter/material.dart';
import 'package:Projetao3/core/locator.dart';
import 'package:Projetao3/custom_widgets/oiaWidgets.dart';
import 'package:Projetao3/services/login_service.dart';
import 'package:Projetao3/views/components/bottom_navigation_component.dart';
import 'package:Projetao3/views/components/sidebar_component.dart';
import 'package:Projetao3/views/shared/constants.dart';

class BaseScreen extends StatefulWidget {
  final String appBarTitle;
  final Widget body;
  final bool showBottomBar;

  const BaseScreen(
      {Key key, this.appBarTitle, this.body, this.showBottomBar = false})
      : super(key: key);
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  LoginService _loginService = locator<LoginService>();
  bool _isLoggedIn = false;
  String uid;

  @override
  void initState() {
    super.initState();
    _loginService.authChangeListener();
    if (_loginService.userIsLoggedIn()) {
      setState(() {
        _isLoggedIn = true;
        uid = _loginService.getUid();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.COR_MOSTARDA,
        title: Text(
          widget.appBarTitle ?? "Oia",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        child: widget.body,
        padding: EdgeInsets.symmetric(horizontal: Constants.largeSpace),
      ),
      drawer: SidebarComponent(),
      bottomNavigationBar: widget.showBottomBar && _isLoggedIn
          ? BottomNavigationComponent()
          : null,
    );
  }
}
