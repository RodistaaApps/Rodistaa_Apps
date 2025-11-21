import 'package:flutter/material.dart';

import '../data/mock_bids.dart';
import '../models/bid.dart';

class BidProvider extends ChangeNotifier {
  BidProvider() {
    _bids = List<Bid>.from(mockBids);
  }

  late final List<Bid> _bids;

  List<Bid> get bids => List<Bid>.unmodifiable(_bids);

  List<Bid> get ongoingBids =>
      _bids.where((bid) => bid.isOngoing).toList()..sort(_sortByRecent);

  List<Bid> get completedBids => _bids
      .where((bid) =>
          bid.status == BidStatus.accepted ||
          bid.status == BidStatus.rejected ||
          bid.status == BidStatus.withdrawn)
      .toList()
    ..sort(_sortByRecent);

  Bid getBidById(String bidId) =>
      _bids.firstWhere((bid) => bid.bidId == bidId);

  int _sortByRecent(Bid a, Bid b) =>
      b.bidPlacedAt.compareTo(a.bidPlacedAt);

  void addBid(Bid bid) {
    _bids.add(bid);
    notifyListeners();
  }

  Bid placeBid({
    required String bookingId,
    required String operatorId,
    required String truckId,
    required String truckNumber,
    required String driverId,
    required String driverName,
    required double amount,
    required DateTime expectedDelivery,
    required int currentTotalBids,
    double? lowestBid,
    double? averageBid,
  }) {
    final bid = Bid(
      bidId: 'B${DateTime.now().millisecondsSinceEpoch}',
      bookingId: bookingId,
      operatorId: operatorId,
      truckId: truckId,
      truckNumber: truckNumber,
      driverId: driverId,
      driverName: driverName,
      bidAmount: amount,
      expectedDelivery: expectedDelivery,
      bidPlacedAt: DateTime.now(),
      rank: currentTotalBids == 0 ? 1 : currentTotalBids + 1,
      totalBids: currentTotalBids + 1,
      status: BidStatus.pending,
      lowestBid: lowestBid,
      averageBid: averageBid,
    );
    _bids.add(bid);
    notifyListeners();
    return bid;
  }

  void updateBid(Bid bid) {
    final index = _bids.indexWhere((existing) => existing.bidId == bid.bidId);
    if (index != -1) {
      _bids[index] = bid;
      notifyListeners();
    }
  }

  void withdrawBid(String bidId) {
    final index = _bids.indexWhere((bid) => bid.bidId == bidId);
    if (index != -1) {
      _bids[index] = _bids[index].copyWith(status: BidStatus.withdrawn);
      notifyListeners();
    }
  }

  void updateBidAmount({
    required String bidId,
    required double newAmount,
    int? newRank,
    double? lowestBid,
    double? averageBid,
  }) {
    final index = _bids.indexWhere((bid) => bid.bidId == bidId);
    if (index != -1) {
      _bids[index] = _bids[index].copyWith(
        bidAmount: newAmount,
        rank: newRank,
        lowestBid: lowestBid,
        averageBid: averageBid,
        bidPlacedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void updateBidStatus({
    required String bidId,
    required BidStatus status,
    String? rejectionReason,
  }) {
    final index = _bids.indexWhere((bid) => bid.bidId == bidId);
    if (index != -1) {
      _bids[index] = _bids[index].copyWith(
        status: status,
        rejectionReason: rejectionReason,
      );
      notifyListeners();
    }
  }

}

