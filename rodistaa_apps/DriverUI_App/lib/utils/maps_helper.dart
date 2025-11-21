import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Utility for launching external navigation intents with graceful fallbacks.
class MapsHelper {
  MapsHelper._();

  static Future<void> openExternalMaps({
    required double pickupLat,
    required double pickupLng,
    required double dropLat,
    required double dropLng,
  }) async {
    final uris = _buildCandidateUris(
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      dropLat: dropLat,
      dropLng: dropLng,
    );

    for (final uri in uris) {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }
    }
    throw Exception('Unable to launch any navigation intent');
  }

  @visibleForTesting
  static List<Uri> buildUrisForTest({
    required double pickupLat,
    required double pickupLng,
    required double dropLat,
    required double dropLng,
  }) {
    return _buildCandidateUris(
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      dropLat: dropLat,
      dropLng: dropLng,
    );
  }

  static List<Uri> _buildCandidateUris({
    required double pickupLat,
    required double pickupLng,
    required double dropLat,
    required double dropLng,
  }) {
    final origin = '$pickupLat,$pickupLng';
    final destination = '$dropLat,$dropLng';
    if (kIsWeb) {
      return [
        Uri.parse(
          'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&travelmode=driving',
        ),
      ];
    }

    if (Platform.isAndroid) {
      return [
        Uri.parse('google.navigation:q=$destination&mode=d'),
        Uri.parse(
            'comgooglemaps://?saddr=$origin&daddr=$destination&directionsmode=driving'),
        Uri.parse(
            'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination'),
      ];
    }

    if (Platform.isIOS) {
      return [
        Uri.parse(
            'comgooglemaps://?saddr=$origin&daddr=$destination&directionsmode=driving'),
        Uri.parse(
            'http://maps.apple.com/?saddr=$origin&daddr=$destination&dirflg=d'),
        Uri.parse(
            'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination'),
      ];
    }

    return [
      Uri.parse(
          'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination'),
    ];
  }
}
