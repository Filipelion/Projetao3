import 'package:flutter/material.dart';
import './custom_widgets/oiaWidgets.dart';
import './infrastructure/loginAuth.dart';
import './infrastructure/constants.dart';
import 'infrastructure/constants.dart';

class ServiceRegistration extends StatefulWidget {
  @override
  _ServiceRegistrationState createState() => _ServiceRegistrationState();
}

class _ServiceRegistrationState extends State<ServiceRegistration> {
  LoginAuth auth = Authentication.loginAuth;
  List<String> servicosUsuario = ["Teste", "Dois"];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  String textoEmBusca;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth.authChangeListener();
  }

  @override
  Widget build(BuildContext context) {
    return OiaScaffold(
      appBarTitle: auth.getUserProfileName(),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: Constants.mediumSpace),
          child: Column(
            children: <Widget>[
              Text(
                "Quais serviços você faz?",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Constants.regularFontSize),
              ),
              Constants.MEDIUM_HEIGHT_BOX,
              Form(
                key: _formKey,
                child: Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "Pesquisar serviço...",
                          border: OutlineInputBorder(),
                          fillColor: Constants.COR_MOSTARDA,
                          isDense: true,
                        ),
                        onChanged: (texto) {
                          setState(() {
                            this.textoEmBusca = texto;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            _controller.clear();
                            servicosUsuario.add(this.textoEmBusca);
                          });
                        }
                      },
                    )
                  ],
                ),
              ),
              Constants.SMALL_HEIGHT_BOX,
              // IconButton(icon: , onPressed: null)
              Flexible(
                child: ListView.builder(
                  physics: PageScrollPhysics(),
                  reverse: true,
                  itemCount: servicosUsuario.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(servicosUsuario[index]),
                            // contentPadding: EdgeInsets.symmetric(vertical: Constants.smallSpace),
                            tileColor: Colors.grey[100],
                            dense: true,
                          ),
                          Divider()
                        ],
                      ),
                    );
                  },
                ),
              ),
              OiaLargeButton(
                title: "Continuar",
                onPressed: _goToProfile,
              )
            ],
          ),
        ),
      ),
    );
  }

  _goToProfile() {
    Navigator.pushNamed(context, '/profile', arguments: servicosUsuario);
  }
}
