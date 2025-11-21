class Load {
  Load({
    required this.loadId,
    required this.fromCity,
    required this.toCity,
    required this.distanceKm,
    required this.weightTons,
    required this.requiredTruckTypes,
    required this.pickupDateTime,
    required this.deliveryDateTime,
    required this.material,
    required this.currentBidCount,
    required this.lowestBid,
    required this.highestBid,
    required this.averageBid,
    this.yourBid,
    this.notes,
  });

  final String loadId;
  final String fromCity;
  final String toCity;
  final double distanceKm;
  final double weightTons;
  final List<String> requiredTruckTypes;
  final DateTime pickupDateTime;
  final DateTime deliveryDateTime;
  final String material;
  final int currentBidCount;
  final double lowestBid;
  final double highestBid;
  final double averageBid;
  final double? yourBid;
  final String? notes;
}

