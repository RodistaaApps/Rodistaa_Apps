import 'package:flutter/material.dart';

/// Placeholder map preview component for Nearby search
/// TODO: Replace with actual map SDK (Google Maps / Mapbox) in future
class NearbyMapPreview extends StatelessWidget {
  const NearbyMapPreview({
    super.key,
    this.onLocationSelected,
  });

  final ValueChanged<String>? onLocationSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map_outlined,
              size: 48,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              'Map preview (placeholder)',
              style: TextStyle(
                color: Colors.grey[600],
                fontFamily: 'Times New Roman',
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'TODO: Integrate Google Maps / Mapbox',
              style: TextStyle(
                color: Colors.grey[500],
                fontFamily: 'Times New Roman',
                fontSize: 11,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
