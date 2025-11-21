import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/colors.dart';

import '../../models/shipment.dart';

class LiveTrackingScreen extends StatelessWidget {
  const LiveTrackingScreen({super.key, required this.shipment});

  final Shipment shipment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Live Tracking',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {
              // TODO: Implement share
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Map Section
            _buildMapSection(),
            
            // Content Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // In Transit Status
                  _buildStatusCard(context),
                  const SizedBox(height: 16),
                  
                  // Route Details
                  _buildRouteCard(),
                  const SizedBox(height: 16),
                  
                  // Contacts
                  _buildContactsCard(),
                  const SizedBox(height: 16),
                  
                  // Payment Status
                  _buildPaymentStatusCard(),
                  const SizedBox(height: 16),
                  
                  // Goods Details
                  _buildGoodsDetailsCard(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: 300,
      width: double.infinity,
      color: const Color(0xFF4DB6AC), // Teal color from reference
      child: Stack(
        children: [
          // Placeholder for map visual - In a real app, use GoogleMap
          Center(
            child: Icon(
              Icons.map,
              size: 100,
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
          // Overlay Card
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Arriving in 25 mins',
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      color: AppColors.primaryRed,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Driver is on the way to the dropoff location.',
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      color: Color(0xFF777777),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: 0.6,
                      backgroundColor: AppColors.primaryRed.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Row(
            children: [
              const Icon(Icons.local_shipping, color: AppColors.primaryRed),
              const SizedBox(width: 12),
              const Text(
                'In transit',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryRed,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  _buildTimelineItem('Assigned', 'Completed', true, isFirst: true),
                  _buildTimelineItem('Driver en route', 'Completed', true),
                  _buildTimelineItem('Reached pickup', 'Completed', true),
                  _buildTimelineItem('Loaded', 'Completed', true),
                  _buildTimelineItem('In Transit', 'Current Stage', false, isCurrent: true),
                  _buildTimelineItem('Approaching destination', 'Upcoming', false),
                  _buildTimelineItem('Unloaded', 'Upcoming', false),
                  _buildTimelineItem('POD & Payment', 'Upcoming', false, isLast: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Visual
          Column(
            children: [
              const Icon(Icons.radio_button_checked, color: AppColors.primaryRed, size: 20),
              Container(
                width: 2,
                height: 40,
                color: Colors.grey[300], // Dashed line placeholder
              ),
              const Icon(Icons.location_on, color: Colors.grey, size: 20),
            ],
          ),
          const SizedBox(width: 12),
          // Addresses
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAddressItem('FROM', 'MIDC, Taloja, Navi Mumbai, Maharashtra 410208'), // Using static data to match reference or shipment.origin
                const SizedBox(height: 24),
                _buildAddressItem('TO', 'Gala No. 5, Sector 19C, Vashi, Navi Mumbai 400705'), // Using static data to match reference or shipment.destination
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressItem(String label, String address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 10,
            color: Color(0xFF999999),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          address,
          style: const TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 13,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildContactsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contacts',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          _buildContactItem('Sender', '+91 98765 43210', true),
          const Divider(height: 24, color: Color(0xFFEEEEEE)),
          _buildContactItem('Receiver', '+91 87654 32109', true),
          const Divider(height: 24, color: Color(0xFFEEEEEE)),
          _buildContactItem('${shipment.driver.name} (Driver)', shipment.driver.phone, false),
        ],
      ),
    );
  }

  Widget _buildContactItem(String name, String phone, bool isRed) {
    return Row(
      children: [
        if (!isRed) ...[
           CircleAvatar(
             radius: 18,
             backgroundImage: const AssetImage('assets/images/driver_avatar.png'), // Placeholder
             backgroundColor: Colors.grey[200],
             child: const Icon(Icons.person, color: Colors.grey),
           ),
           const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                phone,
                style: const TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 12,
                  color: Color(0xFF777777),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isRed ? AppColors.primaryRed : AppColors.primaryRed.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              Icons.call,
              color: isRed ? Colors.white : AppColors.primaryRed,
              size: 18,
            ),
            onPressed: () => _launchUrl('tel:$phone'),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Status',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 20),
              SizedBox(width: 8),
              Text(
                'Paid Online - ₹12,500',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoodsDetailsCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: const Text(
            'Goods Details',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  _buildDetailRow('Good Category:', shipment.category),
                  const SizedBox(height: 12),
                  _buildDetailRow('Quantity:', '${shipment.weightTons} tons'),
                  const SizedBox(height: 12),
                  _buildDetailRow('Tyre Count:', '${shipment.tyres} tyres'),
                  const SizedBox(height: 12),
                  _buildDetailRow('Body Type:', shipment.bodyType),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String title, String subtitle, bool isCompleted, {bool isCurrent = false, bool isFirst = false, bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                if (!isFirst) Expanded(child: Container(width: 2, color: isCompleted ? Colors.green : Colors.grey[300])),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green : (isCurrent ? AppColors.primaryRed : Colors.white),
                    shape: BoxShape.circle,
                    border: isCompleted || isCurrent ? null : Border.all(color: Colors.grey[400]!),
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : (isCurrent ? Icons.local_shipping : Icons.circle),
                    size: 14,
                    color: isCompleted || isCurrent ? Colors.white : Colors.grey[400],
                  ),
                ),
                if (!isLast) Expanded(child: Container(width: 2, color: isCompleted ? Colors.green : Colors.grey[300])),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isCurrent ? AppColors.primaryRed : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 12,
                      color: isCurrent ? AppColors.primaryRed : (isCompleted ? Colors.green : Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Times New Roman',
            color: Color(0xFF777777),
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
