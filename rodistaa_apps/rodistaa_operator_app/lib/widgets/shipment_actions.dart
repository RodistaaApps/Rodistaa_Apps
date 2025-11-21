import 'package:flutter/material.dart';

import '../constants/colors.dart';

class ShipmentActionsCard extends StatelessWidget {
  const ShipmentActionsCard({
    super.key,
    required this.advancePaid,
    required this.pendingBalance,
    this.onMarkLoaded,
    this.onConfirmUnloaded,
    this.onRequestPayment,
    this.onRecordCash,
    this.isBusy = false,
  });

  final double advancePaid;
  final double pendingBalance;
  final VoidCallback? onMarkLoaded;
  final VoidCallback? onConfirmUnloaded;
  final VoidCallback? onRequestPayment;
  final VoidCallback? onRecordCash;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shipment actions',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                if (onMarkLoaded != null)
                  _ActionPill(
                    label: 'Mark as Loaded',
                    icon: Icons.inventory_2,
                    onTap: onMarkLoaded!,
                    busy: isBusy,
                  ),
                if (onConfirmUnloaded != null)
                  _ActionPill(
                    label: 'Confirm Unloaded',
                    icon: Icons.fact_check,
                    onTap: onConfirmUnloaded!,
                    busy: isBusy,
                  ),
                if (onRequestPayment != null)
                  _ActionPill(
                    label: 'Request Payment',
                    icon: Icons.currency_rupee,
                    onTap: onRequestPayment!,
                    busy: isBusy,
                  ),
                if (onRecordCash != null)
                  _ActionPill(
                    label: 'Record Cash',
                    icon: Icons.receipt_long,
                    onTap: onRecordCash!,
                    busy: isBusy,
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _PaymentTile(
                    label: 'Advance paid',
                    value: '₹${advancePaid.toStringAsFixed(0)}',
                    valueColor: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PaymentTile(
                    label: 'Pending balance',
                    value: '₹${pendingBalance.toStringAsFixed(0)}',
                    valueColor: AppColors.primaryRed,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.busy,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: busy ? null : onTap,
      icon: busy
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : Icon(icon, size: 18),
      label: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Times New Roman',
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryRed,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 13,
              color: Color(0xFF777777),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

