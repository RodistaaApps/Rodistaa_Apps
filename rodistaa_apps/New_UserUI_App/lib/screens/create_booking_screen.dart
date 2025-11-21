import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../widgets/location_selector_modal.dart';

class CreateBookingScreen extends StatefulWidget {
  final String loadType;

  const CreateBookingScreen({
    super.key,
    this.loadType = 'Full Load',
  });

  @override
  State<CreateBookingScreen> createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  // Load Type
  String _loadType = 'Full Load';

  // Location Details
  Map<String, dynamic>? _pickupLocation;
  Map<String, dynamic>? _dropLocation;
  
  // Date & Time
  DateTime? _pickupDate;
  TimeOfDay? _pickupTime;

  // Goods & Vehicle
  String? _goodsCategory;
  String? _packageType;
  final TextEditingController _quantityController = TextEditingController();
  String? _vehicleType;
  String? _tyreCount;

  // Payment
  String _advancePaymentPercent = '20%';
  String _paymentMode = 'Cash';


  // Dropdown options
  final List<String> _goodsCategories = [
    'Food', 'Electronics', 'Machinery', 'Furniture', 'Chemicals',
    'Textiles', 'Auto Parts', 'Cement', 'Medicines', 'Others',
  ];

  final List<String> _packageTypes = [
    'Cartons', 'Pallets', 'Drums', 'Bags', 'Loose',
  ];

  final List<String> _vehicleTypes = ['Open', 'Closed'];
  final List<String> _tyreCounts = ['12', '10', '8', '6', '4'];
  final List<String> _advancePaymentPercents = ['10%', '20%', '30%', '50%', '100%'];
  final List<String> _paymentModes = ['Cash', 'UPI', 'Online'];

  @override
  void initState() {
    super.initState();
    _loadType = widget.loadType;
    _pickupDate = DateTime.now();
    _pickupTime = TimeOfDay.now();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFC90D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Book Truck',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Times New Roman',
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Load Type Toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLoadTypeButton('Partial Load'),
                          const SizedBox(width: 8),
                          _buildLoadTypeButton('Full Load'),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Pickup & Drop Locations
                      _buildLocationSelector(
                        label: 'Pickup Location',
                        value: _pickupLocation?['address'],
                        onTap: () => _openLocationSelector(isPickup: true),
                        isPickup: true,
                      ),
                      const SizedBox(height: 10),
                      _buildLocationSelector(
                        label: 'Drop Location',
                        value: _dropLocation?['address'],
                        onTap: () => _openLocationSelector(isPickup: false),
                        isPickup: false,
                      ),
                      const SizedBox(height: 16),

                      // Date & Time
                      Row(
                        children: [
                          Expanded(child: _buildDateField()),
                          const SizedBox(width: 8),
                          Expanded(child: _buildTimeField()),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Goods & Vehicle Details Grid
                      _buildGoodsVehicleGrid(),
                      const SizedBox(height: 10),

                      // Payment Details
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown(
                              label: 'Advance Payment (%)',
                              value: _advancePaymentPercent,
                              items: _advancePaymentPercents,
                              onChanged: (value) => setState(() => _advancePaymentPercent = value ?? '20%'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildDropdown(
                              label: 'Payment Mode',
                              value: _paymentMode,
                              items: _paymentModes,
                              onChanged: (value) => setState(() => _paymentMode = value ?? 'Cash'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // Fixed Submit Button
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
                    onPressed: _isFormValid() ? _submitBooking : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC90D0D),
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Submit Booking',
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
      ),
    );
  }

  Widget _buildLoadTypeButton(String type) {
    final isSelected = _loadType == type;
    final isPartialLoad = type == 'Partial Load';
    
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _loadType = type),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFC90D0D) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFC90D0D),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPartialLoad ? Icons.local_shipping_outlined : Icons.local_shipping,
                size: 24,
                color: isSelected ? Colors.white : const Color(0xFFC90D0D),
              ),
              const SizedBox(height: 4),
              Text(
                type,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFFC90D0D),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSelector({
    required String label,
    required String? value,
    required VoidCallback onTap,
    required bool isPickup,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE0E0E0)),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade50,
        ),
        child: Row(
          children: [
            Icon(
              isPickup ? Icons.my_location : Icons.location_on,
              color: const Color(0xFFC90D0D),
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFC90D0D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value ?? 'Tap to Select',
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 14,
                      fontWeight: value != null ? FontWeight.w600 : FontWeight.normal,
                      color: value == null ? Colors.grey.shade600 : Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontFamily: 'Times New Roman', fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
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
        suffixIcon: suffixIcon,
      ),
      validator: (value) => value?.trim().isEmpty == true ? 'Required' : null,
    );
  }


  Widget _buildDateField() {
    return InkWell(
      onTap: _selectDate,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE0E0E0)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Color(0xFFC90D0D), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _pickupDate != null 
                    ? DateFormat('dd MMM yyyy').format(_pickupDate!)
                    : 'Pickup Date',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 14,
                  color: _pickupDate == null ? Colors.grey.shade600 : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField() {
    return InkWell(
      onTap: _selectTime,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE0E0E0)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: Color(0xFFC90D0D), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _pickupTime != null 
                    ? _pickupTime!.format(context)
                    : 'Pickup Time',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 14,
                  color: _pickupTime == null ? Colors.grey.shade600 : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoodsVehicleGrid() {
    return Column(
      children: [
        // First row: Category and Package Type
        Row(
          children: [
            Expanded(
              child: _buildDropdown(
                label: 'Category',
                value: _goodsCategory,
                items: _goodsCategories,
                onChanged: (value) => setState(() => _goodsCategory = value),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildDropdown(
                label: 'Package Type',
                value: _packageType,
                items: _packageTypes,
                onChanged: (value) => setState(() => _packageType = value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Second row: Quantity and Vehicle Type
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _quantityController,
                label: 'Quantity (Tons)',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildDropdown(
                label: 'Vehicle Type',
                value: _vehicleType,
                items: _vehicleTypes,
                onChanged: (value) => setState(() => _vehicleType = value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Third row: Tyre Count
        Row(
          children: [
            Expanded(
              child: _buildDropdown(
                label: 'Tyre Count',
                value: _tyreCount,
                items: _tyreCounts,
                onChanged: (value) => setState(() => _tyreCount = value),
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(child: SizedBox()), // Empty space to maintain layout
          ],
        ),
      ],
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
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: const TextStyle(fontFamily: 'Times New Roman', fontSize: 14),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Required' : null,
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
  }) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      enabled: false,
      style: const TextStyle(fontFamily: 'Times New Roman', fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: 'Times New Roman', fontSize: 13, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
      ),
    );
  }

  Future<void> _openLocationSelector({required bool isPickup}) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LocationSelectorModal(isPickup: isPickup),
    );

    if (result != null) {
      setState(() {
        if (isPickup) {
          _pickupLocation = result;
        } else {
          _dropLocation = result;
        }
      });
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _pickupDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
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
      setState(() => _pickupDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _pickupTime ?? TimeOfDay.now(),
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
      setState(() => _pickupTime = picked);
    }
  }


  String _getDestinationPayment() {
    final advancePercent = int.parse(_advancePaymentPercent.replaceAll('%', ''));
    return '${100 - advancePercent}%';
  }

  bool _isFormValid() {
    return _pickupLocation != null &&
           _dropLocation != null &&
           _goodsCategory != null &&
           _packageType != null &&
           _quantityController.text.trim().isNotEmpty &&
           _vehicleType != null &&
           _tyreCount != null &&
           _pickupDate != null &&
           _pickupTime != null;
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate() && _isFormValid()) {
      // Print all form data to console
      print('=== BOOKING SUBMISSION ===');
      print('Load Type: $_loadType');
      print('Pickup Location: ${_pickupLocation?['address']} (${_pickupLocation?['lat']}, ${_pickupLocation?['lng']})');
      print('Pickup Contact: ${_pickupLocation?['name']} - ${_pickupLocation?['mobile']}');
      print('Drop Location: ${_dropLocation?['address']} (${_dropLocation?['lat']}, ${_dropLocation?['lng']})');
      print('Drop Contact: ${_dropLocation?['name']} - ${_dropLocation?['mobile']}');
      print('Pickup Date: ${_pickupDate != null ? DateFormat('dd MMM yyyy').format(_pickupDate!) : 'Not selected'}');
      print('Pickup Time: ${_pickupTime?.format(context) ?? 'Not selected'}');
      print('Goods Category: $_goodsCategory');
      print('Package Type: $_packageType');
      print('Quantity: ${_quantityController.text} Tons');
      print('Vehicle Type: $_vehicleType');
      print('Tyre Count: $_tyreCount');
      print('Advance Payment: $_advancePaymentPercent');
      print('Destination Payment: ${_getDestinationPayment()}');
      print('Payment Mode: $_paymentMode');
      print('========================');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Booking Created Successfully!',
            style: TextStyle(fontFamily: 'Times New Roman'),
          ),
          backgroundColor: Color(0xFFC90D0D),
          duration: Duration(seconds: 3),
        ),
      );

      // Navigate back after delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    } else {
      // Auto-scroll to first incomplete field
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}