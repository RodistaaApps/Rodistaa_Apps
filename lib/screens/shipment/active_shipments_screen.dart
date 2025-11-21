import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/shipment.dart';
import 'live_tracking_screen.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/modern_bottom_nav.dart';

class ActiveShipmentsScreen extends StatefulWidget {
  const ActiveShipmentsScreen({super.key});

  @override
  State<ActiveShipmentsScreen> createState() => _ActiveShipmentsScreenState();
}

class _ActiveShipmentsScreenState extends State<ActiveShipmentsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Dummy data for visualization
  final List<Shipment> _allShipments = [
    // Active Shipments
    Shipment(
      id: '1',
      origin: 'Springfield',
      destination: 'Shelbyville',
      category: 'Electronics',
      weightTons: 5.2,
      bodyType: 'Container',
      tyres: 10,
      ftlOrPtl: 'FTL',
      timerEndsAt: DateTime.now().add(const Duration(hours: 2)),
      driver: const ShipmentDriver(
        name: 'Homer Simpson',
        phone: '555-1234',
        truckNumber: 'TRK-001',
        tyreCount: 10,
      ),
      status: ShipmentStatus.ongoing,
      timelineStages: [],
      lastUpdated: DateTime.now(),
      distanceKm: 150.0,
    ),
    Shipment(
      id: '2',
      origin: 'Capital City',
      destination: 'Ogdenville',
      category: 'Construction Materials',
      weightTons: 12.5,
      bodyType: 'Open Body',
      tyres: 18,
      ftlOrPtl: 'FTL',
      timerEndsAt: DateTime.now().add(const Duration(hours: 5)),
      driver: const ShipmentDriver(
        name: 'Barney Gumble',
        phone: '555-5678',
        truckNumber: 'TRK-002',
        tyreCount: 18,
      ),
      status: ShipmentStatus.ongoing,
      timelineStages: [],
      lastUpdated: DateTime.now(),
      distanceKm: 300.0,
    ),
    // Completed Shipments
    Shipment(
      id: '3',
      origin: 'Mumbai',
      destination: 'Delhi',
      category: 'Textiles',
      weightTons: 8.0,
      bodyType: 'Closed Body',
      tyres: 12,
      ftlOrPtl: 'PTL',
      timerEndsAt: DateTime.now().subtract(const Duration(days: 2)),
      driver: const ShipmentDriver(
        name: 'Moe Szyslak',
        phone: '555-9012',
        truckNumber: 'TRK-003',
        tyreCount: 12,
      ),
      status: ShipmentStatus.completed,
      timelineStages: [],
      lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
      distanceKm: 1400.0,
    ),
    Shipment(
      id: '4',
      origin: 'Bangalore',
      destination: 'Chennai',
      category: 'Machinery',
      weightTons: 15.0,
      bodyType: 'Flatbed',
      tyres: 22,
      ftlOrPtl: 'FTL',
      timerEndsAt: DateTime.now().subtract(const Duration(days: 5)),
      driver: const ShipmentDriver(
        name: 'Apu Nahasapeemapetilon',
        phone: '555-3456',
        truckNumber: 'TRK-004',
        tyreCount: 22,
      ),
      status: ShipmentStatus.completed,
      timelineStages: [],
      lastUpdated: DateTime.now().subtract(const Duration(days: 5)),
      distanceKm: 350.0,
    ),
  ];

  List<Shipment> get _activeShipments => 
      _allShipments.where((s) => s.status == ShipmentStatus.ongoing).toList();
  
  List<Shipment> get _completedShipments => 
      _allShipments.where((s) => s.status == ShipmentStatus.completed).toList();

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
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text('Shipments'),
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
            onPressed: () {
              // TODO: Implement refresh
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryRed,
          unselectedLabelColor: AppColors.muteGray,
          indicatorColor: AppColors.primaryRed,
          labelStyle: const TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          tabs: const [
            Tab(text: 'Active Shipments'),
            Tab(text: 'Completed Shipments'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildShipmentsList(_activeShipments, isActive: true),
          _buildShipmentsList(_completedShipments, isActive: false),
        ],
      ),
      bottomNavigationBar: ModernBottomNav(
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/bookings');
              break;
            case 2:
              context.go('/bids');
              break;
            case 3:
              // Already on shipments
              break;
            case 4:
              context.push('/menu');
              break;
          }
        },
      ),
    );
  }

  Widget _buildShipmentsList(List<Shipment> shipments, {required bool isActive}) {
    if (shipments.isEmpty) {
      return _buildEmptyState(isActive);
    }
    
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: shipments.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildShipmentCard(shipments[index], isActive: isActive);
      },
    );
  }

  Widget _buildShipmentCard(Shipment shipment, {required bool isActive}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Row: Truck Info & FTL/PTL
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(
                  Icons.circle,
                  color: isActive ? Colors.green : Colors.grey,
                  size: 12,
                ),
                const SizedBox(width: 8),
                Text(
                  shipment.driver.truckNumber,
                  style: AppTextStyles.title.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.primaryRed.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    shipment.ftlOrPtl,
                    style: const TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: AppColors.primaryRed,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Second Row: Route Display
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Text(
                  shipment.origin,
                  style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.arrow_forward, color: AppColors.muteGray, size: 16),
                ),
                Text(
                  shipment.destination,
                  style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.borderGray),
          
          // Shipment Details Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailItem(
                        icon: Icons.category_outlined,
                        label: 'Goods Category',
                        value: shipment.category,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailItem(
                        icon: Icons.tire_repair,
                        label: 'Tyre Count',
                        value: '${shipment.tyres} Tyres',
                      ),
                    ],
                  ),
                ),
                // Right Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailItem(
                        icon: Icons.scale_outlined,
                        label: 'Quantity',
                        value: '${shipment.weightTons} Tons',
                      ),
                      const SizedBox(height: 12),
                      _buildDetailItem(
                        icon: Icons.local_shipping_outlined,
                        label: 'Body Type',
                        value: shipment.bodyType,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1, color: AppColors.borderGray),

          // Action Row
          if (isActive)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Live Track Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LiveTrackingScreen(shipment: shipment),
                          ),
                        );
                      },
                      icon: const Icon(Icons.location_on_outlined, size: 18),
                      label: const Text('Live Track'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Call Driver Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement call driver
                      },
                      icon: const Icon(Icons.phone_outlined, size: 18),
                      label: const Text('Call Driver'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF1F1F1),
                        foregroundColor: AppColors.textPrimary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (!isActive)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement view details
                  },
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('View Details'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({required IconData icon, required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.muteGray),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.muteGray),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool isActive) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 64, color: AppColors.muteGray.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            isActive ? 'No Active Shipments' : 'No Completed Shipments',
            style: AppTextStyles.title.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            isActive 
                ? 'You have no active shipments at the moment.'
                : 'You have no completed shipments yet.',
            style: AppTextStyles.body.copyWith(color: AppColors.muteGray),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
