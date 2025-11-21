class Booking {
  Booking({
    required this.bookingId,
    required this.customerId,
    required this.customerName,
    required this.fromCity,
    required this.fromPincode,
    required this.toCity,
    required this.toPincode,
    required this.distance,
    required this.weight,
    required this.materialType,
    required this.requiredTruckType,
    required this.pickupDate,
    this.deliveryDate,
    required this.minBudget,
    required this.maxBudget,
    required this.totalBids,
    required this.status,
    required this.postedDate,
  });

  final String bookingId;
  final String customerId;
  final String customerName;
  final String fromCity;
  final String fromPincode;
  final String toCity;
  final String toPincode;
  final double distance;
  final double weight;
  final String materialType;
  final String requiredTruckType;
  final DateTime pickupDate;
  final DateTime? deliveryDate;
  final double minBudget;
  final double maxBudget;
  final DateTime postedDate;

  int totalBids;
  String status; // open, closed, cancelled

  bool get isOpen => status == 'open';

  bool get isNew => DateTime.now().difference(postedDate).inHours < 24;

  Booking copyWith({
    int? totalBids,
    String? status,
  }) {
    return Booking(
      bookingId: bookingId,
      customerId: customerId,
      customerName: customerName,
      fromCity: fromCity,
      fromPincode: fromPincode,
      toCity: toCity,
      toPincode: toPincode,
      distance: distance,
      weight: weight,
      materialType: materialType,
      requiredTruckType: requiredTruckType,
      pickupDate: pickupDate,
      deliveryDate: deliveryDate,
      minBudget: minBudget,
      maxBudget: maxBudget,
      totalBids: totalBids ?? this.totalBids,
      status: status ?? this.status,
      postedDate: postedDate,
    );
  }
}
