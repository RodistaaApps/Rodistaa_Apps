import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../models/shipment.dart';
import '../providers/live_track_provider.dart';

class PeopleCard extends StatelessWidget {
  const PeopleCard({
    super.key,
    required this.driver,
    required this.sender,
    required this.receiver,
    required this.isDriverOnline,
    required this.onCallDriver,
    required this.onMessageDriver,
    required this.onShare,
  });

  final ShipmentDriver driver;
  final LiveContact sender;
  final LiveContact receiver;
  final bool isDriverOnline;
  final VoidCallback onCallDriver;
  final VoidCallback onMessageDriver;
  final VoidCallback onShare;

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
            _DriverRow(
              driver: driver,
              isOnline: isDriverOnline,
            ),
            const SizedBox(height: 16),
            _ContactRow(contact: sender),
            const SizedBox(height: 8),
            _ContactRow(contact: receiver),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _ActionButton(icon: Icons.call, label: 'Call Driver', onTap: onCallDriver)),
                const SizedBox(width: 12),
                Expanded(child: _ActionButton(icon: Icons.chat_bubble, label: 'Message Driver', onTap: onMessageDriver)),
                const SizedBox(width: 12),
                Expanded(child: _ActionButton(icon: Icons.share, label: 'Share', onTap: onShare)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DriverRow extends StatelessWidget {
  const _DriverRow({required this.driver, required this.isOnline});

  final ShipmentDriver driver;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primaryRed.withValues(alpha: 0.1),
          child: Text(
            driver.initials,
            style: const TextStyle(
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w700,
              color: AppColors.primaryRed,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      driver.name,
                      style: const TextStyle(
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  _OnlineDot(isOnline: isOnline),
                ],
              ),
              Text(
                driver.truckNumber,
                style: const TextStyle(
                  fontFamily: 'Times New Roman',
                  color: Color(0xFF666666),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.contact});

  final LiveContact contact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          contact.label.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryRed,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Text(
                contact.name,
                style: const TextStyle(
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              contact.phone,
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 13,
                color: Color(0xFF555555),
              ),
            ),
          ],
        ),
        Text(
          contact.city,
          style: const TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 13,
            color: Color(0xFF777777),
          ),
        ),
      ],
    );
  }
}

class _OnlineDot extends StatelessWidget {
  const _OnlineDot({required this.isOnline});

  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: isOnline ? AppColors.idleGreen : const Color(0xFFB0B0B0),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}

