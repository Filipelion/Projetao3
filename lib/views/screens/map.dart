import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Projetao3/views/screens/base_screen.dart';
import 'package:Projetao3/views/shared/utils.dart';
import '../../custom_widgets/oiaWidgets.dart';
import '../shared/constants.dart';
import '../shared/constants.dart';
import '../../services/firestore_service.dart';
import '../../services/geolocation_service.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GeolocationService _geolocationIntegration = GeolocationService();
  UsuarioController _usuarioController = UsuarioController();

  Future<List<LatLng>> _points;
  String _idWorker;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _idWorker = Utils.getRouteArgs(context);
      _points =
          Future.delayed(Duration(seconds: 5), () => _getLocations(_idWorker));
    });
    print("$_idWorker está presente");

    return BaseScreen(
      appBarTitle: "Localização",
      body: Column(
        children: [
          _buildMap(),
          Constants.MEDIUM_HEIGHT_BOX,
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Voltar",
              style: TextStyle(fontSize: Constants.regularFontSize),
            ),
          )
        ],
      ),
    );
  }

  Future<List<LatLng>> _getLocations(String idWorker) async {
    List<LatLng> points = [];

    // Coordenadas do usuário
    Position myPosition = await _geolocationIntegration.getCurrentLocation();
    LatLng myPoints = LatLng(myPosition.latitude, myPosition.longitude);
    points.add(myPoints);

    // Coordenadas do prestador de servico
    Position workerPosition =
        await _usuarioController.getUsuarioLocation(idWorker);
    LatLng workerPoints =
        LatLng(workerPosition.latitude, workerPosition.longitude);
    points.add(workerPoints);

    print("Points: $points");

    return points;
  }

  _buildMap() {
    return FutureBuilder(
        future: _points,
        builder: (context, snapshot) {
          if (snapshot.hasData ||
              snapshot.connectionState == ConnectionState.done) {
            List<LatLng> points = snapshot.data;
            print(points);
            return Column(
              children: [
                DisplayMap(points: points),
                Constants.MEDIUM_HEIGHT_BOX,
                _buildDistanceText(points[0], points[1]),
              ],
            );
          }
          return Column(
            children: [
              Constants.LARGE_HEIGHT_BOX,
              Center(child: CircularProgressIndicator()),
            ],
          );
        });
  }

  _buildDistanceText(LatLng start, LatLng destine) {
    return Text(
      "Você e o prestador estão à ${this._geolocationIntegration.calculateDistanceInKm(start, destine)}km de distância",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: Constants.regularFontSize,
      ),
    );
  }
}

class DisplayMap extends StatefulWidget {
  final List<LatLng> points;
  const DisplayMap({Key key, this.points}) : super(key: key);
  @override
  _DisplayMapState createState() => _DisplayMapState();
}

class _DisplayMapState extends State<DisplayMap> {
  Completer<GoogleMapController> _mapController = Completer();
  LatLng _myLocation, _destineLocation;

  Set<Marker> _markers = HashSet<Marker>();
  int _markerIdCount = 1;
  List<String> _markersLabel = ['Onde estou', 'Prestador de Serviço'];

  CameraPosition _initialPosition;

  CameraPosition _destineCamera;

  _moveCameraToDestine() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_destineCamera));
  }

  _setMarkers(LatLng point, String title) {
    String markerIdValue = "marker_id_$_markerIdCount";
    _markerIdCount++;

    setState(() {
      print(
          "Marker || Latitude: ${point.latitude} | Longitude: ${point.longitude}");
      _markers.add(
        Marker(
          markerId: MarkerId(markerIdValue),
          position: point,
          infoWindow: InfoWindow(title: title),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _myLocation = widget.points[0];
      _destineLocation = widget.points[1];
      for (var item in widget.points) {
        int index = _markerIdCount - 1;
        String label = _markersLabel[index];
        _setMarkers(item, label);
      }
    });

    _initialPosition = CameraPosition(
      target: _myLocation,
      zoom: 10,
    );

    _destineCamera = CameraPosition(
      bearing: 192.8334901395799,
      target: _destineLocation,
      tilt: 59.440717697143555,
      zoom: 15,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: Utils.screenDimensions(context).size.height * 0.4,
          child: GoogleMap(
            mapType: MapType.normal,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            initialCameraPosition: _initialPosition,
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
              Future.delayed(
                  Duration(seconds: 5), () => _moveCameraToDestine());
            },
          ),
        ),
      ],
    );
  }
}
