import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


class LocationService {
  Future<Position?> getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<String> getAddress(double lat, double lng) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(lat, lng);
      final place = placemarks.first;
      return "${place.street}, ${place.locality}";
    } catch (e) {
      return "Lokasi tidak diketahui";
    }
  }
}