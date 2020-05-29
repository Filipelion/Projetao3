import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Login Page")),
        body: Center(
            child: 
            Column(
              children: [
                Container(
                  height: 200,
                  child: Center(
                    
                    child: Text("Passa reto boy 1", 
                  style: TextStyle(
                    fontSize: 30
                  )
                  ),)
                ),
                 RaisedButton(
                  child: Text("Fazer login #SQN"),
                  onPressed: () 
                  {
                    Navigator.pushNamed(context, '/register');
                  }
            ),
          ]
        )
      )
    );
  }
}
