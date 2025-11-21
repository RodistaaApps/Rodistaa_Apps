import 'package:flutter/material.dart';

class MapLocationPicker extends StatefulWidget {
  final String title;
  
  const MapLocationPicker({
    super.key,
    required this.title,
  });

  @override
  State<MapLocationPicker> createState() => _MapLocationPickerState();
}

class _MapLocationPickerState extends State<MapLocationPicker> {
  // Mock locations for demonstration
  final List<Map<String, dynamic>> _mockLocations = [
    {"address": "Hyderabad, Telangana", "lat": 17.3850, "lng": 78.4867},
    {"address": "Vijayawada, Andhra Pradesh", "lat": 16.5062, "lng": 80.6480},
    {"address": "Bangalore, Karnataka", "lat": 12.9716, "lng": 77.5946},
    {"address": "Chennai, Tamil Nadu", "lat": 13.0827, "lng": 80.2707},
    {"address": "Mumbai, Maharashtra", "lat": 19.0760, "lng": 72.8777},
  ];

  Map<String, dynamic>? _selectedLocation;

  @override
  void initState() {
    super.initState();
    // Default to first location
    _selectedLocation = _mockLocations[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC90D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Times New Roman',
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Mock Map Area
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey.shade200,
              child: Stack(
                children: [
                  // Mock map background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.green.shade100,
                          Colors.blue.shade100,
                          Colors.grey.shade200,
                        ],
                      ),
                    ),
                  ),
                  // Mock roads/paths
                  Positioned(
                    top: 100,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 4,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  Positioned(
                    top: 200,
                    left: 100,
                    right: 50,
                    child: Container(
                      height: 3,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  // Center pin
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 50,
                          color: Color(0xFFC90D0D),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            _selectedLocation?['address'] ?? 'Select Location',
                            style: const TextStyle(
                              fontFamily: 'Times New Roman',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Mock location suggestions
                  Positioned(
                    top: 20,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Suggested Locations:',
                            style: TextStyle(
                              fontFamily: 'Times New Roman',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFC90D0D),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...(_mockLocations.take(3).map((location) => 
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedLocation = location;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 16,
                                      color: _selectedLocation == location 
                                          ? const Color(0xFFC90D0D) 
                                          : Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        location['address'],
                                        style: TextStyle(
                                          fontFamily: 'Times New Roman',
                                          fontSize: 12,
                                          color: _selectedLocation == location 
                                              ? const Color(0xFFC90D0D) 
                                              : Colors.black87,
                                          fontWeight: _selectedLocation == location 
                                              ? FontWeight.w600 
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom confirmation button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedLocation != null ? _confirmLocation : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC90D0D),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Confirm Location',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
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

  void _confirmLocation() {
    if (_selectedLocation != null) {
      Navigator.pop(context, _selectedLocation);
    }
  }
}