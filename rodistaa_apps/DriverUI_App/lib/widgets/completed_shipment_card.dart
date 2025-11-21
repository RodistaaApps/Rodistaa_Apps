import 'package:flutter/material.dart';

import '../theme.dart';

class CompletedShipmentCard extends StatelessWidget {
  const CompletedShipmentCard({
    super.key,
    required this.shipment,
    this.onTap,
  });

  final Map<String, dynamic> shipment;
  final VoidCallback? onTap;

  String get _shipmentId => shipment['id']?.toString() ?? '--';
  double get _rating => (shipment['rating'] as num?)?.toDouble() ?? 0;
  String get _pickupAddress => shipment['pickupAddress']?.toString() ?? '--';
  String get _dropAddress => shipment['dropAddress']?.toString() ?? '--';
  String get _pickupTime => shipment['pickupTime']?.toString() ?? '--';
  String get _dropTime => shipment['dropTime']?.toString() ?? '--';
  String get _loadCategory =>
      shipment['loadCategory']?.toString() ?? 'Full Truck';

  @override
  Widget build(BuildContext context) {
    final textTheme = RodistaaTheme.serifTextTheme(Theme.of(context).textTheme);
    return Semantics(
      label: 'Completed shipment $_shipmentId',
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(RodistaaTheme.cardRadius),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                            Text(
                              'ID: #$_shipmentId',
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: RodistaaTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: RodistaaTheme.gapS),
                            _LoadChip(label: _loadCategory),
                          ],
                        ),
                      ),
                      _RatingStars(rating: _rating),
                    ],
                  ),
                  const SizedBox(height: RodistaaTheme.gapL),
                  _AddressRow(
                    icon: Icons.home,
                    iconColor: RodistaaTheme.rodistaaRed,
                    address: _pickupAddress,
                    timestamp: _pickupTime,
                    semanticsLabel: 'Pickup at $_pickupAddress on $_pickupTime',
                  ),
                  const _TimelineDivider(),
                  _AddressRow(
                    icon: Icons.location_on,
                    iconColor: RodistaaTheme.rodistaaRed,
                    address: _dropAddress,
                    timestamp: _dropTime,
                    semanticsLabel: 'Drop at $_dropAddress on $_dropTime',
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 6,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: RodistaaTheme.rodistaaRed,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadChip extends StatelessWidget {
  const _LoadChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: RodistaaTheme.rodistaaRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_shipping,
              size: 16, color: RodistaaTheme.rodistaaRed),
          const SizedBox(width: RodistaaTheme.gapXS),
          Text(
            label,
            style: const TextStyle(
              color: RodistaaTheme.rodistaaRed,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingStars extends StatelessWidget {
  const _RatingStars({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final filled = rating >= index + 1;
        return Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Icon(
            Icons.star,
            size: 18,
            color: filled ? RodistaaTheme.rodistaaRed : RodistaaTheme.divider,
            semanticLabel: filled ? 'Filled star' : 'Empty star',
          ),
        );
      }),
    );
  }
}

class _AddressRow extends StatelessWidget {
  const _AddressRow({
    required this.icon,
    required this.iconColor,
    required this.address,
    required this.timestamp,
    required this.semanticsLabel,
  });

  final IconData icon;
  final Color iconColor;
  final String address;
  final String timestamp;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = RodistaaTheme.serifTextTheme(Theme.of(context).textTheme);
    return Semantics(
      label: semanticsLabel,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: RodistaaTheme.gapM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: RodistaaTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: RodistaaTheme.gapXS),
                Text(
                  timestamp,
                  style:
                      textTheme.bodySmall?.copyWith(color: RodistaaTheme.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineDivider extends StatelessWidget {
  const _TimelineDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 12, top: RodistaaTheme.gapS, bottom: RodistaaTheme.gapS),
      child: SizedBox(
        height: 32,
        child: Column(
          children: List.generate(
            5,
            (index) => Expanded(
              child: Container(
                width: 2,
                margin: const EdgeInsets.symmetric(vertical: 1),
                color:
                    index.isEven ? RodistaaTheme.divider : Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
