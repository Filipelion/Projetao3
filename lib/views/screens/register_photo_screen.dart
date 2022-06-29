import 'package:flutter/material.dart';

// TODO: finish this screen
class RegisterPhotoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("RegisterPhoto Page"),
            backgroundColor: Color(0xFFFFBA00)),
        body: Center(
            child: Column(children: [
          Container(
              height: 200,
              child: Center(
                child: Text("....", style: TextStyle(fontSize: 30)),
              )),
          ElevatedButton(
              child: Text("...."),
              onPressed: () {
                //Navigator.pushNamed(context, '/login');
              }),
        ])));
  }
}
