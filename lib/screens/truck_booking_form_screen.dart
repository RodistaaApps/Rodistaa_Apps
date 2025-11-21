import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/map_location_picker.dart';

class TruckBookingFormScreen extends StatefulWidget {
  const TruckBookingFormScreen({super.key});

  @override
  State<TruckBookingFormScreen> createState() => _TruckBookingFormScreenState();
}

class _TruckBookingFormScreenState extends State<TruckBookingFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  String _loadType = 'Partial Load';
  Map<String, dynamic>? _pickupLocation;
  Map<String, dynamic>? _dropLocation;
  DateTime? _pickupDate;
  TimeOfDay? _pickupTime;

  final TextEditingController _senderNameController = TextEditingController();
  final TextEditingController _senderMobileController = TextEditingController();
  final TextEditingController _receiverNameController = TextEditingController();
  final TextEditingController _receiverMobileController = TextEditingController();
  final TextEditingController _goodsDescriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _savedAddressController = TextEditingController();

  String? _goodsCategory;
  String? _packageType;
  String _vehicleType = 'Open';
  int _tireCount = 12;
  bool _includeInsurance = false;
  String _sourcePaymentPercent = '50%';
  String _paymentMode = 'Cash';
  bool _isAddressSaved = false;

  final List<String> _goodsCategories = const [
    'Food',
    'Electronics',
    'Machinery',
    'Furniture',
    'Chemicals',
    'Textiles',
    'Auto Parts',
    'Cement',
    'Medicines',
    'Others',
  ];

  final List<String> _packageTypes = const ['Cartons', 'Pallets', 'Drums', 'Bags', 'Loose'];
  final List<String> _vehicleTypes = const ['Open', 'Closed'];
  final List<int> _tireCounts = const [12, 10, 8, 6, 4];
  final List<String> _paymentPercents = const ['10%', '20%', '50%', '100%'];
  final List<String> _paymentModes = const ['Cash', 'UPI', 'Bank Transfer'];

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _senderNameController.dispose();
    _senderMobileController.dispose();
    _receiverNameController.dispose();
    _receiverMobileController.dispose();
    _goodsDescriptionController.dispose();
    _quantityController.dispose();
    _savedAddressController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAddress = prefs.getString('saved_address');
    if (savedAddress != null) {
      setState(() {
        _savedAddressController.text = savedAddress;
        _isAddressSaved = true;
      });
    }
  }

  Future<void> _saveAddress() async {
    if (_savedAddressController.text.trim().isEmpty) {
      _showSnack('Please enter an address to save', isError: true);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_address', _savedAddressController.text.trim());
    setState(() {
      _isAddressSaved = true;
    });
    _showSnack('Address saved successfully!');
  }

  Future<void> _changeAddress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_address');
    setState(() {
      _isAddressSaved = false;
      _savedAddressController.clear();
    });
    _showSnack('Address cleared. You can enter a new one.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
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
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Times New Roman',
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Load Type Selection
              Row(
                children: [
                  Expanded(
                    child: _buildLoadTypeButton(
                      icon: Icons.local_shipping_outlined,
                      title: 'Partial Load',
                      subtitle: '5-10 Tons',
                      isSelected: _loadType == 'Partial Load',
                      onTap: () => setState(() => _loadType = 'Partial Load'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildLoadTypeButton(
                      icon: Icons.local_shipping,
                      title: 'Full Load',
                      subtitle: '15-45 Tons',
                      isSelected: _loadType == 'Full Load',
                      onTap: () => setState(() => _loadType = 'Full Load'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Pickup & Drop Locations
              Row(
                children: [
                  Expanded(
                    child: _buildLocationField(
                      label: 'Pickup Location',
                      value: _pickupLocation?['address'],
                      onTap: _selectPickupLocation,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildLocationField(
                      label: 'Drop Location',
                      value: _dropLocation?['address'],
                      onTap: _selectDropLocation,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Pickup Date & Time
              Row(
                children: [
                  Expanded(
                    child: _buildDateTimeField(
                      label: 'Pickup Date',
                      value: _pickupDate != null ? DateFormat('dd MMM yyyy').format(_pickupDate!) : null,
                      icon: Icons.calendar_today,
                      onTap: _selectPickupDate,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildDateTimeField(
                      label: 'Pickup Time',
                      value: _pickupTime?.format(context),
                      icon: Icons.access_time,
                      onTap: _selectPickupTime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Sender & Receiver Names
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _senderNameController,
                      label: 'Sender Name',
                      icon: Icons.person,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField(
                      controller: _receiverNameController,
                      label: 'Receiver Name',
                      icon: Icons.person,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Sender & Receiver Mobile
              Row(
                children: [
                  Expanded(
                    child: _buildPhoneField(
                      controller: _senderMobileController,
                      label: 'Sender Mobile',
                      onPickContact: _pickSenderContact,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildPhoneField(
                      controller: _receiverMobileController,
                      label: 'Receiver Mobile',
                      onPickContact: _pickReceiverContact,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Saved Delivery Address Section
              const Text(
                'Saved Delivery Address',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _savedAddressController,
                label: 'Enter full delivery address',
                icon: Icons.location_on,
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _isAddressSaved ? _changeAddress : _saveAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC90D0D),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  _isAddressSaved ? 'Change Address' : 'Save Address',
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Times New Roman',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Goods Category & Package Type
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      label: 'Goods Category',
                      value: _goodsCategory,
                      items: _goodsCategories,
                      onChanged: (v) => setState(() => _goodsCategory = v),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildDropdown(
                      label: 'Package Type',
                      value: _packageType,
                      items: _packageTypes,
                      onChanged: (v) => setState(() => _packageType = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Goods Description & Quantity
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _goodsDescriptionController,
                      label: 'Goods Description',
                      icon: Icons.description,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField(
                      controller: _quantityController,
                      label: 'Quantity (Tons)',
                      icon: Icons.scale,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Vehicle Type & Tyre Count
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      label: 'Vehicle Type',
                      value: _vehicleType,
                      items: _vehicleTypes,
                      onChanged: (value) => setState(() => _vehicleType = value ?? 'Open'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _tireCount,
                      decoration: _inputDecoration('Vehicle Tyre Count').copyWith(
                        prefixIcon: const Icon(Icons.tire_repair, color: Color(0xFFC90D0D), size: 18),
                      ),
                      items: _tireCounts
                          .map((count) => DropdownMenuItem(
                                value: count,
                                child: Text('$count Tyres', style: const TextStyle(fontFamily: 'Times New Roman', fontSize: 14)),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => _tireCount = value ?? 12),
                      validator: (v) => v == null ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Insurance Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _includeInsurance,
                    activeColor: const Color(0xFFC90D0D),
                    onChanged: (value) => setState(() => _includeInsurance = value ?? false),
                  ),
                  const Expanded(
                    child: Text(
                      'Include Insurance for this Load',
                      style: TextStyle(fontFamily: 'Times New Roman', fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Payment Details
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      label: 'Source Payment %',
                      value: _sourcePaymentPercent,
                      items: _paymentPercents,
                      onChanged: (value) => setState(() => _sourcePaymentPercent = value ?? '50%'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildReadOnlyField(
                      label: 'Destination Payment %',
                      value: _destinationPayment,
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
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ElevatedButton(
            onPressed: _submitBooking,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC90D0D),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'Submit Booking',
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
    );
  }

  void _submitBooking() {
    if (!_formKey.currentState!.validate()) {
      _showSnack('Please fill all required fields', isError: true);
      return;
    }

    if (_pickupLocation == null || _dropLocation == null) {
      _showSnack('Please select pickup and drop locations', isError: true);
      return;
    }

    if (_pickupDate == null || _pickupTime == null) {
      _showSnack('Please select pickup date and time', isError: true);
      return;
    }

    if (_quantityController.text.isNotEmpty) {
      final weight = double.tryParse(_quantityController.text);
      if (weight != null) {
        if (_loadType == 'Partial Load' && (weight < 5 || weight > 10)) {
          _showSnack('PTL weight must be between 5 and 10 tons', isError: true);
          return;
        }
        if (_loadType == 'Full Load' && (weight < 15 || weight > 45)) {
          _showSnack('FTL weight must be between 15 and 45 tons', isError: true);
          return;
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: Color(0xFFC90D0D), size: 32),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Booking Created!',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  color: Color(0xFFC90D0D),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: const Text(
          'Your trucking booking has been created successfully.',
          style: TextStyle(fontFamily: 'Times New Roman'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text(
              'Done',
              style: TextStyle(
                color: Color(0xFFC90D0D),
                fontWeight: FontWeight.bold,
                fontFamily: 'Times New Roman',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectPickupLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapLocationPicker(title: 'Select Pickup Location'),
      ),
    );
    if (result != null) {
      setState(() => _pickupLocation = result);
    }
  }

  Future<void> _selectDropLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapLocationPicker(title: 'Select Drop Location'),
      ),
    );
    if (result != null) {
      setState(() => _dropLocation = result);
    }
  }

  Future<void> _selectPickupDate() async {
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

  Future<void> _selectPickupTime() async {
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

  void _pickSenderContact() {
    // Mock contact picker
    _showSnack('Contact picker would open here');
  }

  void _pickReceiverContact() {
    // Mock contact picker
    _showSnack('Contact picker would open here');
  }

  Widget _buildLoadTypeButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC90D0D) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFC90D0D) : Colors.grey.shade300,
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: isSelected ? Colors.white : const Color(0xFFC90D0D)),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 10,
                color: isSelected ? Colors.white.withOpacity(0.9) : Colors.grey.shade600,
              ),
            ),
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
      borderRadius: BorderRadius.circular(10),
      child: InputDecorator(
        decoration: _inputDecoration(label).copyWith(
          suffixIcon: const Icon(Icons.location_on, color: Color(0xFFC90D0D), size: 18),
        ),
        child: Text(
          value ?? 'Select',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 13,
            color: value == null ? Colors.grey : Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
      borderRadius: BorderRadius.circular(10),
      child: InputDecorator(
        decoration: _inputDecoration(label).copyWith(
          suffixIcon: Icon(icon, color: const Color(0xFFC90D0D), size: 18),
        ),
        child: Text(
          value ?? 'Select',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 13,
            color: value == null ? Colors.grey : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField({
    required TextEditingController controller,
    required String label,
    required VoidCallback onPickContact,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      maxLength: 10,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: const TextStyle(fontFamily: 'Times New Roman', fontSize: 14),
      decoration: _inputDecoration(label).copyWith(
        prefixIcon: const Icon(Icons.phone, color: Color(0xFFC90D0D), size: 18),
        suffixIcon: IconButton(
          icon: const Icon(Icons.contact_phone, color: Color(0xFFC90D0D), size: 18),
          onPressed: onPickContact,
        ),
        counterText: '',
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Required';
        if (v.trim().length != 10) return '10 digits';
        return null;
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(fontFamily: 'Times New Roman', fontSize: 14),
      decoration: _inputDecoration(label).copyWith(
        prefixIcon: Icon(icon, color: const Color(0xFFC90D0D), size: 18),
      ),
      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
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
      decoration: _inputDecoration(label),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(fontFamily: 'Times New Roman', fontSize: 14),
                ),
              ))
          .toList(),
      onChanged: onChanged,
      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
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
      decoration: _inputDecoration(label),
    );
  }

  String get _destinationPayment => '${100 - int.parse(_sourcePaymentPercent.replaceAll('%', ''))}%';

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Times New Roman')),
        backgroundColor: isError ? Colors.red : const Color(0xFFC90D0D),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontFamily: 'Times New Roman', fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Color(0xFFC90D0D), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      errorStyle: const TextStyle(fontSize: 10, height: 0.5),
    );
  }
}