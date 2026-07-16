import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationData {
  final double latitude;
  final double longitude;
  final double accuracy;
  final double heading;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.heading,
  });
}

class LocationService {
  LocationService._();

  static Future<LocationData?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled.');
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permission denied.');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('Location permission denied forever.');
        return null;
      }

      // Try to get the last known position first as a fast fallback
      Position? position;
      try {
        position = await Geolocator.getLastKnownPosition();
      } catch (e) {
        debugPrint('Failed to get last known position: $e');
      }

      // Fetch current position with a more generous timeout
      try {
        final currentPosition = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 15),
          ),
        );
        position = currentPosition;
      } catch (e) {
        debugPrint('Failed to get current position: $e');
      }

      if (position == null) {
        return null;
      }

      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        heading: position.heading,
      );
    } catch (e) {
      debugPrint('Error in LocationService.getCurrentLocation: $e');
      return null;
    }
  }
}
