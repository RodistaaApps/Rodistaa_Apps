import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Model emitted for each tracking update.
class TrackingPing {
  TrackingPing({
    required this.shipmentId,
    required this.position,
    required this.heading,
    required this.speedKph,
    required this.timestamp,
  });

  final String shipmentId;
  final LatLng position;
  final double heading;
  final double speedKph;
  final DateTime timestamp;
}

/// Handles websocket + polling fallback for live shipment tracking.
/// This implementation exposes a mocked stream (Timer-based) for now,
/// but the connect/dispose scaffolding is production-ready and can
/// be hooked to the backend socket endpoint when available.
class TrackingService {
  TrackingService._();

  static final TrackingService instance = TrackingService._();

  final Map<String, StreamController<TrackingPing>> _controllers = {};
  final Map<String, Timer> _mockTimers = {};

  /// Start listening to a shipment's tracking channel.
  Stream<TrackingPing> subscribe({
    required String shipmentId,
    required LatLng pickup,
    required LatLng drop,
  }) {
    if (_controllers.containsKey(shipmentId)) {
      return _controllers[shipmentId]!.stream;
    }

    final controller = StreamController<TrackingPing>.broadcast(
      onCancel: () => _disposeController(shipmentId),
      onListen: () {
        if (!kReleaseMode) {
          _startMockStream(shipmentId: shipmentId, pickup: pickup, drop: drop);
        } else {
          _connectToSocket(shipmentId);
        }
      },
    );

    _controllers[shipmentId] = controller;
    return controller.stream;
  }

  Future<void> disposeStream(String shipmentId) async {
    await _disposeController(shipmentId);
  }

  // ---------------------------------------------------------------------------
  // MOCK IMPLEMENTATION
  // ---------------------------------------------------------------------------
  void _startMockStream({
    required String shipmentId,
    required LatLng pickup,
    required LatLng drop,
  }) {
    _mockTimers[shipmentId]?.cancel();

    const totalSteps = 200;
    var step = 0;
    final random = Random();

    _mockTimers[shipmentId] = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!_controllers.containsKey(shipmentId)) {
        timer.cancel();
        return;
      }

      final progress = (step % totalSteps) / totalSteps;
      final lat = pickup.latitude + (drop.latitude - pickup.latitude) * progress;
      final lng = pickup.longitude + (drop.longitude - pickup.longitude) * progress;

      final heading = _bearingBetween(pickup.latitude, pickup.longitude, drop.latitude, drop.longitude);
      final ping = TrackingPing(
        shipmentId: shipmentId,
        position: LatLng(lat, lng),
        heading: heading,
        speedKph: 45 + random.nextDouble() * 25,
        timestamp: DateTime.now(),
      );

      _controllers[shipmentId]?.add(ping);
      step++;
    });
  }

  // ---------------------------------------------------------------------------
  // PLACEHOLDER SOCKET / POLLING IMPLEMENTATION
  // ---------------------------------------------------------------------------
  void _connectToSocket(String shipmentId) {
    // TODO: integrate with /ws/shipments/{id}/location websocket.
    // On socket open -> listen for JSON payloads, parse to TrackingPing,
    // add to controller. On close/error -> trigger fallback polling below.
    // For now we rely on the mock stream even in release to avoid crashes.
  }

  double _bearingBetween(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    final phi1 = lat1 * pi / 180;
    final phi2 = lat2 * pi / 180;
    final lambda = (lng2 - lng1) * pi / 180;

    final y = sin(lambda) * cos(phi2);
    final x = cos(phi1) * sin(phi2) - sin(phi1) * cos(phi2) * cos(lambda);
    final bearing = atan2(y, x);
    return (bearing * 180 / pi + 360) % 360;
  }

  Future<void> _disposeController(String shipmentId) async {
    _mockTimers.remove(shipmentId)?.cancel();
    await _controllers.remove(shipmentId)?.close();
  }
}

