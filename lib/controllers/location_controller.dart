import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class LocationController extends GetxController {
  static var instance = Get.find<LocationController>();

  late List<Placemark> _placeMark = <Placemark>[].obs;
   List<Placemark> get placeMark => _placeMark;


  late Position _currentPosition;
  Position? get currentPosition => _currentPosition;


  Future<void> getUserLocationFromLatLong(Position position) async {
    _placeMark = await placemarkFromCoordinates(position.latitude, position.longitude);
  }

  Future<Position?> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    _currentPosition = await Geolocator.getCurrentPosition();
    getUserLocationFromLatLong(_currentPosition);


    return _currentPosition;
  }
}
