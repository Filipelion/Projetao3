import 'package:flutter/material.dart';
import 'package:oia/serviceRegistragion.dart';
import 'serviceRegistragion.dart';



class PerfilShift extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ôia',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFFFFBA00)),
      body: Center(
        child: ContainerButtons(),
      ),
    );
  }
}

class ContainerButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      child: Column(
        children: <Widget>[
          Text("O que você deseja?",
              strutStyle: StrutStyle(
                fontFamily: "Roboto",
              )),
          RaisedButton(
            color: Color(0xFFFFBA00),
            child: Text(
              "Encontrar profissionais",
              strutStyle: StrutStyle(fontFamily: "Roboto"),
            ),
            onPressed: () {},
          ),
          RaisedButton(
            color: Color(0xFFFFBA00),
            child: Text(
              "Prestar serviços",
              strutStyle: StrutStyle(fontFamily: "Roboto"),
            ),
            onPressed: () {
              goToServiceRegistration(context);
            },
          )
        ],
      ),
    );
  }
}

void goToServiceRegistration(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => ServiceRegistration()));
}
