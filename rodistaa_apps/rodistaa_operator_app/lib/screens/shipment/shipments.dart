// RODISTAA THEME shipments list screen (operator monitor view).
// TODO: Swap mock service with REST-backed repository once available.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/colors.dart';
import '../../models/shipment.dart';
import '../../services/mock_shipments_service.dart';
import '../../widgets/shipment_card.dart';

class ShipmentsScreen extends StatefulWidget {
  const ShipmentsScreen({super.key});

  @override
  State<ShipmentsScreen> createState() => _ShipmentsScreenState();
}

class _ShipmentsScreenState extends State<ShipmentsScreen> {
  final _service = MockShipmentsService.instance;
  final TextEditingController _searchController = TextEditingController();

  List<Shipment> _shipments = const [];
  bool _isLoading = true;
  ShipmentStatus _activeTab = ShipmentStatus.ongoing;

  @override
  void initState() {
    super.initState();
    _loadShipments();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadShipments() async {
    setState(() => _isLoading = true);
    final data = await _service.fetchShipments();
    if (!mounted) return;
    setState(() {
      _shipments = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredShipments();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => _popOrGoHome(context),
        ),
        title: const Text(
          'Shipments',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: _SearchField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _Tabs(
              active: _activeTab,
              onChanged: (status) => setState(() => _activeTab = status),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadShipments,
                    child: filtered.isEmpty
                        ? const Center(
                            child: Text(
                              'No shipments yet.',
                              style: TextStyle(
                                fontFamily: 'Times New Roman',
                                color: Color(0xFF777777),
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final shipment = filtered[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: ShipmentCard(
                                  shipment: shipment,
                                  onLiveTrack: () => context.push(
                                    '/shipments/${Uri.encodeComponent(shipment.id)}/live-track',
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  List<Shipment> _filteredShipments() {
    final query = _searchController.text.trim().toLowerCase();
    return _shipments.where((shipment) {
      final matchesTab = shipment.status == _activeTab;
      if (!matchesTab) return false;
      if (query.isEmpty) return true;
      return shipment.id.toLowerCase().contains(query) ||
          shipment.origin.toLowerCase().contains(query) ||
          shipment.destination.toLowerCase().contains(query);
    }).toList();
  }
}

void _popOrGoHome(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  } else {
    context.go('/home');
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: const InputDecoration(
          hintText: 'Search shipments...',
          hintStyle: TextStyle(fontFamily: 'Times New Roman'),
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.active, required this.onChanged});

  final ShipmentStatus active;
  final ValueChanged<ShipmentStatus> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TabPill(
            label: 'Ongoing',
            active: active == ShipmentStatus.ongoing,
            onTap: () => onChanged(ShipmentStatus.ongoing),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _TabPill(
            label: 'Completed',
            active: active == ShipmentStatus.completed,
            onTap: () => onChanged(ShipmentStatus.completed),
          ),
        ),
      ],
    );
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: active ? AppColors.primaryRed : const Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w700,
              color: active ? Colors.white : const Color(0xFF555555),
            ),
          ),
        ),
      ),
    );
  }
}

