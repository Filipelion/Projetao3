import 'package:flutter/material.dart';

class ServiceRegistration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFFFBA00),
            title: Container(
              child: Row(
                children: <Widget>[
                  Center(
                    child: Text(
                      "Nome do usuário",
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
          ),
          body: Container(
            margin: EdgeInsets.all(30),
            child: Column(
              children: <Widget>[
                Text("Quais serviços você faz?"),
                TextField(
                  decoration: InputDecoration(hintText: "Pesquisar serviço..."),
                ),
                Container(
                  width: 100,
                  height: 100,
                  child: ListView(
                    children: <Widget>[],
                  ),
                ),
                RaisedButton(
                    color: Color(0xFF360E0E),
                    child: Text(
                      "Continuar",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {}),
              ],
            ),
          ),
        ));
  }
}
