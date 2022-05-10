import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Projetao3/core/locator.dart';
import 'package:Projetao3/services/login_service.dart';
import 'package:Projetao3/views/components/bottom_navigation_component.dart';
import 'package:Projetao3/views/components/sidebar_component.dart';
import 'package:Projetao3/views/controllers/user_controller.dart';
import 'package:Projetao3/views/providers/user_viewmodel.dart';
import 'package:Projetao3/views/shared/constants.dart';

class BaseScreen extends StatefulWidget {
  final String appBarTitle;
  final Widget body;
  final bool showBottomBar;

  const BaseScreen(
      {Key? key,
      required this.appBarTitle,
      required this.body,
      this.showBottomBar = false})
      : super(key: key);
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  late UserViewModel _userViewModel;
  var _controller = locator<UserController>();

  String? uid;

  @override
  void initState() {
    super.initState();
    _controller.authenticationStateMonitor();
  }

  @override
  Widget build(BuildContext context) {
    _userViewModel = Provider.of<UserViewModel>(context);

    _loginViewHandler();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.COR_MOSTARDA,
        title: Text(
          widget.appBarTitle,
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        child: widget.body,
        padding: EdgeInsets.symmetric(horizontal: Constants.largeSpace),
      ),
      drawer: SidebarComponent(),
      bottomNavigationBar: widget.showBottomBar && _userViewModel.isLoggedIn
          ? BottomNavigationComponent()
          : null,
    );
  }

  _loginViewHandler() {
    // Handles the view depending on user is logged in or not.
    var isLoggedIn = _controller.isLoggedIn();

    isLoggedIn ? _userViewModel.login() : _userViewModel.logout();

    var uid = _controller.uid;
    _userViewModel.setUid(uid);
  }
}
