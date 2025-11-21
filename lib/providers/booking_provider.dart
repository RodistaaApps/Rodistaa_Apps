import 'package:flutter/material.dart';

import '../data/mock_bookings.dart';
import '../models/booking.dart';

enum RouteFilter { all, withinState, interState }
enum TruckTypeFilter { all, mini, lcv, mcv, hcv }
enum DistanceFilter { all, under300, between300And800, above800 }

class BookingProvider extends ChangeNotifier {
  BookingProvider() {
    _bookings = List<Booking>.from(mockBookings);
  }

  late final List<Booking> _bookings;

  RouteFilter _routeFilter = RouteFilter.all;
  TruckTypeFilter _truckFilter = TruckTypeFilter.all;
  DistanceFilter _distanceFilter = DistanceFilter.all;

  List<Booking> get bookings => List<Booking>.unmodifiable(_bookings);

  RouteFilter get routeFilter => _routeFilter;
  TruckTypeFilter get truckFilter => _truckFilter;
  DistanceFilter get distanceFilter => _distanceFilter;

  List<Booking> get availableBookings {
    return _bookings.where((booking) {
      if (!booking.isOpen) return false;

      final routeMatch = switch (_routeFilter) {
        RouteFilter.all => true,
        RouteFilter.withinState =>
            booking.fromPincode.characters.take(2).toString() ==
            booking.toPincode.characters.take(2).toString(),
        RouteFilter.interState =>
            booking.fromPincode.characters.take(2).toString() !=
            booking.toPincode.characters.take(2).toString(),
      };

      final truckMatch = switch (_truckFilter) {
        TruckTypeFilter.all => true,
        TruckTypeFilter.mini => booking.requiredTruckType.toLowerCase().contains('mini'),
        TruckTypeFilter.lcv => booking.requiredTruckType.toLowerCase().contains('lcv'),
        TruckTypeFilter.mcv => booking.requiredTruckType.toLowerCase().contains('mcv'),
        TruckTypeFilter.hcv => booking.requiredTruckType.toLowerCase().contains('hcv'),
      };

      final distanceMatch = switch (_distanceFilter) {
        DistanceFilter.all => true,
        DistanceFilter.under300 => booking.distance < 300,
        DistanceFilter.between300And800 => booking.distance >= 300 && booking.distance <= 800,
        DistanceFilter.above800 => booking.distance > 800,
      };

      return routeMatch && truckMatch && distanceMatch;
    }).toList()
      ..sort((a, b) => a.pickupDate.compareTo(b.pickupDate));
  }

  Booking? getBookingById(String bookingId) {
    try {
      return _bookings.firstWhere((booking) => booking.bookingId == bookingId);
    } catch (_) {
      return null;
    }
  }

  void setFilters({
    RouteFilter? route,
    TruckTypeFilter? truck,
    DistanceFilter? distance,
  }) {
    var changed = false;
    if (route != null && route != _routeFilter) {
      _routeFilter = route;
      changed = true;
    }
    if (truck != null && truck != _truckFilter) {
      _truckFilter = truck;
      changed = true;
    }
    if (distance != null && distance != _distanceFilter) {
      _distanceFilter = distance;
      changed = true;
    }
    if (changed) notifyListeners();
  }

  void clearFilters() {
    _routeFilter = RouteFilter.all;
    _truckFilter = TruckTypeFilter.all;
    _distanceFilter = DistanceFilter.all;
    notifyListeners();
  }

  void incrementBidCount(String bookingId) {
    final index = _bookings.indexWhere((booking) => booking.bookingId == bookingId);
    if (index == -1) return;
    _bookings[index] =
        _bookings[index].copyWith(totalBids: _bookings[index].totalBids + 1);
    notifyListeners();
  }

  void markBookingAsBid(String bookingId) {
    final index = _bookings.indexWhere((booking) => booking.bookingId == bookingId);
    if (index == -1) return;
    _bookings[index] = _bookings[index].copyWith(status: 'bid_pending');
    notifyListeners();
  }

  void reopenBooking(String bookingId) {
    final index = _bookings.indexWhere((booking) => booking.bookingId == bookingId);
    if (index == -1) return;
    _bookings[index] = _bookings[index].copyWith(status: 'open');
    notifyListeners();
  }
}

