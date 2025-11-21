import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/colors.dart';
import 'countdown_timer.dart';

class LoadCard extends StatelessWidget {
  const LoadCard({
    super.key,
    required this.loadId,
    required this.pickup,
    required this.drop,
    required this.category,
    required this.tons,
    required this.bodyType,
    required this.tyreCount,
    required this.bidEndsAt,
    required this.isFTL,
    required this.onViewDetails,
    required this.onPlaceBid,
    required this.onShare,
  });

  final String loadId;
  final String pickup;
  final String drop;
  final String category;
  final double tons;
  final String bodyType;
  final int tyreCount;
  final DateTime bidEndsAt;
  final bool isFTL;
  final VoidCallback onViewDetails;
  final VoidCallback onPlaceBid;
  final VoidCallback onShare;

  TextStyle get _labelStyle => const TextStyle(
        fontFamily: 'Times New Roman',
        fontSize: 13,
        color: Colors.black87,
      );

  TextStyle get _valueStyle => const TextStyle(
        fontFamily: 'Times New Roman',
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );

  @override
  Widget build(BuildContext context) {
    final rodistaaRed = AppColors.primaryRed;
    final bidClosesAt = DateFormat('dd MMM, h:mm a').format(bidEndsAt.toLocal());

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
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
                        'LOAD #$loadId',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                      const SizedBox(height: 6),
                      Tooltip(
                        message: 'Bid closes at $bidClosesAt',
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.timer_outlined, size: 14, color: Colors.black54),
                              const SizedBox(width: 6),
                              CountdownTimer(
                                endAt: bidEndsAt,
                                style: const TextStyle(
                                  fontFamily: 'Times New Roman',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _badge(
                  label: isFTL ? 'FTL' : 'PTL',
                  background: (isFTL ? rodistaaRed : Colors.green).withValues(alpha: 0.12),
                  foreground: isFTL ? rodistaaRed : Colors.green[700]!,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _infoRow(
              icon: Icons.location_on_outlined,
              label: 'Route',
              value: '$pickup → $drop',
              highlight: true,
            ),
            const SizedBox(height: 10),
            _infoRow(
              icon: Icons.category_outlined,
              label: 'Category',
              value: category,
            ),
            const SizedBox(height: 10),
            _infoRow(
              icon: Icons.straighten,
              label: 'Weight',
              value: '${tons.toStringAsFixed(1)} Tons',
            ),
            const SizedBox(height: 10),
            _infoRow(
              icon: Icons.inventory_2_outlined,
              label: 'Body Type',
              value: '$bodyType Body',
            ),
            const SizedBox(height: 10),
            _infoRow(
              icon: Icons.settings,
              label: 'Tyre Count',
              value: '$tyreCount tyres',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  onPressed: onShare,
                  tooltip: 'Share load',
                  icon: Icon(Icons.share_outlined, color: rodistaaRed),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onViewDetails,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: rodistaaRed),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'View Details',
                      style: TextStyle(
                        color: rodistaaRed,
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onPlaceBid,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: rodistaaRed,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Place Bid',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
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

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    bool highlight = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: highlight ? AppColors.primaryRed : Colors.black54),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: _labelStyle.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: _valueStyle.copyWith(
                  color: highlight ? AppColors.primaryRed : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _badge({
    required String label,
    required Color background,
    required Color foreground,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontWeight: FontWeight.w700,
          fontFamily: 'Times New Roman',
        ),
      ),
    );
  }
}

