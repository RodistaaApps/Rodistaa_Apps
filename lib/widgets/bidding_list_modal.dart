import 'package:flutter/material.dart';

class BiddingListModal extends StatelessWidget {
  final String bookingId;
  final List<Map<String, dynamic>> bids;
  final Function(Map<String, dynamic>) onAcceptBid;
  final String? status;

  const BiddingListModal({
    Key? key,
    required this.bookingId,
    required this.bids,
    required this.onAcceptBid,
    this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Modal Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Title and Close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Bidding Offers',
                            style: TextStyle(
                              fontFamily: 'Times New Roman',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFC90D0D),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bookingId,
                            style: TextStyle(
                              fontFamily: 'Times New Roman',
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.grey, size: 28),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bids List or Empty State
          Expanded(
            child: bids.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: bids.length,
                    itemBuilder: (context, index) {
                      final bid = bids[index];
                      return _buildBidCard(context, bid);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final isReopened = status == 'Reopened';
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            isReopened ? 'No new bids yet.' : 'No bids yet.',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isReopened 
                ? 'Drivers will be notified about this reopened load.'
                : 'Please wait for drivers to respond.',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBidCard(BuildContext context, Map<String, dynamic> bid) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Driver Name
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC90D0D).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFFC90D0D),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    bid['driver'],
                    style: const TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Truck Type
            _buildInfoRow(
              Icons.local_shipping,
              'Truck Type',
              bid['truck'],
            ),
            const SizedBox(height: 10),

            // Freight Amount
            _buildInfoRow(
              Icons.currency_rupee,
              'Freight Amount',
              '₹${bid['bid']}',
              valueColor: const Color(0xFFC90D0D),
            ),
            const SizedBox(height: 10),

            // Operator Mobile
            _buildInfoRow(
              Icons.phone,
              '📞 Operator',
              bid['operatorMobile'] ?? 'N/A',
              valueColor: Colors.grey.shade700,
            ),
            const SizedBox(height: 10),

            // Payment Terms
            _buildInfoRow(
              Icons.payment,
              'Payment Terms',
              bid['payment'],
            ),
            const SizedBox(height: 16),

            // Accept Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => onAcceptBid(bid),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC90D0D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 2,
                ),
                child: const Text(
                  'Accept Bid',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Times New Roman',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

