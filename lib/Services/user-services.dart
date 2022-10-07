import 'dart:async';
import 'dart:io';
import 'package:agriteck/Services/sharedPrefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<Position> _determinePosition() async {
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
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best);
}

//method that fires when the user prefers current location
Future<bool> preferCurrentLoc() async {
  try {
    final _locaData = await _determinePosition();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(_locaData.latitude, _locaData.longitude);
    Placemark place = placemarks[0];
    Map<String, dynamic> _userAddress = {
      "location": {"lat": _locaData.latitude, "long": _locaData.longitude},
      "locationName": place.name,
      "street": place.street,
      "country": place.country,
      "locality": place.locality,
      "region": place.administrativeArea,
      "countyCode": place.isoCountryCode
    };
    SharedPrefs.savePositionInfo(_userAddress);
    return true;
  } catch (e) {
    return false;
  }
}
