import 'package:flutter/material.dart';
import '../widgets/booking_card.dart';
import '../widgets/bidding_list_modal.dart';
import '../widgets/booking_details_modal.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({Key? key}) : super(key: key);

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  // Mock bookings data
  List<Map<String, dynamic>> bookings = [
    {
      "id": "RDS1234",
      "pickup": "Hyderabad",
      "drop": "Vijayawada",
      "km": "260",
      "date": "07 Nov 2025",
      "time": "09:00 AM",
      "status": "Posted",
      "timerMinutes": 45, // Timer for bid acceptance in minutes
      "loadType": "PTL" // PTL = Partial Load, FTL = Full Truck Load
    },
    {
      "id": "RDS1235",
      "pickup": "Guntur",
      "drop": "Chennai",
      "km": "430",
      "date": "08 Nov 2025",
      "time": "10:00 AM",
      "status": "Posted",
      "timerMinutes": 120,
      "loadType": "FTL"
    },
    {
      "id": "RDS1236",
      "pickup": "Bangalore",
      "drop": "Mumbai",
      "km": "980",
      "date": "10 Nov 2025",
      "time": "06:00 AM",
      "status": "Confirmed",
      "timerMinutes": 0,
      "loadType": "FTL"
    },
    {
      "id": "RDS1230",
      "pickup": "Visakhapatnam",
      "drop": "Hyderabad",
      "km": "620",
      "date": "05 Nov 2025",
      "time": "08:00 AM",
      "status": "Confirmed",
      "timerMinutes": 0,
      "loadType": "PTL"
    },
  ];

  // Mock bids data - keyed by booking ID
  Map<String, List<Map<String, dynamic>>> bidsData = {
    "RDS1234": [
      {
        "driver": "Ram Logistics",
        "truck": "20ft Container",
        "bid": "18500",
        "payment": "20% Advance",
        "operatorMobile": "9876543210"
      },
      {
        "driver": "Sai Transports",
        "truck": "Open Body",
        "bid": "17900",
        "payment": "10% Advance",
        "operatorMobile": "9123456789"
      },
      {
        "driver": "Krishna Movers",
        "truck": "14ft Truck",
        "bid": "19200",
        "payment": "15% Advance",
        "operatorMobile": "9988776655"
      },
    ],
    "RDS1235": [
      {
        "driver": "Venkat Transport",
        "truck": "22ft Container",
        "bid": "22000",
        "payment": "20% Advance",
        "operatorMobile": "9845022119"
      },
      {
        "driver": "Lakshmi Cargo",
        "truck": "20ft Open",
        "bid": "21500",
        "payment": "25% Advance",
        "operatorMobile": "9876512345"
      },
    ],
    "RDS1236": [
      {
        "driver": "Reddy Logistics",
        "truck": "32ft Container",
        "bid": "45000",
        "payment": "25% Advance",
        "operatorMobile": "9123987654"
      },
      {
        "driver": "Express Movers",
        "truck": "28ft Truck",
        "bid": "43500",
        "payment": "20% Advance",
        "operatorMobile": "9988123456"
      },
    ],
    "RDS1230": [
      {
        "driver": "Coastal Transport",
        "truck": "24ft Container",
        "bid": "28000",
        "payment": "30% Advance",
        "operatorMobile": "9876098765"
      },
      {
        "driver": "Highway Cargo",
        "truck": "20ft Open",
        "bid": "27500",
        "payment": "20% Advance",
        "operatorMobile": "9123567890"
      },
    ],
  };

  void _cancelBooking(String bookingId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Cancel Booking',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            color: Color(0xFFC90D0D),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Are you sure you want to cancel this booking?',
          style: TextStyle(fontFamily: 'Times New Roman'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'No',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Times New Roman',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final index = bookings.indexWhere((b) => b['id'] == bookingId);
                if (index != -1) {
                  bookings[index]['status'] = 'Cancelled';
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking Cancelled'),
                  backgroundColor: Color(0xFFC90D0D),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC90D0D),
            ),
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Times New Roman',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _viewDetails(String bookingId) {
    final booking = bookings.firstWhere((b) => b['id'] == bookingId);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BookingDetailsModal(
        bookingId: booking['id'],
        pickup: booking['pickup'],
        drop: booking['drop'],
        km: booking['km'],
        date: booking['date'],
        time: booking['time'],
        status: booking['status'],
      ),
    );
  }

  void _viewBids(String bookingId) {
    final bids = bidsData[bookingId] ?? [];
    final booking = bookings.firstWhere((b) => b['id'] == bookingId);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BiddingListModal(
        bookingId: bookingId,
        bids: bids,
        status: booking['status'],
        onAcceptBid: (bid) {
          _acceptBid(bookingId, bid);
        },
      ),
    );
  }

  void _acceptBid(String bookingId, Map<String, dynamic> bid) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Confirm Bid',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            color: Color(0xFFC90D0D),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to accept bid from ${bid['driver']} for ₹${bid['bid']}?',
          style: const TextStyle(fontFamily: 'Times New Roman'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Times New Roman',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final index = bookings.indexWhere((b) => b['id'] == bookingId);
                if (index != -1) {
                  bookings[index]['status'] = 'Confirmed';
                }
              });
              Navigator.pop(context); // Close confirmation dialog
              Navigator.pop(context); // Close bidding modal
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Bid Accepted — Booking Confirmed'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC90D0D),
            ),
            child: const Text(
              'Yes, Confirm',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Times New Roman',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _findAnotherDriver(String bookingId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Find Another Driver?',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            color: Color(0xFFC90D0D),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'The current driver will be unassigned and bidding will reopen for this booking.',
          style: TextStyle(fontFamily: 'Times New Roman'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Times New Roman',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final index = bookings.indexWhere((b) => b['id'] == bookingId);
                if (index != -1) {
                  bookings[index]['status'] = 'Reopened';
                }
              });
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bidding reopened. You can now select a new driver.'),
                  backgroundColor: Color(0xFFC90D0D),
                  duration: Duration(seconds: 2),
                ),
              );
              
              // Automatically open the bidding modal after a short delay
              Future.delayed(const Duration(milliseconds: 500), () {
                _viewBids(bookingId);
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC90D0D),
            ),
            child: const Text(
              'Confirm',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Times New Roman',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No bookings yet.',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 18,
              fontFamily: 'Times New Roman',
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC90D0D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Book Now',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Times New Roman',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'My Bookings',
          style: TextStyle(
            color: Color(0xFFC90D0D),
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFFC90D0D)),
            onPressed: () {
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Refreshed'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: bookings.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return BookingCard(
                  bookingId: booking['id'],
                  pickup: booking['pickup'],
                  drop: booking['drop'],
                  km: booking['km'],
                  date: booking['date'],
                  time: booking['time'],
                  status: booking['status'],
                  timerMinutes: booking['timerMinutes'] ?? 0,
                  loadType: booking['loadType'] ?? 'FTL',
                  onCancel: () => _cancelBooking(booking['id']),
                  onViewBids: () => _viewBids(booking['id']),
                  onViewDetails: () => _viewDetails(booking['id']),
                  onFindAnotherDriver: booking['status'] == 'Confirmed'
                      ? () => _findAnotherDriver(booking['id'])
                      : null,
                );
              },
            ),
    );
  }
}
