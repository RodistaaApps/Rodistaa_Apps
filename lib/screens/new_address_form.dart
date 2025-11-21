import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../models/address_model.dart';

class NewAddressFormScreen extends StatefulWidget {
  final bool isPickup;

  const NewAddressFormScreen({Key? key, required this.isPickup})
      : super(key: key);

  @override
  State<NewAddressFormScreen> createState() => _NewAddressFormScreenState();
}

class _NewAddressFormScreenState extends State<NewAddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();

  final MapController _mapController = MapController();

  LatLng? _marker;
  LatLng _initialPosition = LatLng(17.3850, 78.4867); // Hyderabad fallback
  bool _isLocating = true;
  String _selectedAddress = 'Tap on map to select location';

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLocating = false;
          _marker = _initialPosition;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLocating = false;
            _marker = _initialPosition;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLocating = false;
          _marker = _initialPosition;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      _initialPosition = LatLng(position.latitude, position.longitude);
    } catch (_) {
      _initialPosition = LatLng(17.3850, 78.4867);
    } finally {
      setState(() {
        _isLocating = false;
        _marker = _initialPosition;
      });
      _reverseGeocode(_initialPosition);
    }
  }

  Future<void> _reverseGeocode(LatLng point) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final address =
            '${p.street ?? ''}, ${p.locality ?? ''}, ${p.administrativeArea ?? ''}, ${p.postalCode ?? ''}'
                .replaceAll(', ,', ',')
                .replaceAll(' ,', ',')
                .trim();
        setState(() {
          _selectedAddress = address;
          _addressController.text = address;
        });
      }
    } catch (_) {
      setState(() {
        _selectedAddress = 'Selected location';
        if (_addressController.text.trim().isEmpty) {
          _addressController.text = 'Selected location';
        }
      });
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng latLng) {
    setState(() {
      _marker = latLng;
      _selectedAddress = 'Fetching address...';
    });
    _reverseGeocode(latLng);
  }

  Future<void> _saveAddress() async {
    if (_marker == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please select a location on the map',
            style: TextStyle(fontFamily: 'Times New Roman'),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final address = AddressModel.create(
      name: _nameController.text.trim(),
      mobile: _mobileController.text.trim(),
      fullAddress: _addressController.text.trim(),
      lat: _marker!.latitude,
      lng: _marker!.longitude,
    );

    if (!mounted) return;
    Navigator.of(context).pop(address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFC90D0D)),
        title: Text(
          widget.isPickup ? 'Add Pickup Address' : 'Add Drop Address',
          style: const TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.bold,
            color: Color(0xFFC90D0D),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black54),
            tooltip: 'Close',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 260,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _isLocating
                    ? Container(
                        color: Colors.grey.shade100,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFC90D0D),
                          ),
                        ),
                      )
                    : FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _marker ?? _initialPosition,
                          initialZoom: 15,
                          onTap: _onMapTap,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: const ['a', 'b', 'c'],
                          ),
                          if (_marker != null)
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: _marker!,
                                  width: 40,
                                  height: 40,
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Color(0xFFC90D0D),
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFC90D0D).withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Color(0xFFC90D0D),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Selected Location: $_selectedAddress',
                      style: const TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Name *',
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 14,
                    ),
                    decoration: _inputDecoration('Enter full name'),
                    validator: (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Required'
                            : null,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Mobile *',
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 14,
                    ),
                    decoration:
                        _inputDecoration('Enter mobile number').copyWith(
                      counterText: '',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }
                      if (value.trim().length != 10) {
                        return '10 digits required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Full Address *',
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _addressController,
                    maxLines: 3,
                    style: const TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 14,
                    ),
                    decoration: _inputDecoration('Enter full address'),
                    validator: (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Required'
                            : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveAddress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC90D0D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Save Address',
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontFamily: 'Times New Roman',
        fontSize: 14,
        color: Colors.grey.shade600,
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFC90D0D), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }
}

