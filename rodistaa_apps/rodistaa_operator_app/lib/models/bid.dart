enum BidStatus {
  pending,
  accepted,
  rejected,
  withdrawn,
  expired,
}

class Bid {
  Bid({
    required this.bidId,
    required this.bookingId,
    required this.operatorId,
    required this.truckId,
    required this.truckNumber,
    required this.driverId,
    required this.driverName,
    required this.bidAmount,
    required this.expectedDelivery,
    required this.bidPlacedAt,
    required this.rank,
    required this.totalBids,
    required this.status,
    this.lowestBid,
    this.averageBid,
    this.rejectionReason,
  });

  final String bidId;
  final String bookingId;
  final String operatorId;
  final String truckId;
  final String truckNumber;
  final String driverId;
  final String driverName;
  double bidAmount;
  DateTime expectedDelivery;
  final DateTime bidPlacedAt;
  int rank;
  int totalBids;
  BidStatus status;
  double? lowestBid;
  double? averageBid;
  String? rejectionReason;

  bool get isOngoing => status == BidStatus.pending;

  bool get isCompleted => status != BidStatus.pending;

  Bid copyWith({
    double? bidAmount,
    DateTime? expectedDelivery,
    DateTime? bidPlacedAt,
    int? rank,
    int? totalBids,
    BidStatus? status,
    double? lowestBid,
    double? averageBid,
    String? rejectionReason,
  }) {
    return Bid(
      bidId: bidId,
      bookingId: bookingId,
      operatorId: operatorId,
      truckId: truckId,
      truckNumber: truckNumber,
      driverId: driverId,
      driverName: driverName,
      bidAmount: bidAmount ?? this.bidAmount,
      expectedDelivery: expectedDelivery ?? this.expectedDelivery,
      bidPlacedAt: bidPlacedAt ?? this.bidPlacedAt,
      rank: rank ?? this.rank,
      totalBids: totalBids ?? this.totalBids,
      status: status ?? this.status,
      lowestBid: lowestBid ?? this.lowestBid,
      averageBid: averageBid ?? this.averageBid,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}

