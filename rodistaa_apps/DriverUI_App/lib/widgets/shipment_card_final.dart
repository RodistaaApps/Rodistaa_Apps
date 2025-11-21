import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme.dart';
import '../utils/maps_helper.dart';
import 'otp_input.dart';
import 'shipment_details_bottom_sheet.dart';

typedef ShipmentDetailsHandler = Future<void> Function(
  Map<String, dynamic> shipment, {
  bool readOnly,
});

enum ShipmentProgressStep { pickup, loading, inTransit, delivered }

@visibleForTesting
List<ShipmentProgressVisualState> progressVisualStates(int currentStep) {
  return ShipmentProgressStep.values.map((step) {
    final index = ShipmentProgressStep.values.indexOf(step);
    final isCompleted = index < currentStep;
    final isCurrent = index == currentStep;
    return ShipmentProgressVisualState(
      step: step,
      isCompleted: isCompleted,
      isCurrent: isCurrent,
    );
  }).toList();
}

class ShipmentProgressVisualState {
  ShipmentProgressVisualState({
    required this.step,
    required this.isCompleted,
    required this.isCurrent,
  });
  final ShipmentProgressStep step;
  final bool isCompleted;
  final bool isCurrent;
}

class ShipmentCardFinal extends StatefulWidget {
  const ShipmentCardFinal({
    super.key,
    required this.shipment,
    this.onOtpSubmit,
    this.onViewDetails,
    this.onDetailsRequested,
  });

  final Map<String, dynamic> shipment;
  final Future<void> Function(String otp, String type)? onOtpSubmit;
  final VoidCallback? onViewDetails;
  final ShipmentDetailsHandler? onDetailsRequested;

  @override
  State<ShipmentCardFinal> createState() => _ShipmentCardFinalState();
}

class _ShipmentCardFinalState extends State<ShipmentCardFinal> {
  bool _otpVerifying = false;
  int _failedAttempts = 0;

  Map<String, dynamic> get shipment => widget.shipment;

  int get currentStep => (shipment['currentStep'] as int?)?.clamp(0, 3) ?? 0;

  String get shipmentId => shipment['id']?.toString() ?? '';

  String get loadCategory =>
      shipment['loadCategory']?.toString() ?? 'Full Truck';

  @override
  Widget build(BuildContext context) {
    final textTheme = RodistaaTheme.serifTextTheme(Theme.of(context).textTheme);
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
          _showDetails();
        }
      },
      child: Container(
        decoration: RodistaaTheme.cardDecoration.copyWith(
          border: Border(
            left: BorderSide(color: RodistaaTheme.rodistaaRed, width: 4),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: RodistaaTheme.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: RodistaaTheme.gapM),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#$shipmentId',
                        style: textTheme.titleLarge?.copyWith(
                          color: RodistaaTheme.rodistaaRed,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: RodistaaTheme.gapXS),
                      Wrap(
                        spacing: RodistaaTheme.gapM,
                        runSpacing: RodistaaTheme.gapXS,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'Started: ${shipment['startedAt'] ?? '--'}',
                            style: textTheme.bodySmall,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.local_shipping,
                                  size: 16, color: RodistaaTheme.muted),
                              const SizedBox(width: RodistaaTheme.gapXS),
                              Text(loadCategory, style: textTheme.bodySmall),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                FilledButton.icon(
                  onPressed: _showDetails,
                  style: FilledButton.styleFrom(
                    backgroundColor: RodistaaTheme.rodistaaRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                  ),
                  icon: const Icon(Icons.description_outlined),
                  label: const Text('View Details'),
                ),
              ],
            ),
            const SizedBox(height: RodistaaTheme.gapL),
            Row(
              children: [
                Expanded(child: _locationColumn(isPickup: true)),
                const SizedBox(width: RodistaaTheme.gapL),
                Expanded(child: _locationColumn(isPickup: false)),
              ],
            ),
            const SizedBox(height: RodistaaTheme.gapL),
            const Divider(),
            const SizedBox(height: RodistaaTheme.gapL),
            _statusStrip(),
          ],
        ),
      ),
    );
  }

  Widget _locationColumn({required bool isPickup}) {
    final title = isPickup ? 'Pickup' : 'Drop';
    final icon = isPickup ? Icons.home : Icons.flag;
    final iconColor = isPickup ? RodistaaTheme.rodistaaRed : Colors.blueGrey;
    final addressKey = isPickup ? 'pickupAddress' : 'dropAddress';
    final otpLabel = isPickup ? 'Pickup OTP' : 'Drop OTP';
    final otpType = isPickup ? 'pickup' : 'drop';
    final latKey = isPickup ? 'pickupLat' : 'dropLat';
    final lngKey = isPickup ? 'pickupLng' : 'dropLng';
    final address = shipment[addressKey]?.toString() ?? '--';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: RodistaaTheme.gapS),
            Text(
              title,
              style: RodistaaTheme.headingMedium(context),
            ),
          ],
        ),
        const SizedBox(height: RodistaaTheme.gapS),
        Text(
          address,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: RodistaaTheme.bodyRegular(context),
        ),
        const SizedBox(height: RodistaaTheme.gapS),
        Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: _OtpChip(
                  label: otpLabel,
                  onTap: () => _showOtpSheet(otpType),
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () => _openNavigation(latKey: latKey, lngKey: lngKey),
              icon: const Icon(Icons.navigation_rounded,
                  color: RodistaaTheme.rodistaaRed),
              label: const Text(
                'Navigate',
                style: TextStyle(color: RodistaaTheme.rodistaaRed),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statusStrip() {
    final steps = progressVisualStates(currentStep);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(steps.length * 2 - 1, (index) {
            if (index.isOdd) {
              final progressIndex = (index - 1) ~/ 2;
              final isComplete = steps[progressIndex].isCompleted;
              return Expanded(
                child: Container(
                  height: 3,
                  color: isComplete
                      ? RodistaaTheme.rodistaaRed
                      : RodistaaTheme.divider,
                ),
              );
            }
            final step = steps[index ~/ 2];
            return GestureDetector(
              onTap: _showDetails,
              child: _StatusIcon(step: step),
            );
          }),
        ),
        const SizedBox(height: RodistaaTheme.gapS),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Pickup'),
            Text('Loading'),
            Text('In Transit'),
            Text('Delivered'),
          ],
        ),
      ],
    );
  }

  Future<void> _openNavigation(
      {required String latKey, required String lngKey}) async {
    final pickupLat = shipment['pickupLat'] as double?;
    final pickupLng = shipment['pickupLng'] as double?;
    final dropLat = shipment['dropLat'] as double?;
    final dropLng = shipment['dropLng'] as double?;
    if (pickupLat == null ||
        pickupLng == null ||
        dropLat == null ||
        dropLng == null) {
      return;
    }
    await MapsHelper.openExternalMaps(
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      dropLat: dropLat,
      dropLng: dropLng,
    );
  }

  Future<void> _showOtpSheet(String type) async {
    if (widget.onOtpSubmit == null) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.36,
          minChildSize: 0.3,
          maxChildSize: 0.6,
          expand: false,
          builder: (_, controller) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                children: [
                  Text('Enter ${type == 'pickup' ? 'Pickup' : 'Drop'} OTP',
                      style: RodistaaTheme.headingMedium(context)),
                  const SizedBox(height: RodistaaTheme.gapL),
                  OtpInput(
                    isVerifying: _otpVerifying,
                    onCancel: () => Navigator.of(context).maybePop(),
                    onSubmit: (otp) async {
                      Navigator.of(context).maybePop();
                      await _verifyOtp(type, otp);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _verifyOtp(String type, String otp) async {
    if (widget.onOtpSubmit == null) return;
    setState(() => _otpVerifying = true);
    try {
      await widget.onOtpSubmit!(otp, type);
      _failedAttempts = 0;
    } catch (_) {
      _failedAttempts += 1;
      rethrow;
    } finally {
      if (mounted) {
        setState(() => _otpVerifying = false);
      }
    }
  }

  Future<void> _showDetails() async {
    if (widget.onDetailsRequested != null) {
      await widget.onDetailsRequested!(shipment, readOnly: false);
      return;
    }
    final controller = ScrollController();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.62,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, scrollController) {
            return ShipmentDetailsBottomSheet(
              shipment: shipment,
              controller: controller,
            );
          },
        );
      },
    );
    widget.onViewDetails?.call();
  }
}

class _OtpChip extends StatelessWidget {
  const _OtpChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: RodistaaTheme.rodistaaRed.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.vpn_key, size: 16, color: RodistaaTheme.rodistaaRed),
            SizedBox(width: RodistaaTheme.gapXS),
            Text(
              'OTP',
              style: TextStyle(
                color: RodistaaTheme.rodistaaRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.step});

  final ShipmentProgressVisualState step;

  IconData get _icon {
    switch (step.step) {
      case ShipmentProgressStep.pickup:
        return Icons.storefront;
      case ShipmentProgressStep.loading:
        return Icons.inventory_2;
      case ShipmentProgressStep.inTransit:
        return Icons.local_shipping;
      case ShipmentProgressStep.delivered:
        return Icons.check_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = step.isCompleted || step.isCurrent
        ? RodistaaTheme.rodistaaRed
        : RodistaaTheme.divider;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: step.isCompleted
            ? RodistaaTheme.rodistaaRed.withValues(alpha: 0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color,
          width: step.isCurrent ? 2 : 1,
        ),
      ),
      child: Icon(_icon, color: color),
    );
  }
}
