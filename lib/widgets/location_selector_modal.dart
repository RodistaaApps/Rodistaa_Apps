import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocationSelectorModal extends StatefulWidget {
  final bool isPickup;
  
  const LocationSelectorModal({
    super.key,
    required this.isPickup,
  });

  @override
  State<LocationSelectorModal> createState() => _LocationSelectorModalState();
}

class _LocationSelectorModalState extends State<LocationSelectorModal> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  
  String? _currentLocationAddress;
  double? _currentLat;
  double? _currentLng;
  List<Map<String, dynamic>> _savedAddresses = [];
  bool _isLoadingLocation = true;
  
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadSavedAddresses();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      setState(() => _isLoadingLocation = true);
      
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showLocationError('Location permissions are denied');
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        _showLocationError('Location permissions are permanently denied');
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      // Reverse geocode to get address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = _formatAddress(place);
        
        setState(() {
          _currentLocationAddress = address;
          _currentLat = position.latitude;
          _currentLng = position.longitude;
          _addressController.text = address;
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      _showLocationError('Failed to get current location: $e');
    }
  }

  String _formatAddress(Placemark place) {
    List<String> addressParts = [];
    
    if (place.name != null && place.name!.isNotEmpty) {
      addressParts.add(place.name!);
    }
    if (place.street != null && place.street!.isNotEmpty && place.street != place.name) {
      addressParts.add(place.street!);
    }
    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      addressParts.add(place.subLocality!);
    }
    if (place.locality != null && place.locality!.isNotEmpty) {
      addressParts.add(place.locality!);
    }
    if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
      addressParts.add(place.administrativeArea!);
    }
    
    return addressParts.join(', ');
  }

  void _showLocationError(String message) {
    setState(() => _isLoadingLocation = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Times New Roman')),
        backgroundColor: const Color(0xFFC90D0D),
      ),
    );
  }

  Future<void> _loadSavedAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? savedAddressesJson = prefs.getString('recent_addresses');
      
      if (savedAddressesJson != null) {
        final List<dynamic> decoded = json.decode(savedAddressesJson);
        setState(() {
          _savedAddresses = decoded.cast<Map<String, dynamic>>();
        });
      }
    } catch (e) {
      print('Error loading saved addresses: $e');
    }
  }

  Future<void> _saveAddress() async {
    if (_addressController.text.trim().isEmpty) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      Map<String, dynamic> newAddress = {
        'name': _nameController.text.trim().isEmpty ? 'Unnamed Location' : _nameController.text.trim(),
        'address': _addressController.text.trim(),
        'mobile': _mobileController.text.trim(),
        'lat': _currentLat,
        'lng': _currentLng,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      
      // Remove duplicate addresses
      _savedAddresses.removeWhere((addr) => addr['address'] == newAddress['address']);
      
      // Add to beginning of list
      _savedAddresses.insert(0, newAddress);
      
      // Keep only last 5 addresses
      if (_savedAddresses.length > 5) {
        _savedAddresses = _savedAddresses.take(5).toList();
      }
      
      // Save to preferences
      await prefs.setString('recent_addresses', json.encode(_savedAddresses));
    } catch (e) {
      print('Error saving address: $e');
    }
  }

  Future<void> _openMapPicker() async {
    // Mock map picker - in real implementation, this would open Google Maps
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Map picker would open here', style: TextStyle(fontFamily: 'Times New Roman')),
        backgroundColor: Color(0xFFC90D0D),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _selectSavedAddress(Map<String, dynamic> address) {
    setState(() {
      _nameController.text = address['name'] ?? '';
      _mobileController.text = address['mobile'] ?? '';
      _addressController.text = address['address'] ?? '';
      _currentLat = address['lat'];
      _currentLng = address['lng'];
    });
  }

  void _confirmAddress() async {
    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an address', style: TextStyle(fontFamily: 'Times New Roman')),
          backgroundColor: Color(0xFFC90D0D),
        ),
      );
      return;
    }

    // Save address to recent list
    await _saveAddress();

    // Return selected location data
    Navigator.pop(context, {
      'address': _addressController.text.trim(),
      'name': _nameController.text.trim(),
      'mobile': _mobileController.text.trim(),
      'lat': _currentLat,
      'lng': _currentLng,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(
                  widget.isPickup ? Icons.my_location : Icons.location_on,
                  color: const Color(0xFFC90D0D),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.isPickup ? 'Select Pickup Location' : 'Select Drop Location',
                    style: const TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current Location Section
                  if (_isLoadingLocation)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC90D0D)),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Getting current location...',
                            style: TextStyle(
                              fontFamily: 'Times New Roman',
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (_currentLocationAddress != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC90D0D).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFC90D0D).withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.my_location, color: Color(0xFFC90D0D), size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Current Location',
                                  style: TextStyle(
                                    fontFamily: 'Times New Roman',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFC90D0D),
                                  ),
                                ),
                                Text(
                                  _currentLocationAddress!,
                                  style: const TextStyle(
                                    fontFamily: 'Times New Roman',
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Saved Addresses Section
                  if (_savedAddresses.isNotEmpty) ...[
                    const Text(
                      '🔹 Saved Addresses',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    ..._savedAddresses.take(3).map((address) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        onTap: () => _selectSavedAddress(address),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on_outlined, color: Colors.grey, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      address['name'] ?? 'Unnamed Location',
                                      style: const TextStyle(
                                        fontFamily: 'Times New Roman',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      address['address'] ?? '',
                                      style: const TextStyle(
                                        fontFamily: 'Times New Roman',
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )).toList(),
                    
                    const SizedBox(height: 16),
                  ],

                  // Contact Info Section
                  Text(
                    '📦 ${widget.isPickup ? 'Pickup' : 'Delivery'} Contact Info',
                    style: const TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(fontFamily: 'Times New Roman', fontSize: 14),
                    decoration: InputDecoration(
                      labelText: 'Name (Optional)',
                      labelStyle: const TextStyle(fontFamily: 'Times New Roman', fontSize: 13, color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFC90D0D), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Mobile Field
                  TextFormField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    style: const TextStyle(fontFamily: 'Times New Roman', fontSize: 14),
                    decoration: InputDecoration(
                      labelText: 'Mobile (Optional)',
                      labelStyle: const TextStyle(fontFamily: 'Times New Roman', fontSize: 13, color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFC90D0D), width: 1.5),
                      ),
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Address Field
                  TextFormField(
                    controller: _addressController,
                    maxLines: 3,
                    style: const TextStyle(fontFamily: 'Times New Roman', fontSize: 14),
                    decoration: InputDecoration(
                      labelText: 'Full Address',
                      labelStyle: const TextStyle(fontFamily: 'Times New Roman', fontSize: 13, color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFC90D0D), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Change Address Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _openMapPicker,
                      icon: const Icon(Icons.map, color: Color(0xFFC90D0D), size: 18),
                      label: const Text(
                        'Change Address',
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 14,
                          color: Color(0xFFC90D0D),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFC90D0D)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Confirm Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: _confirmAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC90D0D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Confirm Address',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
