import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeolocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<Position?> getLastPosition() async {
    Position? position = await Geolocator.getLastKnownPosition();
    return position;
  }

  String calculateDistanceInKm(LatLng start, LatLng destine) {
    double distanceInMeters = Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      destine.latitude,
      destine.longitude,
    );
    double convertToKm = distanceInMeters / 1000;

    return convertToKm.abs().toStringAsFixed(1);
  }
}