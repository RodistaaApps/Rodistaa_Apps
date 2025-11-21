import 'package:flutter/material.dart';

import '../data/mock_drivers.dart';
import '../models/driver.dart';
import '../utils/formatters.dart';

class DriverProvider extends ChangeNotifier {
  DriverProvider() {
    _drivers = List<Driver>.from(
      mockDrivers.map(
        (driver) => driver.copyWith(
          assignedTruckNumber: driver.assignedTruckNumber != null
              ? formatTruckNumber(driver.assignedTruckNumber!)
              : null,
        ),
      ),
    );
  }

  late final List<Driver> _drivers;
  String _searchQuery = '';
  String? _statusFilter;

  List<Driver> get drivers => List<Driver>.unmodifiable(_drivers);

  Driver? getDriverById(String driverId) {
    try {
      return _drivers.firstWhere((driver) => driver.driverId == driverId);
    } catch (e) {
      return null;
    }
  }

  String get searchQuery => _searchQuery;
  String? get statusFilter => _statusFilter;

  List<Driver> get filteredDrivers {
    final query = _searchQuery.toLowerCase();
    return _drivers.where((driver) {
      final matchesSearch = query.isEmpty ||
          driver.name.toLowerCase().contains(query) ||
          driver.phoneNumber.replaceAll(' ', '').contains(query.replaceAll(' ', ''));
      final status = driver.status.toLowerCase();
      final matchesStatus = _statusFilter == null ||
          (_statusFilter!.toLowerCase() == 'available' &&
              (status == 'available' || status == 'idle' || status == 'unassigned')) ||
          (_statusFilter!.toLowerCase() == 'ontrip' &&
              (status == 'ontrip' || status == 'on trip' || status == 'on_trip'));
      return matchesSearch && matchesStatus;
    }).toList();
  }

  int get totalDrivers => _drivers.length;
  int get availableDrivers =>
      _drivers.where((driver) => driver.status == 'available').length;
  int get onTripDrivers =>
      _drivers.where((driver) => driver.status == 'onTrip').length;
  int get onLeaveDrivers =>
      _drivers.where((driver) => driver.status == 'onLeave').length;
  int get idleDrivers =>
      _drivers.where((driver) => driver.status == 'idle').length;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setStatusFilter(String? status) {
    _statusFilter = status;
    notifyListeners();
  }

  void addDriver(Driver driver) {
    _drivers.add(driver);
    notifyListeners();
  }

  void deleteDriver(String driverId) {
    _drivers.removeWhere((driver) => driver.driverId == driverId);
    notifyListeners();
  }

  void updateDriver(Driver driver) {
    final index = _drivers.indexWhere((d) => d.driverId == driver.driverId);
    if (index != -1) {
      _drivers[index] = driver;
      notifyListeners();
    }
  }

  void assignDriverToTruck({
    required String driverId,
    required String truckId,
    required String truckNumber,
    required bool truckOnTrip,
  }) {
    final index = _drivers.indexWhere((driver) => driver.driverId == driverId);
    if (index != -1) {
      final driver = _drivers[index];
      _drivers[index] = driver.copyWith(
        assignedTruckId: truckId,
        assignedTruckNumber: formatTruckNumber(truckNumber),
        status: truckOnTrip ? 'onTrip' : 'available',
      );
      notifyListeners();
    }
  }

  void markDriverIdle(String driverId) {
    final index = _drivers.indexWhere((driver) => driver.driverId == driverId);
    if (index != -1) {
      final driver = _drivers[index];
      _drivers[index] = driver.copyWith(
        assignedTruckId: null,
        assignedTruckNumber: null,
        status: 'idle',
      );
      notifyListeners();
    }
  }

  void unassignDriver(String driverId) {
    final index = _drivers.indexWhere((driver) => driver.driverId == driverId);
    if (index != -1) {
      final driver = _drivers[index];
      _drivers[index] = driver.copyWith(
        assignedTruckId: null,
        assignedTruckNumber: null,
        status: 'unassigned',
      );
      notifyListeners();
    }
  }
}

