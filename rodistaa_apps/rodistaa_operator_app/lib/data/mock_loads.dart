import 'package:rodistaa_operator_app/models/load.dart';

final List<Load> mockLoads = [
  Load(
    loadId: 'L12345',
    fromCity: 'Bangalore (560001)',
    toCity: 'Chennai (600001)',
    distanceKm: 350,
    weightTons: 5,
    requiredTruckTypes: const ['LCV', 'MCV'],
    pickupDateTime: DateTime(2024, 12, 15, 10, 0),
    deliveryDateTime: DateTime(2024, 12, 16, 18, 0),
    material: 'Electronics',
    currentBidCount: 12,
    lowestBid: 22500,
    highestBid: 32000,
    averageBid: 26800,
    yourBid: 25000,
  ),
  Load(
    loadId: 'L12346',
    fromCity: 'Delhi (110001)',
    toCity: 'Mumbai (400001)',
    distanceKm: 1400,
    weightTons: 10,
    requiredTruckTypes: const ['HCV', 'Trailer'],
    pickupDateTime: DateTime(2024, 12, 18, 6, 0),
    deliveryDateTime: DateTime(2024, 12, 20, 21, 0),
    material: 'FMCG Goods',
    currentBidCount: 5,
    lowestBid: 45000,
    highestBid: 60000,
    averageBid: 52000,
  ),
];

