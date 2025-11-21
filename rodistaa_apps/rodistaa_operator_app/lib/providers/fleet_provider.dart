import 'package:flutter/material.dart';

import '../data/mock_trucks.dart';
import '../models/truck.dart';
import '../utils/formatters.dart';

class FleetProvider extends ChangeNotifier {
  FleetProvider() {
    _trucks = mockTrucks
        .map(
          (truck) => truck.copyWith(
            registrationNumber: formatTruckNumber(truck.registrationNumber),
            assignedDriverName: truck.assignedDriverName,
          ),
        )
        .toList();
  }

  late final List<Truck> _trucks;
  String _searchQuery = '';
  TruckStatus? _statusFilter;
  String? _typeFilter;
  bool? _assignedFilter; // true assigned, false unassigned

  List<Truck> get trucks => List<Truck>.unmodifiable(_trucks);

  String get searchQuery => _searchQuery;
  TruckStatus? get statusFilter => _statusFilter;
  String? get typeFilter => _typeFilter;
  bool? get assignedFilter => _assignedFilter;

  List<Truck> get filteredTrucks {
    final query = _searchQuery.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return _trucks.where((truck) {
      // Search in both formatted and raw registration number
      final formattedNumber = formatTruckNumber(truck.registrationNumber).toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
      final rawNumber = truck.registrationNumber.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
      final matchesSearch = query.isEmpty || 
                            formattedNumber.contains(query) || 
                            rawNumber.contains(query);

      final matchesStatus =
          _statusFilter == null || truck.status == _statusFilter;

      final matchesType = _typeFilter == null ||
          truck.truckType.toLowerCase() == _typeFilter!.toLowerCase();

      final matchesAssignment = _assignedFilter == null ||
          (_assignedFilter! && truck.assignedDriverId != null) ||
          (!_assignedFilter! && truck.assignedDriverId == null);

      return matchesSearch && matchesStatus && matchesType && matchesAssignment;
    }).toList();
  }

  int get totalTrucks => _trucks.length;

  int get activeTrucks =>
      _trucks.where((truck) => truck.status == TruckStatus.onTrip || truck.status == TruckStatus.active).length;

  int get idleTrucks =>
      _trucks.where((truck) => truck.status == TruckStatus.idle).length;

  int get maintenanceTrucks =>
      _trucks.where((truck) => truck.status == TruckStatus.maintenance).length;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setStatusFilter(TruckStatus? status) {
    _statusFilter = status;
    notifyListeners();
  }

  void setTypeFilter(String? type) {
    _typeFilter = type;
    notifyListeners();
  }

  void setAssignedFilter(bool? assigned) {
    _assignedFilter = assigned;
    notifyListeners();
  }

  void addTruck(Truck truck) {
    _trucks.add(
      truck.copyWith(
        registrationNumber: formatTruckNumber(truck.registrationNumber),
      ),
    );
    notifyListeners();
  }

  void updateTruck(Truck updatedTruck) {
    final index = _trucks.indexWhere((truck) => truck.truckId == updatedTruck.truckId);
    if (index != -1) {
      _trucks[index] = updatedTruck.copyWith(
        registrationNumber: formatTruckNumber(updatedTruck.registrationNumber),
      );
      notifyListeners();
    }
  }

  void assignDriver({
    required String truckId,
    required String driverId,
    required String driverName,
    TruckStatus? updatedStatus,
  }) {
    final index = _trucks.indexWhere((truck) => truck.truckId == truckId);
    if (index != -1) {
      final truck = _trucks[index];
      _trucks[index] = truck.copyWith(
        assignedDriverId: driverId,
        assignedDriverName: driverName,
        status: updatedStatus ?? truck.status,
      );
      notifyListeners();
    }
  }

  void unassignDriver(String truckId, {TruckStatus? updatedStatus}) {
    final index = _trucks.indexWhere((truck) => truck.truckId == truckId);
    if (index != -1) {
      final truck = _trucks[index];
      _trucks[index] = truck.copyWith(
        assignedDriverId: null,
        assignedDriverName: null,
        status: updatedStatus ?? TruckStatus.idle,
      );
      notifyListeners();
    }
  }

  void removeTruck(String truckId) {
    _trucks.removeWhere((truck) => truck.truckId == truckId);
    notifyListeners();
  }
}

