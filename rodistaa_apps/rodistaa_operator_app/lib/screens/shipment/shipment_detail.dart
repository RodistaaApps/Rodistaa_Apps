// RODISTAA THEME shipment detail screen.
// TODO: Attach live map + telematics feed when backend streams are ready.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';
import '../../models/shipment.dart';
import '../../services/mock_shipments_service.dart';
import '../../widgets/shipment_timeline.dart';
import '../../widgets/confirmation_dialog.dart';

class ShipmentDetailScreen extends StatefulWidget {
  const ShipmentDetailScreen({super.key, required this.shipmentId});

  final String shipmentId;

  @override
  State<ShipmentDetailScreen> createState() => _ShipmentDetailScreenState();
}

class _ShipmentDetailScreenState extends State<ShipmentDetailScreen> {
  final _service = MockShipmentsService.instance;
  late Future<Shipment> _futureShipment;

  @override
  void initState() {
    super.initState();
    _futureShipment = _service.fetchShipmentById(widget.shipmentId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Shipment>(
      future: _futureShipment,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final shipment = snapshot.data!;
        final formatter = DateFormat('dd MMM, hh:mm a');
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            foregroundColor: Colors.black87,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _popOrGoHome(context),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LOAD #${shipment.id}',
                  style: const TextStyle(
                    fontFamily: 'Times New Roman',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Updated ${formatter.format(shipment.lastUpdated)}',
                  style: const TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 12,
                    color: Color(0xFF555555),
                  ),
                ),
              ],
            ),
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.black87),
                onSelected: (value) {
                  if (value == 'report_exception') {
                    _showReportExceptionModal(context);
                  } else if (value == 'mark_loaded') {
                    _showMarkLoadedModal(context);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'report_exception',
                    child: Text(
                      'Report Exception',
                      style: TextStyle(fontFamily: 'Times New Roman'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'mark_loaded',
                    child: Text(
                      'Mark as Loaded',
                      style: TextStyle(fontFamily: 'Times New Roman'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RouteBlock(shipment: shipment),
                const SizedBox(height: 16),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ShipmentTimeline(stages: shipment.timelineStages),
                  ),
                ),
                const SizedBox(height: 16),
                _DriverBlock(driver: shipment.driver, shipmentId: shipment.id),
                const SizedBox(height: 16),
                _PaymentsBlock(
                  advance: shipment.estimatedFuelCost ?? 0,
                  pending: shipment.tollEstimate ?? 0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showReportExceptionModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Report Exception',
        message: 'Report an exception for this shipment?',
        confirmLabel: 'Report',
        onConfirm: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Exception reported')),
          );
        },
      ),
    );
  }

  void _showMarkLoadedModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Mark as Loaded',
        message: 'Mark this shipment as loaded?',
        confirmLabel: 'Mark Loaded',
        onConfirm: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Shipment marked as loaded')),
          );
        },
      ),
    );
  }
}

void _popOrGoHome(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  } else {
    context.go('/shipments');
  }
}

class _RouteBlock extends StatelessWidget {
  const _RouteBlock({required this.shipment});

  final Shipment shipment;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Highlighted pickup → drop (bold red text)
            Text(
              '${shipment.origin} → ${shipment.destination}',
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: AppColors.primaryRed,
              ),
            ),
            const SizedBox(height: 12),
            // Small pills for Distance / Weight / Body / Tyre
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoPill(
                  icon: Icons.straighten,
                  label: '${shipment.distanceKm.toStringAsFixed(0)} km',
                ),
                _InfoPill(
                  icon: Icons.scale,
                  label: '${shipment.weightTons.toStringAsFixed(1)}T',
                ),
                _InfoPill(
                  icon: Icons.inventory_2,
                  label: shipment.bodyType,
                ),
                _InfoPill(
                  icon: Icons.settings,
                  label: '${shipment.tyres} tyres',
                ),
              ],
            ),
            const SizedBox(height: 12),
            _MapPlaceholder(lastPing: shipment.lastUpdated),
          ],
        ),
      ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder({required this.lastPing});

  final DateTime lastPing;

  @override
  Widget build(BuildContext context) {
    final diff = DateTime.now().difference(lastPing);
    final lastPingText = diff.inMinutes < 1
        ? 'just now'
        : diff.inMinutes < 60
            ? '${diff.inMinutes}m ago'
            : '${diff.inHours}h ago';

    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFFEDEDED), Color(0xFFDCDCDC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          const Center(
            child: Icon(Icons.local_shipping, size: 48, color: AppColors.primaryRed),
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Last ping $lastPingText',
                style: const TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 11,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // TODO: integrate Google Maps / Mapbox view here.
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.primaryRed.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primaryRed),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryRed,
            ),
          ),
        ],
      ),
    );
  }
}

class _DriverBlock extends StatelessWidget {
  const _DriverBlock({required this.driver, required this.shipmentId});

  final ShipmentDriver driver;
  final String shipmentId;

  @override
  Widget build(BuildContext context) {
    final initials = driver.initials;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.primaryRed.withValues(alpha: 0.12),
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryRed,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver.name,
                      style: const TextStyle(
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      driver.phone,
                      style: const TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 13,
                        color: Color(0xFF555555),
                      ),
                    ),
                    Text(
                      '${driver.truckNumber} • ${driver.tyreCount} tyres',
                      style: const TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 12,
                        color: Color(0xFF777777),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _DriverActionButton(
                    icon: Icons.call,
                    label: 'Call',
                    onPressed: () => _launch(Uri.parse('tel:${driver.phone}')),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _DriverActionButton(
                    icon: Icons.message,
                    label: 'Message',
                    onPressed: () => _launch(Uri.parse('sms:${driver.phone}')),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _DriverActionButton(
                    icon: Icons.my_location,
                    label: 'Live Track',
                    onPressed: () => context.push(
                      '/shipments/${Uri.encodeComponent(shipmentId)}/live-track',
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

  Future<void> _launch(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _DriverActionButton extends StatelessWidget {
  const _DriverActionButton({required this.icon, required this.label, required this.onPressed});

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: Icon(icon, size: 18, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _PaymentsBlock extends StatelessWidget {
  const _PaymentsBlock({required this.advance, required this.pending});

  final double advance;
  final double pending;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: _PaymentStat(label: 'Advance paid', value: advance),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PaymentStat(label: 'Pending balance', value: pending),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentStat extends StatelessWidget {
  const _PaymentStat({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 12,
            color: Color(0xFF777777),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value == 0 ? '₹0' : '₹${value.toStringAsFixed(0)}',
          style: const TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

