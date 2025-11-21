import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/shipment.dart';
import '../services/mock_shipments_service.dart';
import '../services/tracking_service.dart';
import '../constants/colors.dart';

class LiveTrackProvider extends ChangeNotifier {
  LiveTrackProvider({TrackingService? trackingService})
      : _trackingService = trackingService ?? TrackingService.instance;

  final TrackingService _trackingService;
  final _shipmentsService = MockShipmentsService.instance;

  Shipment? shipment;
  bool isLoading = true;
  bool hasError = false;
  String? errorMessage;

  bool isFollowing = true;
  bool isOffline = false;

  LatLng? driverPosition;
  double driverHeading = 0;
  DateTime? lastPing;

  LatLng? pickupLatLng;
  LatLng? dropLatLng;

  List<LatLng> completedRoute = [];
  List<LatLng> remainingRoute = [];
  bool isPerformingAction = false;

  StreamSubscription<TrackingPing>? _trackingSubscription;
  Timer? _staleTimer;

  Future<void> initialize(String shipmentId) async {
    try {
      isLoading = true;
      notifyListeners();

      shipment = await _shipmentsService.fetchShipmentById(shipmentId);
      pickupLatLng = _coordsForAddress(shipment!.origin);
      dropLatLng = _coordsForAddress(shipment!.destination);

      _startTracking(shipmentId);
      _startStaleTimer();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      hasError = true;
      errorMessage = 'Unable to load shipment';
      isLoading = false;
      notifyListeners();
    }
  }

  LiveContact get sender => LiveContact(
        label: 'Sender',
        name: 'Sender Ops',
        phone: '+91 90090 00001',
        city: shipment?.origin ?? '',
      );

  LiveContact get receiver => LiveContact(
        label: 'Receiver',
        name: 'Receiver Ops',
        phone: '+91 90090 00002',
        city: shipment?.destination ?? '',
      );

  String get statusLabel {
    final stage = shipment?.currentStage;
    if (stage == null) return 'Completed';
    switch (stage.key) {
      case 'loaded':
        return 'Loading';
      case 'unloaded':
        return 'Unloaded';
      default:
        return 'In Transit';
    }
  }

  Color get statusColor {
    switch (statusLabel) {
      case 'Loading':
        return const Color(0xFFF57C00);
      case 'Unloaded':
        return const Color(0xFF1E88E5);
      case 'Completed':
        return const Color(0xFF2E7D32);
      default:
        return AppColors.primaryRed;
    }
  }

  double get advancePaid {
    final total = shipment?.estimatedFuelCost ?? 0;
    return (total * 0.3).clamp(0, total);
  }

  double get pendingBalance {
    final total = shipment?.estimatedFuelCost ?? 0;
    return (total - advancePaid).clamp(0, total);
  }

  bool get canMarkLoaded =>
      _stageCompleted('arrived_pickup') && !_stageCompleted('loaded');

  bool get canConfirmUnloaded =>
      _stageCompleted('arrived_drop') && !_stageCompleted('unloaded');

  bool get canRequestPayment =>
      _stageCompleted('unloaded') && !_stageCompleted('advance_payment');

  bool get canRecordCash =>
      _stageCompleted('advance_payment') && !_stageCompleted('payment_complete');

  Future<bool> markLoaded() => _completeStage('loaded');

  Future<bool> confirmUnloaded() => _completeStage('unloaded');

  Future<bool> requestPayment() => _completeStage('advance_payment');

  Future<bool> recordCash() => _completeStage('payment_complete');

  void toggleFollow() {
    isFollowing = !isFollowing;
    notifyListeners();
  }

  void stopFollowing() {
    if (!isFollowing) return;
    isFollowing = false;
    notifyListeners();
  }

  void _startTracking(String shipmentId) {
    if (pickupLatLng == null || dropLatLng == null) return;

    _trackingSubscription = _trackingService
        .subscribe(
          shipmentId: shipmentId,
          pickup: pickupLatLng!,
          drop: dropLatLng!,
        )
        .listen(_handlePing);
  }

  void _handlePing(TrackingPing ping) {
    driverPosition = ping.position;
    driverHeading = ping.heading;
    lastPing = ping.timestamp;
    isOffline = false;

    _updateRouteSegments();
    notifyListeners();
  }

  void _updateRouteSegments() {
    if (pickupLatLng == null || dropLatLng == null || driverPosition == null) {
      return;
    }

    completedRoute = [pickupLatLng!, driverPosition!];
    remainingRoute = [driverPosition!, dropLatLng!];
  }

  void _startStaleTimer() {
    _staleTimer?.cancel();
    _staleTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (lastPing == null) return;
      final diff = DateTime.now().difference(lastPing!);
      final offline = diff.inSeconds > 30;
      if (offline != isOffline) {
        isOffline = offline;
        notifyListeners();
      }
    });
  }

  LatLng _coordsForAddress(String address) {
    const lookup = <String, LatLng>{
      'Bangalore': LatLng(12.9716, 77.5946),
      'Chennai': LatLng(13.0827, 80.2707),
      'Hyderabad': LatLng(17.3850, 78.4867),
      'Pune': LatLng(18.5204, 73.8567),
      'Mumbai': LatLng(19.0760, 72.8777),
      'Delhi': LatLng(28.6139, 77.2090),
      'Coimbatore': LatLng(11.0168, 76.9558),
      'Lucknow': LatLng(26.8467, 80.9462),
      'Nagpur': LatLng(21.1458, 79.0882),
      'Jaipur': LatLng(26.9124, 75.7873),
    };

    for (final entry in lookup.entries) {
      if (address.toLowerCase().contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }

    // fallback: slight randomization around Bangalore to avoid overlapping markers.
    final random = Random(address.hashCode);
    return LatLng(
      12.97 + random.nextDouble() * 0.05,
      77.59 + random.nextDouble() * 0.05,
    );
  }

  @override
  void dispose() {
    _trackingSubscription?.cancel();
    _staleTimer?.cancel();
    super.dispose();
  }

  bool _stageCompleted(String key) {
    final stage = shipment?.timelineStages
        .firstWhere((s) => s.key == key, orElse: () => const ShipmentTimelineStage(key: '', label: '', completed: false));
    if (stage == null || stage.key.isEmpty) return false;
    return stage.completed;
  }

  Future<bool> _completeStage(String key) async {
    if (shipment == null || _stageCompleted(key)) return false;

    isPerformingAction = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));

    final stages = List<ShipmentTimelineStage>.from(shipment!.timelineStages);
    final index = stages.indexWhere((s) => s.key == key);
    if (index == -1) {
      isPerformingAction = false;
      notifyListeners();
      return false;
    }

    final old = stages[index];
    stages[index] = ShipmentTimelineStage(
      key: old.key,
      label: old.label,
      completed: true,
      timestamp: DateTime.now(),
    );

    shipment = _cloneShipment(timelineStages: stages);
    isPerformingAction = false;
    notifyListeners();
    return true;
  }

  Shipment _cloneShipment({List<ShipmentTimelineStage>? timelineStages}) {
    final source = shipment!;
    return Shipment(
      id: source.id,
      origin: source.origin,
      destination: source.destination,
      category: source.category,
      weightTons: source.weightTons,
      bodyType: source.bodyType,
      tyres: source.tyres,
      ftlOrPtl: source.ftlOrPtl,
      timerEndsAt: source.timerEndsAt,
      driver: source.driver,
      status: source.status,
      timelineStages: timelineStages ?? source.timelineStages,
      lastUpdated: DateTime.now(),
      distanceKm: source.distanceKm,
      estimatedFuelCost: source.estimatedFuelCost,
      tollEstimate: source.tollEstimate,
    );
  }
}

class LiveContact {
  const LiveContact({
    required this.label,
    required this.name,
    required this.phone,
    required this.city,
  });

  final String label;
  final String name;
  final String phone;
  final String city;
}

