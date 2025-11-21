class TrackingPoint {
  TrackingPoint({
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    this.locationDescription,
  });

  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final String? locationDescription;
}

