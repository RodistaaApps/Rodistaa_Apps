import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/map_location_picker.dart';

/// FreshMarts Screen - Fresh Produce Delivery Booking
class FreshMartsScreen extends StatefulWidget {
  const FreshMartsScreen({Key? key}) : super(key: key);

  @override
  State<FreshMartsScreen> createState() => _FreshMartsScreenState();
}

class _FreshMartsScreenState extends State<FreshMartsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _showBookingForm = false;

  // Locations
  Map<String, dynamic>? _pickupLocation;
  Map<String, dynamic>? _dropLocation;

  // Date & Time
  DateTime? _deliveryDate;
  TimeOfDay? _deliveryTime;

  // Product Details
  String? _productCategory;
  final _productDescriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  String _quantityUnit = 'Kg';
  String? _vehicleType;

  // Contact Details
  final _contactNameController = TextEditingController();
  final _contactMobileController = TextEditingController();

  // Terms
  bool _acceptTerms = false;

  final List<String> _productCategories = [
    'Fruits',
    'Vegetables',
    'Dairy Products',
    'Meat & Poultry',
    'Seafood',
    'Grains & Pulses',
    'Bakery Items',
    'Beverages',
  ];

  final List<String> _vehicleTypes = [
    'Refrigerated Van',
    'Refrigerated Truck',
    'Normal Van',
    'Mini Truck',
  ];

  @override
  void dispose() {
    _productDescriptionController.dispose();
    _quantityController.dispose();
    _contactNameController.dispose();
    _contactMobileController.dispose();
    super.dispose();
  }

  Future<void> _selectPickupLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapLocationPicker(
          title: 'Select Pickup Location',
        ),
      ),
    );
    
    if (result != null) {
      setState(() {
        _pickupLocation = result;
      });
    }
  }

  Future<void> _selectDropLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapLocationPicker(
          title: 'Select Delivery Location',
        ),
      ),
    );
    
    if (result != null) {
      setState(() {
        _dropLocation = result;
      });
    }
  }

  Future<void> _selectDeliveryDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFC90D0D),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _deliveryDate = picked;
      });
    }
  }

  Future<void> _selectDeliveryTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFC90D0D),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _deliveryTime = picked;
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
                'Booking Created!',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  color: Color(0xFFC90D0D),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Your FreshMarts delivery booking has been created successfully!',
            style: TextStyle(fontFamily: 'Times New Roman'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _showBookingForm = false;
                  // Reset form
                  _pickupLocation = null;
                  _dropLocation = null;
                  _deliveryDate = null;
                  _deliveryTime = null;
                  _productCategory = null;
                  _productDescriptionController.clear();
                  _quantityController.clear();
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
                Icons.shopping_basket_rounded,
                size: 80,
                color: Color(0xFFC90D0D),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Title
            const Text(
              'FreshMarts',
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
              'Book fresh produce delivery trucks directly through Rodistaa.',
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
              icon: Icons.local_shipping_outlined,
              title: 'Fast Delivery',
              description: 'Quick and reliable fresh produce transportation',
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              icon: Icons.ac_unit_outlined,
              title: 'Temperature Controlled',
              description: 'Refrigerated vehicles to maintain freshness',
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              icon: Icons.verified_outlined,
              title: 'Quality Assured',
              description: 'Verified transporters with food safety standards',
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
                icon: const Icon(Icons.add_shopping_cart, size: 24),
                label: const Text(
                  'Book Fresh Load',
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
              
              // LOCATIONS
              _buildSectionCard(
                title: '📍 Pickup & Delivery',
                children: [
                  _buildLocationField(
                    label: 'Pickup Location',
                    value: _pickupLocation?['address'],
                    onTap: _selectPickupLocation,
                  ),
                  const SizedBox(height: 14),
                  _buildLocationField(
                    label: 'Delivery Location',
                    value: _dropLocation?['address'],
                    onTap: _selectDropLocation,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateTimeField(
                          label: 'Delivery Date',
                          value: _deliveryDate != null
                              ? DateFormat('dd MMM yyyy').format(_deliveryDate!)
                              : null,
                          icon: Icons.calendar_today,
                          onTap: _selectDeliveryDate,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDateTimeField(
                          label: 'Delivery Time',
                          value: _deliveryTime?.format(context),
                          icon: Icons.access_time,
                          onTap: _selectDeliveryTime,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // PRODUCT DETAILS
              _buildSectionCard(
                title: '🥬 Product Details',
                children: [
                  _buildDropdown(
                    label: 'Product Category',
                    value: _productCategory,
                    items: _productCategories,
                    onChanged: (value) {
                      setState(() {
                        _productCategory = value;
                      });
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _productDescriptionController,
                    label: 'Product Description',
                    icon: Icons.description,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildTextField(
                          controller: _quantityController,
                          label: 'Quantity',
                          icon: Icons.numbers,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdown(
                          label: 'Unit',
                          value: _quantityUnit,
                          items: ['Kg', 'Tons', 'Boxes'],
                          onChanged: (value) {
                            setState(() {
                              _quantityUnit = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // VEHICLE TYPE
              _buildSectionCard(
                title: '🚛 Vehicle Selection',
                children: [
                  _buildDropdown(
                    label: 'Vehicle Type',
                    value: _vehicleType,
                    items: _vehicleTypes,
                    onChanged: (value) {
                      setState(() {
                        _vehicleType = value;
                      });
                    },
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
                    'Submit Booking',
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

  Widget _buildDateTimeField({
    required String label,
    required String? value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
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
        ),
        child: Text(
          value ?? 'Select',
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

