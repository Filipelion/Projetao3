import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var _gendersList = ['Feminino', 'Masculino', 'Outro'];
  var _selectGender = 'Feminino';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register Page"),
          backgroundColor: Color(0xFFFFBA00),
        ),
        body: ListView(children: <Widget>[
          Column(children: [
            Container(
                color: Color(0xFFFFBA00),
                height: 100,
                child: Center(
                  child: Text("Cadastre-se, é rapidinho!",
                      strutStyle: StrutStyle(
                        fontFamily: "Roboto",
                      ),
                      style: TextStyle(
                        fontSize: 20,
                      )),
                )),
            Padding(
              padding: const EdgeInsets.all(30),
              child: TextFormField(
                autofocus: true,
                keyboardType: TextInputType.phone,
                style: new TextStyle(color: Colors.grey, fontSize: 20),
                decoration: InputDecoration(
                  labelText: 'Telefone',
                  hintText: '(DDD) 9xxxx-xxxx', // Trocar por variavel de login
                  labelStyle: TextStyle(color: Colors.grey),
                  fillColor: Color(0XFFE8E8E8),
                  filled: true,
                  contentPadding: EdgeInsets.all(15.0),
                  isDense: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Color(0XFFE8E8E8),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Color(0XFFE8E8E8),
                      width: 2.0,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite um telefone';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 50),
              child: TextFormField(
                autofocus: true,
                keyboardType: TextInputType.text,
                style: new TextStyle(color: Colors.black, fontSize: 20),
                decoration: InputDecoration(
                  labelText: 'Nome',
                  hintText: 'Digite seu nome', // Trocar por variavel de login
                  labelStyle: TextStyle(color: Colors.grey),
                  fillColor: Color(0XFFE8E8E8),
                  filled: true,
                  contentPadding: EdgeInsets.all(15.0),
                  isDense: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Color(0XFFE8E8E8),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Color(0XFFE8E8E8),
                      width: 2.0,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite um nome';
                  }
                  return null;
                },
              ),
            ),
            Container(
                height: 50,
                child: Center(
                    child: Text('Gênero',
                        strutStyle: StrutStyle(
                          fontFamily: "Roboto",
                        ),
                        style: TextStyle(
                          fontSize: 20,
                        )))),
            DropdownButton<String>(
              style: TextStyle(color: Colors.black, fontSize: 20),
              items: _gendersList.map((String dropDownSelectedItem) {
                return new DropdownMenuItem<String>(
                  value: dropDownSelectedItem,
                  child: new Text(dropDownSelectedItem),
                );
              }).toList(),
              onChanged: (String newValueSelected) {
                setState(() {
                  this._selectGender = newValueSelected;
                });
              },
              value: _selectGender,
              hint: Text('Selecionar...'),
            ),
            ButtonTheme(
                height: 50,
                minWidth: 300,
                buttonColor: Color(0xFF360E0E),
                child: RaisedButton(
                  onPressed: () =>
                      {Navigator.pushNamed(context, '/registerPhoto')},
                  child: Text(
                    "Continuar",
                    strutStyle: StrutStyle(
                      fontFamily: "Roboto",
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: Color(0xFF360E0E))),
                ))
          ])
        ]));
  }
}
