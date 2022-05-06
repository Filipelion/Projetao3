import 'package:flutter/material.dart';

class ScreenArguments {
  final String phone;
  final String name;
  final String gender;

  ScreenArguments(this.phone, this.name, this.gender);
}



class RegisterPhotoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("RegisterPhoto Page"),
        backgroundColor: Color(0xFFFFBA00)       
        ),
        body: Center(
            child: 
            Column(
              children: [
                Container(
                  height: 200,
                  child: Center(
                    
                    child: Text("Passa reto boy 3", 
                  style: TextStyle(
                    fontSize: 30
                  )
                  ),)
                ),
                 RaisedButton(
                  child: Text("Passar reto"),
                  onPressed: () 
                  {
                    //Navigator.pushNamed(context, '/login');
                  }
            ),
          ]
        )
      )
    );
  }
}
