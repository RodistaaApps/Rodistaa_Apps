// RODISTAA THEME shipment domain models.
// TODO: Replace mock data with backend DTOs once shipments API is ready.

enum ShipmentStatus { ongoing, completed }

class ShipmentDriver {
  const ShipmentDriver({
    required this.name,
    required this.phone,
    required this.truckNumber,
    required this.tyreCount,
  });

  final String name;
  final String phone;
  final String truckNumber;
  final int tyreCount;

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'DR';
  }
}

class ShipmentTimelineStage {
  const ShipmentTimelineStage({
    required this.key,
    required this.label,
    required this.completed,
    this.timestamp,
  });

  final String key;
  final String label;
  final bool completed;
  final DateTime? timestamp;
}

class Shipment {
  const Shipment({
    required this.id,
    required this.origin,
    required this.destination,
    required this.category,
    required this.weightTons,
    required this.bodyType,
    required this.tyres,
    required this.ftlOrPtl,
    required this.timerEndsAt,
    required this.driver,
    required this.status,
    required this.timelineStages,
    required this.lastUpdated,
    required this.distanceKm,
    this.estimatedFuelCost,
    this.tollEstimate,
  });

  final String id;
  final String origin;
  final String destination;
  final String category;
  final double weightTons;
  final String bodyType;
  final int tyres;
  final String ftlOrPtl;
  final DateTime? timerEndsAt;
  final ShipmentDriver driver;
  final ShipmentStatus status;
  final List<ShipmentTimelineStage> timelineStages;
  final DateTime lastUpdated;
  final double distanceKm;
  final double? estimatedFuelCost;
  final double? tollEstimate;

  bool get isOngoing => status == ShipmentStatus.ongoing;

  Duration? timeRemaining(DateTime reference) {
    if (timerEndsAt == null) return null;
    final diff = timerEndsAt!.difference(reference);
    if (diff.isNegative) return Duration.zero;
    return diff;
  }

  ShipmentTimelineStage? get currentStage {
    for (final stage in timelineStages) {
      if (!stage.completed) return stage;
    }
    return timelineStages.isNotEmpty ? timelineStages.last : null;
  }
}

