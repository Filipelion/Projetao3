import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Register Page")),
        body: Center(
            child: 
            Column(
              children: [
                Container(
                  height: 200,
                  child: Center(
                    
                    child: Text("Passa reto boy 2", 
                  style: TextStyle(
                    fontSize: 30
                  )
                  ),)
                ),
                 RaisedButton(
                  child: Text("Passar reto"),
                  onPressed: () 
                  {
                    Navigator.pushNamed(context, '/registerPhoto');
                  }
            ),
          ]
        )
      )
    );
  }
}
