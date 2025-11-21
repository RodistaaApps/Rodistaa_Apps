import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/shipment_card_final.dart';

enum ShipmentStatusFilter { ongoing, completed, all }

class AdvancedShipmentFilters {
  const AdvancedShipmentFilters({
    this.dateRange,
    this.loadType,
    this.unpaidOnly = false,
    this.radiusKm,
  });

  final DateTimeRange? dateRange;
  final String? loadType;
  final bool unpaidOnly;
  final double? radiusKm;

  AdvancedShipmentFilters copyWith({
    DateTimeRange? dateRange,
    String? loadType,
    bool? unpaidOnly,
    double? radiusKm,
  }) {
    return AdvancedShipmentFilters(
      dateRange: dateRange ?? this.dateRange,
      loadType: loadType ?? this.loadType,
      unpaidOnly: unpaidOnly ?? this.unpaidOnly,
      radiusKm: radiusKm ?? this.radiusKm,
    );
  }
}

class ShipmentApi {
  const ShipmentApi();

  static const _pageSize = 5;

  Future<List<Map<String, dynamic>>> fetchShipments({
    required ShipmentStatusFilter status,
    int page = 1,
    AdvancedShipmentFilters? filters,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final List<Map<String, dynamic>> source;
    switch (status) {
      case ShipmentStatusFilter.ongoing:
        source = _ongoingShipments;
        break;
      case ShipmentStatusFilter.completed:
        source = _completedShipments;
        break;
      case ShipmentStatusFilter.all:
        source = [..._ongoingShipments, ..._completedShipments];
        break;
    }
    final start = (page - 1) * _pageSize;
    if (start >= source.length) {
      return [];
    }
    final end = (start + _pageSize).clamp(0, source.length);
    return source.sublist(start, end);
  }

  Future<Map<String, dynamic>> fetchShipmentDetails(String shipmentId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return [
      ..._ongoingShipments,
      ..._completedShipments,
    ].firstWhere((element) => element['id'] == shipmentId,
        orElse: () => _ongoingShipments.first);
  }

  Future<Uri> downloadInvoice(String shipmentId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Uri.parse('https://example.com/invoices/$shipmentId.pdf');
  }

  Future<void> raiseIssue({
    required String shipmentId,
    required String subject,
    required String description,
    String? attachmentPath,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));
  }

  Future<void> verifyOtp({
    required String shipmentId,
    required String type,
    required String otp,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (otp != '1234') {
      throw Exception('Invalid OTP');
    }
  }

  Future<void> updateShipmentStatus(String shipmentId, int currentStep) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<List<Map<String, dynamic>>> fetchShipmentEvents(
      String shipmentId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _ongoingShipments.first['events'] as List<Map<String, dynamic>>;
  }
}

final List<Map<String, dynamic>> _ongoingShipments = [
  {
    'id': 'SHIP123456',
    'startedAt': 'Apr 10, 2024, 09:30',
    'loadCategory': 'Full Truck',
    'pickupAddress': '1234 Elm Street, Springfield, IL 62701',
    'dropAddress': '5678 Oak Avenue, Naperville, IL 60540',
    'pickupLat': 40.0,
    'pickupLng': -89.0,
    'dropLat': 41.75,
    'dropLng': -88.16,
    'price': '₹45,000',
    'vehicle': 'Axle 14',
    'currentStep': ShipmentProgressStep.loading.index,
    'truckNo': 'KA 05 AB 1234',
    'truckType': '28 Ft Trailer',
    'tyres': 14,
    'operatorPhone': '+91 98765 43210',
    'senderPhone': '+91 99888 77665',
    'receiverPhone': '+91 99123 45678',
    'events': [
      {
        'id': 'pickup',
        'title': 'Arrived at pickup',
        'time': '09:00',
        'detail': 'Driver checked in at gate',
      },
      {
        'id': 'loading',
        'title': 'Loading complete',
        'time': '10:15',
        'detail': 'Sealed and ready to depart',
      },
    ],
  },
];

final List<Map<String, dynamic>> _completedShipments = [
  {
    'id': 'SHIP654321',
    'startedAt': 'Oct 24, 2023, 09:00',
    'pickupAddress': '123 Industrial Park, Springfield, IL 62701',
    'pickupTime': '10/26/2023, 9:00 AM',
    'dropAddress': '456 Commerce St, Metropolis, IL 62960',
    'dropTime': '10/27/2023, 2:30 PM',
    'loadCategory': 'Full Truck',
    'rating': 4.0,
    'price': '\$2,500',
    'vehicle': 'Volvo FH16',
    'truckNo': 'TN 10 BB 4455',
    'truckType': '40 Ft Trailer',
    'operatorPhone': '+1 555-210-3344',
    'events': const [],
  },
  {
    'id': 'SHIP777888',
    'startedAt': 'Sep 02, 2023, 06:30',
    'pickupAddress': '12 Central Hub, Austin, TX 75001',
    'pickupTime': '09/02/2023, 7:00 AM',
    'dropAddress': '98 Rockford Plaza, Dallas, TX 75050',
    'dropTime': '09/03/2023, 1:45 PM',
    'loadCategory': 'Partial Truck',
    'rating': 5.0,
    'price': '\$1,200',
    'vehicle': 'Tata Signa',
    'truckNo': 'KA 03 YZ 9911',
    'truckType': '24 Ft Lorry',
    'operatorPhone': '+1 555-888-9900',
    'events': const [],
  },
];
