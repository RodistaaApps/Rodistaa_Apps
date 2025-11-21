enum TruckStatus { active, idle, maintenance, onTrip }

class Truck {
  Truck({
    required this.truckId,
    required this.registrationNumber,
    required this.truckType,
    required this.brand,
    required this.model,
    required this.capacity,
    required this.status,
    this.assignedDriverId,
    this.assignedDriverName,
    this.insuranceExpiry,
    this.fitnessExpiry,
    this.permitExpiry,
    this.currentLocation,
    this.currentTripId,
    List<String>? documents,
    required this.addedDate,
    this.totalTrips = 0,
    this.completedTrips = 0,
    this.cancelledTrips = 0,
  }) : documents = documents ?? <String>[];

  final String truckId;
  final String registrationNumber;
  final String truckType;
  final String brand;
  final String model;
  final double capacity;
  TruckStatus status;
  String? assignedDriverId;
  String? assignedDriverName;
  DateTime? insuranceExpiry;
  DateTime? fitnessExpiry;
  DateTime? permitExpiry;
  String? currentLocation;
  String? currentTripId;
  final List<String> documents;
  final DateTime addedDate;
  final int totalTrips;
  final int completedTrips;
  final int cancelledTrips;

  Truck copyWith({
    String? truckId,
    String? registrationNumber,
    String? truckType,
    String? brand,
    String? model,
    double? capacity,
    TruckStatus? status,
    String? assignedDriverId,
    String? assignedDriverName,
    DateTime? insuranceExpiry,
    DateTime? fitnessExpiry,
    DateTime? permitExpiry,
    String? currentLocation,
    String? currentTripId,
    List<String>? documents,
    DateTime? addedDate,
    int? totalTrips,
    int? completedTrips,
    int? cancelledTrips,
  }) {
    return Truck(
      truckId: truckId ?? this.truckId,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      truckType: truckType ?? this.truckType,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      capacity: capacity ?? this.capacity,
      status: status ?? this.status,
      assignedDriverId: assignedDriverId ?? this.assignedDriverId,
      assignedDriverName: assignedDriverName ?? this.assignedDriverName,
      insuranceExpiry: insuranceExpiry ?? this.insuranceExpiry,
      fitnessExpiry: fitnessExpiry ?? this.fitnessExpiry,
      permitExpiry: permitExpiry ?? this.permitExpiry,
      currentLocation: currentLocation ?? this.currentLocation,
      currentTripId: currentTripId ?? this.currentTripId,
      documents: documents ?? List<String>.from(this.documents),
      addedDate: addedDate ?? this.addedDate,
      totalTrips: totalTrips ?? this.totalTrips,
      completedTrips: completedTrips ?? this.completedTrips,
      cancelledTrips: cancelledTrips ?? this.cancelledTrips,
    );
  }
}

