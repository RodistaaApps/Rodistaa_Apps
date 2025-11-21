import 'package:flutter/material.dart';

import '../models/shipment_model.dart';

class ShipmentDetailsScreen extends StatelessWidget {
  final Shipment shipment;

  const ShipmentDetailsScreen({
    super.key,
    required this.shipment,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipment ${shipment.shipmentId}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _Section(
            title: 'Status',
            children: [
              _InfoRow(label: 'Current status', value: shipment.statusLabel),
              _InfoRow(
                label: 'Started at',
                value: _formatDate(shipment.startedAt),
              ),
              _InfoRow(
                label: 'Completed at',
                value: shipment.completedAt != null
                    ? _formatDate(shipment.completedAt!)
                    : 'In progress',
              ),
            ],
          ),
          const SizedBox(height: 24),
          _Section(
            title: 'Pickup',
            children: [
              _InfoRow(label: 'Address', value: shipment.pickupAddress),
              _InfoRow(label: 'Contact', value: shipment.pickupContact),
            ],
          ),
          const SizedBox(height: 24),
          _Section(
            title: 'Drop',
            children: [
              _InfoRow(label: 'Address', value: shipment.dropAddress),
              _InfoRow(label: 'Contact', value: shipment.dropContact),
            ],
          ),
          const SizedBox(height: 24),
          _Section(
            title: 'Tracking',
            children: [
              _InfoRow(
                label: 'Distance',
                value:
                    '${shipment.distanceCoveredKm.toStringAsFixed(1)} / ${shipment.distanceKm.toStringAsFixed(1)} km',
              ),
              _InfoRow(
                label: 'Progress',
                value:
                    '${(shipment.progressPercentage * 100).toStringAsFixed(0)}%',
              ),
              _InfoRow(
                label: 'Live tracking',
                value: shipment.isTrackingLive ? 'Enabled' : 'Disabled',
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
