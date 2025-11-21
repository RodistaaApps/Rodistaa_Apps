import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'countdown_timer.dart';

class CompactLoadCard extends StatelessWidget {
  const CompactLoadCard({
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
    required this.onPlaceBid,
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
  final VoidCallback onPlaceBid;

  @override
  Widget build(BuildContext context) {
    final rodistaaRed = AppColors.primaryRed;
    const textCharcoal = Color(0xFF222222);
    const textGrey = Color(0xFF666666);
    const textMeta = Color(0xFF444444);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: const Border(
          left: BorderSide(color: AppColors.primaryRed, width: 5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPlaceBid,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'LOAD #$loadId',
                        style: const TextStyle(
                          fontFamily: 'Times New Roman',
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: textCharcoal,
                          letterSpacing: 0.2,
                          height: 1.2,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: (isFTL ? rodistaaRed : Colors.green).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isFTL ? 'FTL' : 'PTL',
                        style: TextStyle(
                          color: isFTL ? rodistaaRed : Colors.green[700],
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: rodistaaRed,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: rodistaaRed.withValues(alpha: 0.18),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.timer_outlined, size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          CountdownTimer(
                            endAt: bidEndsAt,
                            style: const TextStyle(
                              fontFamily: 'Times New Roman',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 16, color: rodistaaRed),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '$pickup → $drop',
                                  style: TextStyle(
                                    fontFamily: 'Times New Roman',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: rodistaaRed,
                                    height: 1.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.category_outlined, size: 16, color: textGrey),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  category,
                                  style: const TextStyle(
                                    fontFamily: 'Times New Roman',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: textGrey,
                                    height: 1.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _compactToken(
                            icon: Icons.straighten,
                            label: '${tons.toStringAsFixed(1)}T',
                            textColor: textMeta,
                          ),
                          const SizedBox(height: 6),
                          _compactToken(
                            icon: Icons.inventory_2_outlined,
                            label: bodyType,
                            textColor: textMeta,
                          ),
                          const SizedBox(height: 6),
                          _compactToken(
                            icon: Icons.settings,
                            label: '$tyreCount tyres',
                            textColor: textMeta,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _compactToken({
    required IconData icon,
    required String label,
    required Color textColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: textColor),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

