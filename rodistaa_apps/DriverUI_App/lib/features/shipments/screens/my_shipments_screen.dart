import 'package:flutter/material.dart';

import '../../../screens/shipments_screen.dart';
import '../../../services/shipment_api.dart';

class MyShipmentsScreen extends StatelessWidget {
  final String? initialTab;

  const MyShipmentsScreen({super.key, this.initialTab});

  @override
  Widget build(BuildContext context) {
    return ShipmentsScreen(
      key: ValueKey(initialTab),
      initialStatus: _mapTab(initialTab),
    );
  }

  ShipmentStatusFilter _mapTab(String? tab) {
    switch (tab) {
      case 'completed':
        return ShipmentStatusFilter.completed;
      case 'all':
        return ShipmentStatusFilter.all;
      default:
        return ShipmentStatusFilter.ongoing;
    }
  }
}
