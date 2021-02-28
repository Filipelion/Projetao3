import 'dart:async';
import 'package:Projetao3/infrastructure/loginAuth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './custom_widgets/oiaWidgets.dart';
import './infrastructure/constants.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _mapController = Completer();
  LoginAuth _auth = Authentication.loginAuth;
  String _myUID;

  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 10,
  );

  static final CameraPosition _destineCamera = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 12,
  );

  _goToLake() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_destineCamera));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth.authChangeListener();
    if (_auth.userIsLoggedIn()) {
      _myUID = _auth.getUid();
    }
  }

  @override
  Widget build(BuildContext context) {
    return OiaScaffold(
        appBarTitle: "Localização",
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _initialPosition,
                onMapCreated: (GoogleMapController controller) {
                  _mapController.complete(controller);
                },
              ),
            ),
            Constants.MEDIUM_HEIGHT_BOX,
            FlatButton(onPressed: _goToLake, child: Text("Testando"))
          ],
        ));
  }
}
