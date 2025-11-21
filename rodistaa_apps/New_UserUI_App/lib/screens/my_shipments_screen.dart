import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyShipmentsScreen extends StatefulWidget {
  const MyShipmentsScreen({Key? key}) : super(key: key);

  @override
  State<MyShipmentsScreen> createState() => _MyShipmentsScreenState();
}

class _MyShipmentsScreenState extends State<MyShipmentsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showBanner = true;

  // Mock data for ongoing shipments (preserved from previous version)
  final List<Map<String, dynamic>> ongoingShipments = [
    {
      "id": "RDS1267",
      "type": "Partial Truck",
      "pickup": "Hyderabad",
      "drop": "Vijayawada",
      "date": "08 Nov 2025",
      "time": "09:00 AM",
      "pickupDate": DateTime(2025, 11, 8, 9, 0),
      "status": "Shipped",
      "totalAmount": 18500,
      "paid": 3700,
      "operator": "Rajesh Transport Co.",
      "operatorPhone": "9845022119",
      "driver": "Ramesh",
      "driverPhone": "9876543210",
      "vehicleNumber": "KA09 AB 1234",
      "vehicleType": "20ft Container",
      "receiverOtp": "1234",
      "otpVerified": false,
    },
    {
      "id": "RDS1268",
      "type": "Full Truck",
      "pickup": "Bangalore",
      "drop": "Chennai",
      "date": "07 Nov 2025",
      "time": "02:00 PM",
      "pickupDate": DateTime(2025, 11, 7, 14, 0),
      "status": "Delivered",
      "totalAmount": 25000,
      "paid": 25000,
      "operator": "Krishna Logistics",
      "operatorPhone": "9845011223",
      "driver": "Suresh",
      "driverPhone": "9123456789",
      "vehicleNumber": "TN07 CD 5678",
      "vehicleType": "22ft Container",
      "receiverOtp": "5678",
      "otpVerified": true,
    },
    {
      "id": "RDS1269",
      "type": "Partial Truck",
      "pickup": "Mumbai",
      "drop": "Pune",
      "date": "09 Nov 2025",
      "time": "11:00 AM",
      "pickupDate": DateTime(2025, 11, 9, 11, 0),
      "status": "Confirmed",
      "totalAmount": 12000,
      "paid": 2400,
      "operator": "Venkat Movers",
      "operatorPhone": "9845033445",
      "driver": "Prakash",
      "driverPhone": "9988776655",
      "vehicleNumber": "MH12 EF 9012",
      "vehicleType": "14ft Truck",
      "receiverOtp": "9012",
      "otpVerified": false,
    },
  ];

  // Mock data for completed shipments
  final List<Map<String, dynamic>> completedShipments = [
    {
      "id": "RDS1256",
      "type": "Full Truck",
      "pickup": "Chennai",
      "drop": "Hyderabad",
      "pickupDate": DateTime(2025, 11, 5, 8, 30),
      "dropDate": DateTime(2025, 11, 5, 17, 45),
      "status": "Delivered",
      "totalAmount": 22000,
      "paid": 22000,
      "operator": "VLR Freight",
      "operatorPhone": "9876543333",
      "driver": "Aravind",
      "driverPhone": "9987654333",
      "vehicleNumber": "AP16 QR 9009",
      "vehicleType": "18ft Container",
      "receiverOtp": "3456",
      "otpVerified": true,
    },
    {
      "id": "RDS1245",
      "type": "Partial Truck",
      "pickup": "Delhi",
      "drop": "Mumbai",
      "pickupDate": DateTime(2025, 10, 28, 6, 0),
      "dropDate": DateTime(2025, 10, 29, 18, 15),
      "status": "Delivered",
      "totalAmount": 45000,
      "paid": 45000,
      "operator": "Lakshmi Transports",
      "operatorPhone": "9123456789",
      "driver": "Suresh Kumar",
      "driverPhone": "9876543210",
      "vehicleNumber": "AP09 XY 4567",
      "vehicleType": "24ft Container (12 Tyres)",
      "receiverOtp": "7890",
      "otpVerified": true,
    },
    {
      "id": "RDS1234",
      "type": "Full Truck",
      "pickup": "Kolkata",
      "drop": "Bhubaneswar",
      "pickupDate": DateTime(2025, 10, 20, 10, 15),
      "dropDate": DateTime(2025, 10, 20, 16, 30),
      "status": "Delivered",
      "totalAmount": 18000,
      "paid": 18000,
      "operator": "Eastern Logistics",
      "operatorPhone": "9988776655",
      "driver": "Ravi Kumar",
      "driverPhone": "9123987456",
      "vehicleNumber": "WB12 CD 3456",
      "vehicleType": "20ft Container",
      "receiverOtp": "2468",
      "otpVerified": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Shipments',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            color: Color(0xFFC90D0D),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFFC90D0D)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFFC90D0D),
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
          indicatorColor: const Color(0xFFC90D0D),
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Ongoing'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Optional Banner Section
          if (_showBanner)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFECEC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Logo placeholder
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.local_shipping,
                      color: Color(0xFFC90D0D),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Track your shipments live with Rodistaa',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 14,
                        color: Color(0xFFC90D0D),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () {
                      setState(() {
                        _showBanner = false;
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Ongoing Tab (Preserved Previous Version)
                _buildOngoingTab(),
                // Completed Tab (New Enhanced Version)
                _buildCompletedTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Preserved Previous Ongoing Tab Implementation
  Widget _buildOngoingTab() {
    return ongoingShipments.isEmpty
        ? _buildEmptyState('ongoing')
        : ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: ongoingShipments.length,
            itemBuilder: (context, index) {
              return _buildOngoingShipmentCard(ongoingShipments[index]);
            },
          );
  }

  Widget _buildCompletedTab() {
    return completedShipments.isEmpty
        ? _buildEmptyState('completed')
        : ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: completedShipments.length,
            itemBuilder: (context, index) {
              return _buildCompletedShipmentCard(completedShipments[index]);
            },
          );
  }

  Widget _buildEmptyState(String type) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              type == 'ongoing' ? Icons.local_shipping_outlined : Icons.check_circle_outline,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              type == 'ongoing' 
                  ? '🚚 No active shipments right now.'
                  : '📦 No completed shipments yet.',
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              type == 'ongoing'
                  ? 'Start booking today on Rodistaa.'
                  : 'Your completed shipments will appear here.',
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            if (type == 'ongoing') ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Navigate to Create Booking screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC90D0D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  'Book Now',
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Preserved Previous Ongoing Shipment Card with Enhancements
  Widget _buildOngoingShipmentCard(Map<String, dynamic> shipment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFC90D0D).withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: const Color(0xFFC90D0D).withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left Accent Bar
          Container(
            width: 5,
            height: 160,
            decoration: const BoxDecoration(
              color: Color(0xFFC90D0D),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Booking ID and Load Type
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Booking ID: ${shipment['id']}',
                        style: const TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC90D0D).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          shipment['type'],
                          style: const TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 11,
                            color: Color(0xFFC90D0D),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Pickup, Drop, and OTP in one row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pickup
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_outlined, color: Colors.green, size: 18),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                shipment['pickup'],
                                style: const TextStyle(
                                  fontFamily: 'Times New Roman',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 14, color: Colors.grey),
                      const SizedBox(width: 8),
                      // Drop
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: Color(0xFFC90D0D), size: 18),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                shipment['drop'],
                                style: const TextStyle(
                                  fontFamily: 'Times New Roman',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // OTP with Label
                      Row(
                        children: [
                          const Text(
                            'OTP:',
                            style: TextStyle(
                              fontFamily: 'Times New Roman',
                              fontSize: 11,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFFC90D0D), width: 1.5),
                            ),
                            child: Text(
                              shipment['receiverOtp'],
                              style: const TextStyle(
                                fontFamily: 'Times New Roman',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFC90D0D),
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Pickup Date and Time
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        shipment['date'],
                        style: const TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        shipment['time'],
                        style: const TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Status Timeline (Enhanced)
                  _buildStatusTimeline(shipment['status']),
                  const SizedBox(height: 16),

                  // Action Buttons (Updated)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showLiveTrackingModal(shipment),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC90D0D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          icon: const Icon(Icons.gps_fixed, size: 18, color: Colors.white),
                          label: const Text(
                            'Live Tracking',
                            style: TextStyle(
                              fontFamily: 'Times New Roman',
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showPaymentStatusModal(shipment),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFC90D0D)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          icon: const Icon(Icons.payment, size: 18, color: Color(0xFFC90D0D)),
                          label: const Text(
                            'Payment Status',
                            style: TextStyle(
                              fontFamily: 'Times New Roman',
                              fontSize: 13,
                              color: Color(0xFFC90D0D),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Enhanced Completed Shipment Card
  Widget _buildCompletedShipmentCard(Map<String, dynamic> shipment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFC90D0D).withOpacity(0.15),
          width: 1.5,
        ),
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
            // Booking ID
            Text(
              'Booking ID: ${shipment['id']}',
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC90D0D),
              ),
            ),
            const SizedBox(height: 10),

            // Pickup Location and Time
            Row(
              children: [
                const Icon(Icons.location_on_outlined, color: Colors.green, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pickup: ${shipment['pickup']}',
                        style: const TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        DateFormat('dd MMM yyyy, hh:mm a').format(shipment['pickupDate']),
                        style: const TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Drop Location and Time
            Row(
              children: [
                const Icon(Icons.location_on, color: Color(0xFFC90D0D), size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Drop: ${shipment['drop']}',
                        style: const TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        DateFormat('dd MMM yyyy, hh:mm a').format(shipment['dropDate']),
                        style: const TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Driver and Operator Info
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Driver: ${shipment['driver']}',
                        style: const TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '+91 ${shipment['driverPhone']}',
                        style: const TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Operator: ${shipment['operator']}',
                        style: const TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        shipment['vehicleNumber'],
                        style: const TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Vehicle Type
            Text(
              'Vehicle: ${shipment['vehicleType']}',
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showShipmentSummary(shipment),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFC90D0D)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    icon: const Icon(Icons.visibility_outlined, size: 16, color: Color(0xFFC90D0D)),
                    label: const Text(
                      'View Summary',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 12,
                        color: Color(0xFFC90D0D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showPodOptions(shipment),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC90D0D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    icon: const Icon(Icons.insert_drive_file_outlined, size: 16, color: Colors.white),
                    label: const Text(
                      'POD',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Enhanced Status Timeline
  Widget _buildStatusTimeline(String currentStatus) {
    final statuses = ['Confirmed', 'Shipped', 'Delivered'];
    final currentIndex = statuses.indexOf(currentStatus);

    return Row(
      children: List.generate(statuses.length, (index) {
        final isCompleted = index <= currentIndex;
        final isActive = index == currentIndex;

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  if (index > 0)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: index <= currentIndex
                            ? (index == currentIndex ? const Color(0xFFC90D0D) : Colors.green)
                            : Colors.grey.shade300,
                      ),
                    ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? (isActive ? const Color(0xFFC90D0D) : Colors.green)
                          : Colors.grey.shade300,
                    ),
                    child: Icon(
                      isCompleted ? Icons.check : Icons.circle,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  if (index < statuses.length - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: index < currentIndex
                            ? Colors.green
                            : Colors.grey.shade300,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                statuses[index],
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isCompleted
                      ? (isActive ? const Color(0xFFC90D0D) : Colors.green)
                      : Colors.grey,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Live Tracking Modal (Preserved)
  void _showLiveTrackingModal(Map<String, dynamic> shipment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Live Tracking',
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC90D0D),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Map Placeholder
            Container(
              height: 300,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, size: 60, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        Text(
                          'Map View - Coming Soon',
                          style: TextStyle(
                            fontFamily: 'Times New Roman',
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${shipment['pickup']} → ${shipment['drop']}',
                          style: TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Truck icon marker
                  const Positioned(
                    top: 140,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Icon(
                        Icons.local_shipping,
                        size: 40,
                        color: Color(0xFFC90D0D),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ETA Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFECEC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.access_time, color: Color(0xFFC90D0D), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Expected Arrival: 3h 45m',
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC90D0D),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Shipment Info Card
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Shipment Details',
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC90D0D),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow('Booking ID', shipment['id']),
                      _buildInfoRow('Status', 'On Route to ${shipment['drop']}'),
                      const Divider(height: 24),
                      const Text(
                        'Operator Details',
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow('Operator', shipment['operator']),
                      _buildInfoRow('Phone', '+91 ${shipment['operatorPhone']}'),
                      const Divider(height: 24),
                      const Text(
                        'Driver & Vehicle',
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow('Driver Name', shipment['driver']),
                      _buildInfoRow('Driver Phone', '+91 ${shipment['driverPhone']}'),
                      _buildInfoRow('Vehicle Number', shipment['vehicleNumber']),
                      _buildInfoRow('Vehicle Type', shipment['vehicleType']),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Calling driver...',
                                  style: TextStyle(fontFamily: 'Times New Roman'),
                                ),
                                backgroundColor: Color(0xFFC90D0D),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC90D0D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.phone, color: Colors.white),
                          label: const Text(
                            'Call Driver',
                            style: TextStyle(
                              fontFamily: 'Times New Roman',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Payment Status Modal (New)
  void _showPaymentStatusModal(Map<String, dynamic> shipment) {
    final totalAmount = shipment['totalAmount'] as int;
    final paidAmount = shipment['paid'] as int;
    final remainingAmount = totalAmount - paidAmount;
    final isFullyPaid = remainingAmount == 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Payment Status',
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC90D0D),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Booking ID
                    Center(
                      child: Text(
                        'Booking ID: ${shipment['id']}',
                        style: const TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Payment Breakdown
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          _buildPaymentRow(
                            'Total Amount',
                            '₹${totalAmount.toStringAsFixed(0)}',
                            isBold: true,
                          ),
                          const Divider(height: 24),
                          _buildPaymentRow(
                            'Paid at Pickup (${((paidAmount / totalAmount) * 100).toStringAsFixed(0)}%)',
                            '₹${paidAmount.toStringAsFixed(0)}',
                            color: Colors.green,
                          ),
                          const SizedBox(height: 12),
                          _buildPaymentRow(
                            'Remaining',
                            '₹${remainingAmount.toStringAsFixed(0)}',
                            color: isFullyPaid ? Colors.green : const Color(0xFFC90D0D),
                            isBold: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Payment Status Badge
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isFullyPaid
                              ? Colors.green.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isFullyPaid ? Colors.green : Colors.orange,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isFullyPaid ? Icons.check_circle : Icons.pending,
                              color: isFullyPaid ? Colors.green : Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isFullyPaid ? '✅ Payment Completed' : 'Partial Payment',
                              style: TextStyle(
                                fontFamily: 'Times New Roman',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isFullyPaid ? Colors.green : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Payment Method Section
                    if (!isFullyPaid) ...[
                      const Text(
                        'Payment Method',
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildPaymentMethodButton('UPI', Icons.payment),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildPaymentMethodButton('Cash', Icons.money),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Pay Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Payment gateway integration coming soon...',
                                  style: TextStyle(fontFamily: 'Times New Roman'),
                                ),
                                backgroundColor: Color(0xFFC90D0D),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC90D0D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            'Pay Remaining Amount (₹${remainingAmount.toStringAsFixed(0)})',
                            style: const TextStyle(
                              fontFamily: 'Times New Roman',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Shipment Summary Modal (Enhanced)
  void _showShipmentSummary(Map<String, dynamic> shipment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Shipment Summary - ${shipment['id']}',
                    style: const TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC90D0D),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Badge
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              '${shipment['status']} Successfully',
                              style: const TextStyle(
                                fontFamily: 'Times New Roman',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Journey Details
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Journey Details',
                            style: TextStyle(
                              fontFamily: 'Times New Roman',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFC90D0D),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildSummaryRow('Pickup Location', shipment['pickup']),
                          _buildSummaryRow('Drop Location', shipment['drop']),
                          _buildSummaryRow('Pickup Time', DateFormat('dd MMM yyyy, hh:mm a').format(shipment['pickupDate'])),
                          _buildSummaryRow('Delivery Time', DateFormat('dd MMM yyyy, hh:mm a').format(shipment['dropDate'])),
                          _buildSummaryRow('Load Type', shipment['type']),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Service Provider Details
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Service Provider',
                            style: TextStyle(
                              fontFamily: 'Times New Roman',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFC90D0D),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildSummaryRow('Operator', shipment['operator']),
                          _buildSummaryRow('Operator Phone', '+91 ${shipment['operatorPhone']}'),
                          _buildSummaryRow('Driver Name', shipment['driver']),
                          _buildSummaryRow('Driver Phone', '+91 ${shipment['driverPhone']}'),
                          _buildSummaryRow('Vehicle Number', shipment['vehicleNumber']),
                          _buildSummaryRow('Vehicle Type', shipment['vehicleType']),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Payment Details
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Payment Details',
                            style: TextStyle(
                              fontFamily: 'Times New Roman',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFC90D0D),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildSummaryRow('Total Amount', '₹${shipment['totalAmount']}'),
                          _buildSummaryRow('Amount Paid', '₹${shipment['paid']}'),
                          _buildSummaryRow('Payment Status', 'Completed'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // POD Modal
  void _showPodOptions(Map<String, dynamic> shipment) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFC90D0D).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.insert_drive_file_outlined, color: Color(0xFFC90D0D), size: 40),
            ),
            const SizedBox(height: 16),
            const Text(
              'POD',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose how you want to receive the proof of delivery for ${shipment['id']}',
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Sharing POD...',
                            style: TextStyle(fontFamily: 'Times New Roman'),
                          ),
                          backgroundColor: Color(0xFFC90D0D),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFC90D0D)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.share, color: Color(0xFFC90D0D)),
                    label: const Text(
                      'Share',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        color: Color(0xFFC90D0D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'POD download started...',
                            style: TextStyle(fontFamily: 'Times New Roman'),
                          ),
                          backgroundColor: Color(0xFFC90D0D),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC90D0D),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.download_outlined, color: Colors.white),
                    label: const Text(
                      'Download',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Emailing POD...',
                      style: TextStyle(fontFamily: 'Times New Roman'),
                    ),
                    backgroundColor: Color(0xFFC90D0D),
                  ),
                );
              },
              icon: const Icon(Icons.email_outlined, color: Color(0xFFC90D0D)),
              label: const Text(
                'Email POD',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  color: Color(0xFFC90D0D),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Methods
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value, {Color? color, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color ?? Colors.black87,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodButton(String label, IconData icon) {
    return OutlinedButton.icon(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFFC90D0D)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      icon: Icon(icon, color: const Color(0xFFC90D0D), size: 20),
      label: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Times New Roman',
          fontSize: 14,
          color: Color(0xFFC90D0D),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          const Text(': ', style: TextStyle(color: Colors.grey)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}