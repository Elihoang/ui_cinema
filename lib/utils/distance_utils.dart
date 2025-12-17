import 'package:geolocator/geolocator.dart';

/// Utility functions for calculating distance between locations

/// Calculate distance between two coordinates and return in kilometers
/// Returns null if either latitude or longitude is null
double? calculateDistance({
  required Position? userPosition,
  required double? targetLatitude,
  required double? targetLongitude,
}) {
  if (userPosition == null ||
      targetLatitude == null ||
      targetLongitude == null) {
    return null;
  }

  double distanceInMeters = Geolocator.distanceBetween(
    userPosition.latitude,
    userPosition.longitude,
    targetLatitude,
    targetLongitude,
  );

  return distanceInMeters / 1000; // Convert to kilometers
}

/// Format distance to string with 'km' suffix
/// Returns '--' if distance cannot be calculated
String formatDistance({
  required Position? userPosition,
  required double? targetLatitude,
  required double? targetLongitude,
  int decimalPlaces = 1,
}) {
  final distance = calculateDistance(
    userPosition: userPosition,
    targetLatitude: targetLatitude,
    targetLongitude: targetLongitude,
  );

  if (distance == null) {
    return '--';
  }

  return '${distance.toStringAsFixed(decimalPlaces)}km';
}

/// Get distance string without 'km' suffix
/// Returns null if distance cannot be calculated
String? getDistanceValue({
  required Position? userPosition,
  required double? targetLatitude,
  required double? targetLongitude,
  int decimalPlaces = 1,
}) {
  final distance = calculateDistance(
    userPosition: userPosition,
    targetLatitude: targetLatitude,
    targetLongitude: targetLongitude,
  );

  if (distance == null) {
    return null;
  }

  return distance.toStringAsFixed(decimalPlaces);
}
