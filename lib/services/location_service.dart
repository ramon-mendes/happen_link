import 'dart:async';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:happen_link/apimodels/gpslink.dart';
import 'package:happen_link/services/api.dart';
import 'package:location/location.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;

class LocationService {
  static List<GPSLink> _gpslinklist;

  static Future<void> start() async {
    await AndroidAlarmManager.initialize();

    _loadGPSLinkLoop();

    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.enableBackgroundMode(enable: true);

    location.onLocationChanged.listen((LocationData currentLocation) async {
      if (await API.isLogged()) {
        if (_gpslinklist != null) {
          _checkEnterArea(currentLocation.latitude, currentLocation.longitude);
        }
        _checkLeftArea(currentLocation.latitude, currentLocation.longitude);
      }
    });
  }

  static List<String> _enteredGPSLinkIds = [];
  static List<GPSLink> _enteredGPSLink = [];

  static void _checkEnterArea(double curLat, double curLng) {
    for (var gpsLink in _gpslinklist) {
      double distMeters =
          mp.SphericalUtil.computeDistanceBetween(mp.LatLng(gpsLink.lat, gpsLink.lng), mp.LatLng(curLat, curLng));
      if (distMeters < gpsLink.radius && !_enteredGPSLinkIds.contains(gpsLink.id)) {
        _enterArea(gpsLink);
      }
    }
  }

  static void _checkLeftArea(double curLat, double curLng) {
    for (var gpsLink in _enteredGPSLink) {
      double distMeters =
          mp.SphericalUtil.computeDistanceBetween(mp.LatLng(gpsLink.lat, gpsLink.lng), mp.LatLng(curLat, curLng));
      if (distMeters > gpsLink.radius) {
        _enteredGPSLink.remove(gpsLink);
        _enteredGPSLinkIds.remove(gpsLink.id);
      }
    }
  }

  static void _enterArea(GPSLink gpsLink) {
    _enteredGPSLink.add(gpsLink);
    _enteredGPSLinkIds.add(gpsLink.id);
  }

  static Future<void> _loadGPSLinkLoop() async {
    await Future.delayed(Duration(seconds: 3));

    API api = API();
    while (true) {
      var list = await api.gpslinkListNoError();
      if (list != null) {
        _gpslinklist = list;
      }
      await Future.delayed(Duration(seconds: 30));
    }
  }
}
