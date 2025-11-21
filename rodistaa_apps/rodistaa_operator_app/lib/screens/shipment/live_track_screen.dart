// RODISTAA THEME Live Track screen – production-ready implementation

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';
import '../../models/shipment.dart';
import '../../providers/live_track_provider.dart';
import '../../widgets/map_widget.dart';
import '../../widgets/people_card.dart';
import '../../widgets/shipment_actions.dart';
import '../../widgets/shipment_timeline.dart';

class LiveTrackScreen extends StatelessWidget {
  const LiveTrackScreen({super.key, required this.shipmentId});

  final String shipmentId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LiveTrackProvider()..initialize(shipmentId),
      child: const _LiveTrackBody(),
    );
  }
}

class _LiveTrackBody extends StatefulWidget {
  const _LiveTrackBody();

  @override
  State<_LiveTrackBody> createState() => _LiveTrackBodyState();
}

class _LiveTrackBodyState extends State<_LiveTrackBody> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LiveTrackProvider>();

    if (provider.isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: AppColors.primaryRed)),
      );
    }

    if (provider.hasError ||
        provider.shipment == null ||
        provider.pickupLatLng == null ||
        provider.dropLatLng == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white70, size: 42),
              const SizedBox(height: 12),
              Text(
                provider.errorMessage ?? 'Unable to load live tracking',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back to Shipments'),
              ),
            ],
          ),
        ),
      );
    }

    final shipment = provider.shipment!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: Text(
          'Live track',
          style: const TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SheetHeader(shipment: shipment, state: provider),
                      const SizedBox(height: 12),
                      _SummaryStrip(shipment: shipment, state: provider),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                _MiniMapCard(
                  provider: provider,
                  onOpenFullMap: () => _openFullMap(provider),
                ),
              ],
            ),
            const SizedBox(height: 20),
            PeopleCard(
              driver: shipment.driver,
              sender: provider.sender,
              receiver: provider.receiver,
              isDriverOnline: !provider.isOffline,
              onCallDriver: () => _launchUrl('tel:${shipment.driver.phone}'),
              onMessageDriver: () => _launchUrl('sms:${shipment.driver.phone}'),
              onShare: () => _shareLink(context, shipment.id),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Shipment timeline',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ShipmentTimeline(stages: shipment.timelineStages),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ShipmentActionsCard(
              advancePaid: provider.advancePaid,
              pendingBalance: provider.pendingBalance,
              onMarkLoaded: provider.canMarkLoaded ? () => _confirmAction(context, 'Mark as Loaded', provider.markLoaded) : null,
              onConfirmUnloaded:
                  provider.canConfirmUnloaded ? () => _confirmAction(context, 'Confirm Unloaded', provider.confirmUnloaded) : null,
              onRequestPayment: provider.canRequestPayment ? () => _confirmAction(context, 'Request Payment', provider.requestPayment) : null,
              onRecordCash: provider.canRecordCash ? () => _confirmAction(context, 'Record Cash', provider.recordCash) : null,
              isBusy: provider.isPerformingAction,
            ),
          ],
        ),
      ),
    );
  }

  void _openFullMap(LiveTrackProvider provider) {
    if (kIsWeb) {
      final target = provider.driverPosition ?? provider.pickupLatLng;
      if (target == null) return;
      final url = Uri.encodeFull('https://www.google.com/maps/search/?api=1&query=${target.latitude},${target.longitude}');
      _launchUrl(url);
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: provider,
          child: const _FullMapScreen(),
        ),
      ),
    );
  }

  static Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  static void _shareLink(BuildContext context, String shipmentId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share link: https://rodistaa.com/track/$shipmentId'),
        action: SnackBarAction(
          label: 'Copy',
          onPressed: () {},
        ),
      ),
    );
  }

  static Future<void> _confirmAction(
    BuildContext context,
    String label,
    Future<bool> Function() action,
  ) async {
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(label),
        content: Text('Are you sure you want to $label?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryRed, foregroundColor: Colors.white),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      final success = await action();
      messenger.showSnackBar(
        SnackBar(content: Text(success ? '$label completed' : '$label failed')),
      );
    }
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.shipment, required this.state});

  final Shipment shipment;
  final LiveTrackProvider state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CircleButton(icon: Icons.arrow_back, onTap: () => Navigator.of(context).pop(), tooltip: 'Back'),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                shipment.id,
                style: const TextStyle(
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              Text(
                'Last updated ${DateFormat('dd MMM, hh:mm a').format(shipment.lastUpdated)}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF777777)),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: state.statusColor.withValues(alpha: 0.13),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            state.statusLabel,
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: state.statusColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip({required this.shipment, required this.state});

  final Shipment shipment;
  final LiveTrackProvider state;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  shipment.origin,
                  style: const TextStyle(
                    fontFamily: 'Times New Roman',
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryRed,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.arrow_forward, size: 16, color: AppColors.primaryRed),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    shipment.destination,
                    style: const TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
                _Badge(label: shipment.ftlOrPtl),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${shipment.category} • ${shipment.weightTons.toStringAsFixed(1)}T',
              style: const TextStyle(fontFamily: 'Times New Roman', fontSize: 13, color: Color(0xFF666666)),
            ),
            const SizedBox(height: 8),
            Text(
              'Body ${shipment.bodyType} • ${shipment.tyres} tyres • ${shipment.distanceKm.toStringAsFixed(0)} km',
              style: const TextStyle(fontFamily: 'Times New Roman', fontSize: 13, color: Color(0xFF777777)),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Advance ₹${state.advancePaid.toStringAsFixed(0)}   |   Pending ₹${state.pendingBalance.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: IconButton(
        icon: Icon(icon, color: AppColors.primaryRed),
        tooltip: tooltip,
        onPressed: onTap,
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Times New Roman',
          fontSize: 12,
          color: AppColors.primaryRed,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MiniMapCard extends StatelessWidget {
  const _MiniMapCard({required this.provider, required this.onOpenFullMap});

  final LiveTrackProvider provider;
  final VoidCallback onOpenFullMap;

  @override
  Widget build(BuildContext context) {
    final hasCoordinates = provider.pickupLatLng != null && provider.dropLatLng != null;
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: hasCoordinates && !kIsWeb
                  ? AbsorbPointer(
                      child: LiveTrackMap(
                        pickup: provider.pickupLatLng!,
                        drop: provider.dropLatLng!,
                        completedRoute: provider.completedRoute.isNotEmpty
                            ? provider.completedRoute
                            : [provider.pickupLatLng!, provider.driverPosition ?? provider.pickupLatLng!],
                        remainingRoute: provider.remainingRoute.isNotEmpty
                            ? provider.remainingRoute
                            : [provider.driverPosition ?? provider.pickupLatLng!, provider.dropLatLng!],
                        driverPosition: provider.driverPosition ?? provider.pickupLatLng,
                        driverHeading: provider.driverHeading,
                        isFollowing: false,
                        lastPing: provider.lastPing,
                        onMapPanStart: () {},
                      ),
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.map_outlined, color: AppColors.primaryRed, size: 36),
                          SizedBox(height: 8),
                          Text(
                            'Map preview',
                            style: TextStyle(
                              fontFamily: 'Times New Roman',
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryRed,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onOpenFullMap,
            icon: const Icon(Icons.open_in_full, color: AppColors.primaryRed),
            label: const Text(
              'Open full map',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.w700,
                color: AppColors.primaryRed,
              ),
            ),
          ),
          if (provider.lastPing != null)
            Text(
              'Last ping ${DateFormat('hh:mm a').format(provider.lastPing!)}',
              style: const TextStyle(fontSize: 11, color: Color(0xFF666666)),
            ),
        ],
      ),
    );
  }
}

class _FullMapScreen extends StatefulWidget {
  const _FullMapScreen();

  @override
  State<_FullMapScreen> createState() => _FullMapScreenState();
}

class _FullMapScreenState extends State<_FullMapScreen> {
  GoogleMapController? _controller;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LiveTrackProvider>();
    final pickup = state.pickupLatLng;
    final drop = state.dropLatLng;

    if (pickup == null || drop == null) {
      return const Scaffold(
        body: Center(child: Text('Map unavailable')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(state.shipment?.id ?? 'Live map'),
      ),
      body: LiveTrackMap(
        pickup: pickup,
        drop: drop,
        completedRoute: state.completedRoute.isNotEmpty
            ? state.completedRoute
            : [pickup, state.driverPosition ?? pickup],
        remainingRoute: state.remainingRoute.isNotEmpty
            ? state.remainingRoute
            : [state.driverPosition ?? pickup, drop],
        driverPosition: state.driverPosition ?? pickup,
        driverHeading: state.driverHeading,
        isFollowing: state.isFollowing,
        lastPing: state.lastPing,
        onMapPanStart: state.stopFollowing,
        onControllerReady: (controller) => _controller = controller,
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'follow',
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primaryRed,
            onPressed: state.toggleFollow,
            child: Icon(state.isFollowing ? Icons.my_location : Icons.location_disabled),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.small(
            heroTag: 'center',
            backgroundColor: AppColors.primaryRed,
            foregroundColor: Colors.white,
            onPressed: () {
              final driver = state.driverPosition ?? pickup;
              _controller?.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: driver, zoom: 14, bearing: state.driverHeading),
                ),
              );
            },
            child: const Icon(Icons.center_focus_strong),
          ),
        ],
      ),
    );
  }
}
