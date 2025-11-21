import 'package:flutter/material.dart';
import '../widgets/map_location_picker.dart';

/// Warehousing Screen - Warehouse Storage Booking
class WarehousingScreen extends StatefulWidget {
  const WarehousingScreen({Key? key}) : super(key: key);

  @override
  State<WarehousingScreen> createState() => _WarehousingScreenState();
}

class _WarehousingScreenState extends State<WarehousingScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _showBookingForm = false;

  // Location
  Map<String, dynamic>? _warehouseLocation;

  // Storage Details
  String? _storageType;
  final _storageDurationController = TextEditingController();
  String _durationUnit = 'Days';
  final _requiredSpaceController = TextEditingController();
  String? _goodsType;
  final _goodsDescriptionController = TextEditingController();

  // Features
  bool _temperatureControlled = false;
  bool _securitySystem = false;
  bool _loadingFacilities = false;

  // Contact Details
  final _contactNameController = TextEditingController();
  final _contactMobileController = TextEditingController();

  // Terms
  bool _acceptTerms = false;

  final List<String> _storageTypes = [
    'General Storage',
    'Cold Storage',
    'Hazardous Materials',
    'Bulk Storage',
    'Rack Storage',
  ];

  final List<String> _goodsTypes = [
    'Food Products',
    'Electronics',
    'Machinery',
    'Furniture',
    'Chemicals',
    'Textiles',
    'Auto Parts',
    'Raw Materials',
    'Others',
  ];

  @override
  void dispose() {
    _storageDurationController.dispose();
    _requiredSpaceController.dispose();
    _goodsDescriptionController.dispose();
    _contactNameController.dispose();
    _contactMobileController.dispose();
    super.dispose();
  }

  Future<void> _selectWarehouseLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapLocationPicker(
          title: 'Select Warehouse Location',
        ),
      ),
    );
    
    if (result != null) {
      setState(() {
        _warehouseLocation = result;
      });
    }
  }

  void _submitBooking() {
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept Terms & Conditions'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: const [
              Icon(Icons.check_circle, color: Color(0xFFC90D0D), size: 32),
              SizedBox(width: 12),
              Text(
                'Storage Request Created!',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  color: Color(0xFFC90D0D),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Your warehouse storage request has been created successfully. Our team will contact you shortly.',
            style: TextStyle(fontFamily: 'Times New Roman'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _showBookingForm = false;
                  // Reset form
                  _warehouseLocation = null;
                  _storageType = null;
                  _storageDurationController.clear();
                  _requiredSpaceController.clear();
                  _goodsType = null;
                  _goodsDescriptionController.clear();
                  _temperatureControlled = false;
                  _securitySystem = false;
                  _loadingFacilities = false;
                  _contactNameController.clear();
                  _contactMobileController.clear();
                  _acceptTerms = false;
                });
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFFC90D0D),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Times New Roman',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_showBookingForm) {
      return _buildLandingPage();
    } else {
      return _buildBookingForm();
    }
  }

  Widget _buildLandingPage() {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            
            // Icon
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: const Color(0xFFC90D0D).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warehouse_rounded,
                size: 80,
                color: Color(0xFFC90D0D),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Title
            const Text(
              'Warehousing',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC90D0D),
                fontFamily: 'Times New Roman',
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Description
            Text(
              'Find, book, and manage warehouse storage for your goods.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                fontFamily: 'Times New Roman',
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            // Features
            _buildFeatureCard(
              icon: Icons.security_outlined,
              title: 'Secure Storage',
              description: '24/7 security monitoring and access control',
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              icon: Icons.thermostat_outlined,
              title: 'Climate Controlled',
              description: 'Temperature and humidity controlled facilities',
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              icon: Icons.location_city_outlined,
              title: 'Strategic Locations',
              description: 'Warehouses in prime locations across India',
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              icon: Icons.inventory_outlined,
              title: 'Inventory Management',
              description: 'Real-time tracking of your stored goods',
            ),
            
            const SizedBox(height: 40),
            
            // Book Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _showBookingForm = true;
                  });
                },
                icon: const Icon(Icons.add_business, size: 24),
                label: const Text(
                  'Book Storage',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Times New Roman',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC90D0D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFC90D0D).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFC90D0D),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Times New Roman',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontFamily: 'Times New Roman',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingForm() {
    return Container(
      color: Colors.grey.shade50,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _showBookingForm = false;
                  });
                },
                icon: const Icon(Icons.arrow_back, color: Color(0xFFC90D0D)),
                label: const Text(
                  'Back',
                  style: TextStyle(
                    color: Color(0xFFC90D0D),
                    fontFamily: 'Times New Roman',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // LOCATION
              _buildSectionCard(
                title: '📍 Warehouse Location',
                children: [
                  _buildLocationField(
                    label: 'Preferred Location',
                    value: _warehouseLocation?['address'],
                    onTap: _selectWarehouseLocation,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // STORAGE DETAILS
              _buildSectionCard(
                title: '📦 Storage Requirements',
                children: [
                  _buildDropdown(
                    label: 'Storage Type',
                    value: _storageType,
                    items: _storageTypes,
                    onChanged: (value) {
                      setState(() {
                        _storageType = value;
                      });
                    },
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildTextField(
                          controller: _storageDurationController,
                          label: 'Storage Duration',
                          icon: Icons.access_time,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdown(
                          label: 'Unit',
                          value: _durationUnit,
                          items: ['Days', 'Months', 'Years'],
                          onChanged: (value) {
                            setState(() {
                              _durationUnit = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _requiredSpaceController,
                    label: 'Required Space (sq. ft)',
                    icon: Icons.square_foot,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // GOODS DETAILS
              _buildSectionCard(
                title: '📋 Goods Information',
                children: [
                  _buildDropdown(
                    label: 'Type of Goods',
                    value: _goodsType,
                    items: _goodsTypes,
                    onChanged: (value) {
                      setState(() {
                        _goodsType = value;
                      });
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _goodsDescriptionController,
                    label: 'Goods Description',
                    icon: Icons.description,
                    maxLines: 3,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ADDITIONAL FEATURES
              _buildSectionCard(
                title: '⭐ Additional Features',
                children: [
                  CheckboxListTile(
                    title: const Text('Temperature Controlled'),
                    subtitle: const Text('For perishable goods'),
                    value: _temperatureControlled,
                    activeColor: const Color(0xFFC90D0D),
                    onChanged: (value) {
                      setState(() {
                        _temperatureControlled = value ?? false;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  CheckboxListTile(
                    title: const Text('24/7 Security System'),
                    subtitle: const Text('CCTV and access control'),
                    value: _securitySystem,
                    activeColor: const Color(0xFFC90D0D),
                    onChanged: (value) {
                      setState(() {
                        _securitySystem = value ?? false;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  CheckboxListTile(
                    title: const Text('Loading/Unloading Facilities'),
                    subtitle: const Text('Forklifts and ramps'),
                    value: _loadingFacilities,
                    activeColor: const Color(0xFFC90D0D),
                    onChanged: (value) {
                      setState(() {
                        _loadingFacilities = value ?? false;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // CONTACT DETAILS
              _buildSectionCard(
                title: '📞 Contact Details',
                children: [
                  _buildTextField(
                    controller: _contactNameController,
                    label: 'Contact Name',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _contactMobileController,
                    label: 'Mobile Number',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // TERMS
              _buildSectionCard(
                title: '📋 Terms & Conditions',
                children: [
                  CheckboxListTile(
                    title: const Text(
                      'I accept the Terms & Conditions',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    value: _acceptTerms,
                    activeColor: const Color(0xFFC90D0D),
                    onChanged: (value) {
                      setState(() {
                        _acceptTerms = value ?? false;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _acceptTerms ? _submitBooking : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC90D0D),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: _acceptTerms ? 4 : 0,
                  ),
                  child: const Text(
                    'Submit Request',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC90D0D),
                fontFamily: 'Times New Roman',
              ),
            ),
            Divider(color: Colors.grey.shade300, height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildLocationField({
    required String label,
    required String? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.location_on, color: Color(0xFFC90D0D)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Text(
          value ?? 'Select $label on Map',
          style: TextStyle(
            color: value != null ? Colors.black87 : Colors.grey,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFC90D0D)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFC90D0D), width: 2),
        ),
        counterText: '',
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFC90D0D), width: 2),
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}

