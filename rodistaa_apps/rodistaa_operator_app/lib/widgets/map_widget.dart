import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants/colors.dart';

class LiveTrackMap extends StatefulWidget {
  const LiveTrackMap({
    super.key,
    required this.pickup,
    required this.drop,
    required this.completedRoute,
    required this.remainingRoute,
    required this.driverPosition,
    required this.driverHeading,
    required this.isFollowing,
    required this.onMapPanStart,
    this.onControllerReady,
    this.lastPing,
  });

  final LatLng pickup;
  final LatLng drop;
  final List<LatLng> completedRoute;
  final List<LatLng> remainingRoute;
  final LatLng? driverPosition;
  final double driverHeading;
  final bool isFollowing;
  final DateTime? lastPing;
  final VoidCallback onMapPanStart;
  final ValueChanged<GoogleMapController>? onControllerReady;

  @override
  State<LiveTrackMap> createState() => _LiveTrackMapState();
}

class _LiveTrackMapState extends State<LiveTrackMap> {
  GoogleMapController? _controller;
  BitmapDescriptor? _pickupIcon;
  BitmapDescriptor? _dropIcon;
  BitmapDescriptor? _truckIcon;
  bool _hasError = false;

  CameraPosition get _initialCamera => CameraPosition(
        target: widget.driverPosition ?? widget.pickup,
        zoom: 10.5,
      );

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  @override
  void didUpdateWidget(covariant LiveTrackMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_hasError &&
        widget.isFollowing &&
        widget.driverPosition != null &&
        widget.driverPosition != oldWidget.driverPosition) {
      try {
        _controller?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: widget.driverPosition!,
              zoom: 14,
              bearing: widget.driverHeading,
              tilt: 0,
            ),
          ),
        );
      } catch (e) {
        if (mounted) {
          setState(() => _hasError = true);
        }
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildPlaceholder();
    }

    return Stack(
      children: [
        Builder(
          builder: (context) {
            try {
              return GoogleMap(
                initialCameraPosition: _initialCamera,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                onMapCreated: (controller) {
                  _controller = controller;
                  widget.onControllerReady?.call(controller);
                },
                onCameraMoveStarted: widget.onMapPanStart,
                polylines: _buildPolylines(),
                markers: _buildMarkers(),
              );
            } catch (e) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() => _hasError = true);
                }
              });
              return _buildPlaceholder();
            }
          },
        ),
        if (widget.lastPing != null)
          Positioned(
            left: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Last ping: ${_formatLastPing(widget.lastPing!)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_outlined, color: AppColors.primaryRed, size: 36),
          const SizedBox(height: 8),
          Text(
            'Map unavailable',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w600,
              color: AppColors.primaryRed,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'API key required',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              color: Colors.grey[600],
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Set<Polyline> _buildPolylines() {
    final polylines = <Polyline>{};

    if (widget.completedRoute.length >= 2) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('completed'),
          color: const Color(0xFF424242),
          width: 6,
          points: widget.completedRoute,
        ),
      );
    }

    if (widget.remainingRoute.length >= 2) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('remaining'),
          color: AppColors.primaryRed,
          width: 6,
          points: widget.remainingRoute,
          patterns: [PatternItem.dash(30), PatternItem.gap(10)],
        ),
      );
    }

    return polylines;
  }

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('pickup'),
        icon: _pickupIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: widget.pickup,
        infoWindow: const InfoWindow(title: 'Pickup'),
      ),
      Marker(
        markerId: const MarkerId('drop'),
        icon: _dropIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: widget.drop,
        infoWindow: const InfoWindow(title: 'Drop'),
      ),
    };

    if (widget.driverPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('driver'),
          icon: _truckIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: widget.driverPosition!,
          rotation: widget.driverHeading,
          anchor: const Offset(0.5, 0.5),
          infoWindow: const InfoWindow(title: 'Driver'),
        ),
      );
    }

    return markers;
  }

  Future<void> _loadMarkers() async {
    BitmapDescriptor pickupIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    BitmapDescriptor dropIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);

    try {
      pickupIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(24, 24)),
        'assets/images/pin_pickup.png',
      );
      dropIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(24, 24)),
        'assets/images/pin_drop.png',
      );
    } catch (_) {
      // Ignore missing asset; defaults already set.
    }

    setState(() {
      _pickupIcon = pickupIcon;
      _dropIcon = dropIcon;
      _truckIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    });
  }

  String _formatLastPing(DateTime ping) {
    final diff = DateTime.now().difference(ping);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
  }
}

