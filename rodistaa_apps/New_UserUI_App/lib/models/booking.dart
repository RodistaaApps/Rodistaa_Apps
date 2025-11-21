/// Booking data model for the Rodistaa Operator App
class Booking {
  final String id;
  final String bookingId;
  final double km;
  final String pickup;
  final String drop;
  final String status; // 'posted' or 'confirmed'
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.bookingId,
    required this.km,
    required this.pickup,
    required this.drop,
    required this.status,
    required this.createdAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      km: (json['km'] as num).toDouble(),
      pickup: json['pickup'] as String,
      drop: json['drop'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'km': km,
      'pickup': pickup,
      'drop': drop,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

/// Detailed booking information for modal view
class BookingDetails extends Booking {
  final String truckType;
  final DateTime date;
  final String driverName;
  final String truckNumber;
  final String pickupAddress;
  final String dropAddress;
  final double? estimatedCost;
  final String? notes;

  BookingDetails({
    required String id,
    required String bookingId,
    required double km,
    required String pickup,
    required String drop,
    required String status,
    required DateTime createdAt,
    required this.truckType,
    required this.date,
    required this.driverName,
    required this.truckNumber,
    required this.pickupAddress,
    required this.dropAddress,
    this.estimatedCost,
    this.notes,
  }) : super(
          id: id,
          bookingId: bookingId,
          km: km,
          pickup: pickup,
          drop: drop,
          status: status,
          createdAt: createdAt,
        );

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    return BookingDetails(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      km: (json['km'] as num).toDouble(),
      pickup: json['pickup'] as String,
      drop: json['drop'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      truckType: json['truckType'] as String,
      date: DateTime.parse(json['date'] as String),
      driverName: json['driverName'] as String,
      truckNumber: json['truckNumber'] as String,
      pickupAddress: json['pickupAddress'] as String,
      dropAddress: json['dropAddress'] as String,
      estimatedCost: json['estimatedCost'] != null
          ? (json['estimatedCost'] as num).toDouble()
          : null,
      notes: json['notes'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'truckType': truckType,
      'date': date.toIso8601String(),
      'driverName': driverName,
      'truckNumber': truckNumber,
      'pickupAddress': pickupAddress,
      'dropAddress': dropAddress,
      'estimatedCost': estimatedCost,
      'notes': notes,
    });
    return json;
  }
}

