// RODISTAA THEME mock shipments service.
// TODO: Swap with REST client once backend shipments API ships.

import 'dart:async';

import '../models/shipment.dart';

class MockShipmentsService {
  MockShipmentsService._();

  static final MockShipmentsService instance = MockShipmentsService._();

  final List<Shipment> _shipments = _buildSeedData();

  Future<List<Shipment>> fetchShipments() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _shipments;
  }

  Future<Shipment> fetchShipmentById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _shipments.firstWhere((shipment) => shipment.id == id);
  }

  static List<Shipment> _buildSeedData() {
    final now = DateTime.now();
    return [
      _ongoingShipment(
        id: 'LOAD #BK101',
        origin: 'Bangalore',
        destination: 'Chennai',
        category: 'Electronics (crated)',
        weight: 7.8,
        body: 'Closed',
        tyres: 12,
        ftlOrPtl: 'FTL',
        timer: now.add(const Duration(hours: 6)),
        driver: const ShipmentDriver(
          name: 'Raju Kumar',
          phone: '+91 98765 43210',
          truckNumber: 'KA01 AB 4455',
          tyreCount: 12,
        ),
        distanceKm: 350,
        fuel: 18500,
        toll: 3200,
        completedStages: 3,
      ),
      _ongoingShipment(
        id: 'LOAD #BK102',
        origin: 'Hyderabad',
        destination: 'Pune',
        category: 'FMCG dry goods',
        weight: 4.5,
        body: 'Open',
        tyres: 10,
        ftlOrPtl: 'PTL',
        timer: now.add(const Duration(hours: 3, minutes: 20)),
        driver: const ShipmentDriver(
          name: 'Suresh Patil',
          phone: '+91 98989 22334',
          truckNumber: 'TS09 CC 2233',
          tyreCount: 10,
        ),
        distanceKm: 570,
        fuel: 20500,
        toll: 4100,
        completedStages: 4,
      ),
      _ongoingShipment(
        id: 'LOAD #BK103',
        origin: 'Mumbai',
        destination: 'Delhi',
        category: 'Automotive parts',
        weight: 8.9,
        body: 'Closed',
        tyres: 14,
        ftlOrPtl: 'FTL',
        timer: now.add(const Duration(hours: 11)),
        driver: const ShipmentDriver(
          name: 'Irfan Shaikh',
          phone: '+91 94444 11223',
          truckNumber: 'MH02 DE 7788',
          tyreCount: 14,
        ),
        distanceKm: 1420,
        fuel: 61200,
        toll: 8900,
        completedStages: 2,
      ),
      _completedShipment(
        id: 'LOAD #BK201',
        origin: 'Chennai',
        destination: 'Coimbatore',
        category: 'Textiles',
        weight: 3.1,
        body: 'Open',
        tyres: 6,
        ftlOrPtl: 'PTL',
        driver: const ShipmentDriver(
          name: 'Senthil Kumar',
          phone: '+91 90000 77889',
          truckNumber: 'TN05 HG 6677',
          tyreCount: 6,
        ),
        distanceKm: 510,
        fuel: 11800,
        toll: 1800,
      ),
      _completedShipment(
        id: 'LOAD #BK202',
        origin: 'Delhi',
        destination: 'Lucknow',
        category: 'Agro supplies',
        weight: 6.0,
        body: 'Closed',
        tyres: 10,
        ftlOrPtl: 'FTL',
        driver: const ShipmentDriver(
          name: 'Meera Sharma',
          phone: '+91 93333 45678',
          truckNumber: 'DL10 ZX 3412',
          tyreCount: 10,
        ),
        distanceKm: 520,
        fuel: 19800,
        toll: 2500,
      ),
      _completedShipment(
        id: 'LOAD #BK203',
        origin: 'Nagpur',
        destination: 'Jaipur',
        category: 'Industrial machinery',
        weight: 9.2,
        body: 'Closed',
        tyres: 12,
        ftlOrPtl: 'FTL',
        driver: const ShipmentDriver(
          name: 'Devendra Singh',
          phone: '+91 95555 65432',
          truckNumber: 'MH31 XX 6633',
          tyreCount: 12,
        ),
        distanceKm: 930,
        fuel: 34200,
        toll: 6200,
      ),
    ];
  }

  static Shipment _ongoingShipment({
    required String id,
    required String origin,
    required String destination,
    required String category,
    required double weight,
    required String body,
    required int tyres,
    required String ftlOrPtl,
    required DateTime timer,
    required ShipmentDriver driver,
    required double distanceKm,
    required double fuel,
    required double toll,
    required int completedStages,
  }) {
    return Shipment(
      id: id,
      origin: origin,
      destination: destination,
      category: category,
      weightTons: weight,
      bodyType: body,
      tyres: tyres,
      ftlOrPtl: ftlOrPtl,
      timerEndsAt: timer,
      driver: driver,
      status: ShipmentStatus.ongoing,
      timelineStages: _buildTimeline(completedStages),
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 5)),
      distanceKm: distanceKm,
      estimatedFuelCost: fuel,
      tollEstimate: toll,
    );
  }

  static Shipment _completedShipment({
    required String id,
    required String origin,
    required String destination,
    required String category,
    required double weight,
    required String body,
    required int tyres,
    required String ftlOrPtl,
    required ShipmentDriver driver,
    required double distanceKm,
    required double fuel,
    required double toll,
  }) {
    return Shipment(
      id: id,
      origin: origin,
      destination: destination,
      category: category,
      weightTons: weight,
      bodyType: body,
      tyres: tyres,
      ftlOrPtl: ftlOrPtl,
      timerEndsAt: null,
      driver: driver,
      status: ShipmentStatus.completed,
      timelineStages: _buildTimeline(9),
      lastUpdated: DateTime.now().subtract(const Duration(hours: 6)),
      distanceKm: distanceKm,
      estimatedFuelCost: fuel,
      tollEstimate: toll,
    );
  }

  static List<ShipmentTimelineStage> _buildTimeline(int completedCount) {
    const keys = [
      'assigned',
      'driver_en_route',
      'arrived_pickup',
      'loaded',
      'toll_stop',
      'arrived_drop',
      'unloaded',
      'advance_payment',
      'payment_complete',
    ];
    const labels = [
      'Assigned',
      'Driver en route',
      'Arrived at pickup',
      'Loaded',
      'Toll/stop',
      'Arrived at drop',
      'Unloaded',
      'Advance payment',
      'Payment complete',
    ];

    return List.generate(keys.length, (index) {
      final completed = index < completedCount;
      return ShipmentTimelineStage(
        key: keys[index],
        label: labels[index],
        completed: completed,
        timestamp: completed ? DateTime.now().subtract(Duration(hours: keys.length - index)) : null,
      );
    });
  }
}

