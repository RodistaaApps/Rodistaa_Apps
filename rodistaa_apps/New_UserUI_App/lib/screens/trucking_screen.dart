import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../models/address_model.dart';
import '../services/address_store.dart';
import '../widgets/address_selector.dart';

class TruckingScreen extends StatefulWidget {
  const TruckingScreen({Key? key}) : super(key: key);

  @override
  State<TruckingScreen> createState() => _TruckingScreenState();
}

class _TruckingScreenState extends State<TruckingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  String _loadType = 'Partial Load';

  late final AddressStore _pickupStore;
  late final AddressStore _dropStore;

  AddressModel? _pickupAddress;
  AddressModel? _dropAddress;

  DateTime? _pickupDate;
  TimeOfDay? _pickupTime;

  final TextEditingController _quantityController = TextEditingController();
  String? _goodsCategory;
  int _tyreCount = 10;
  String _paymentMode = '';

  String? _quantityError;

  final List<String> _goodsCategories = [
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

  final List<int> _tyreCounts = [10, 12, 14, 16, 18];
  final List<String> _paymentModes = ['Cash', 'UPI'];

  @override
  void initState() {
    super.initState();
    _pickupStore = const AddressStore('pickup');
    _dropStore = const AddressStore('drop');
    _quantityController.addListener(_validateQuantity);
    _loadInitialAddresses();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _quantityController.removeListener(_validateQuantity);
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialAddresses() async {
    final pickup = await _pickupStore.loadLastSelected();
    final drop = await _dropStore.loadLastSelected();
    if (!mounted) return;
    setState(() {
      _pickupAddress = pickup;
      _dropAddress = drop;
    });
  }

  void _validateQuantity() {
    final text = _quantityController.text.trim();
    if (text.isEmpty) {
      setState(() => _quantityError = null);
      return;
    }

    final quantity = double.tryParse(text);
    if (quantity == null) {
      setState(() => _quantityError = 'Please enter a valid number');
      return;
    }

    if (_loadType == 'Partial Load') {
      if (quantity < 5) {
        setState(() => _quantityError = 'Minimum 5 tons required');
      } else if (quantity > 10) {
        setState(() => _quantityError = 'Maximum limit is 10 tons for Partial Load');
      } else {
        setState(() => _quantityError = null);
      }
    } else {
      if (quantity < 15) {
        setState(() => _quantityError = 'Minimum 15 tons required');
      } else if (quantity > 45) {
        setState(() => _quantityError = 'Maximum limit is 45 tons for Full Load');
      } else {
        setState(() => _quantityError = null);
      }
    }
  }

  bool get _isFormValid {
    return _pickupAddress != null &&
        _dropAddress != null &&
        _pickupDate != null &&
        _pickupTime != null &&
        _goodsCategory != null &&
        _paymentMode.isNotEmpty &&
        _quantityController.text.trim().isNotEmpty &&
        _quantityError == null;
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
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Times New Roman',
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildLoadTypeButton(
                      icon: Icons.local_shipping_outlined,
                      title: 'Partial Load',
                      isSelected: _loadType == 'Partial Load',
                      onTap: () {
                        setState(() => _loadType = 'Partial Load');
                        _validateQuantity();
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildLoadTypeButton(
                      icon: Icons.local_shipping,
                      title: 'Full Load',
                      isSelected: _loadType == 'Full Load',
                      onTap: () {
                        setState(() => _loadType = 'Full Load');
                        _validateQuantity();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              AddressSelector(
                label: 'Pickup Location',
                placeholder: 'Selected from Map or Saved Address',
                iconColor: const Color(0xFF00C853),
                store: _pickupStore,
                initialAddress: _pickupAddress,
                isPickup: true,
                onChanged: (address) {
                  setState(() => _pickupAddress = address);
                },
              ),
              const SizedBox(height: 24),

              AddressSelector(
                label: 'Drop Location',
                placeholder: 'Selected from Map or Saved Address',
                iconColor: const Color(0xFFC90D0D),
                store: _dropStore,
                initialAddress: _dropAddress,
                isPickup: false,
                onChanged: (address) {
                  setState(() => _dropAddress = address);
                },
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Pickup Date'),
                        const SizedBox(height: 8),
                        _buildDateTimeField(
                          value: _pickupDate != null
                              ? DateFormat('dd MMM yyyy').format(_pickupDate!)
                              : null,
                          icon: Icons.calendar_today,
                          onTap: _selectPickupDate,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Pickup Time'),
                        const SizedBox(height: 8),
                        _buildDateTimeField(
                          value: _pickupTime?.format(context),
                          icon: Icons.access_time,
                          onTap: _selectPickupTime,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Category of Goods'),
                        const SizedBox(height: 8),
                        _buildDropdown(
                          value: _goodsCategory,
                          items: _goodsCategories,
                          hint: 'Select category',
                          onChanged: (value) => setState(() => _goodsCategory = value),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Tyre Count'),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: _tyreCount,
                          decoration: _inputDecoration('Select tyre count'),
                          items: _tyreCounts.map((count) {
                            return DropdownMenuItem(
                              value: count,
                              child: Text(
                                '$count Tyres',
                                style: const TextStyle(
                                  fontFamily: 'Times New Roman',
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) => setState(() => _tyreCount = value ?? 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Quantity (Tons)'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _quantityController,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*'),
                            ),
                          ],
                          style: const TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 14,
                          ),
                          decoration: _inputDecoration('Enter quantity').copyWith(
                            prefixIcon: const Icon(
                              Icons.scale,
                              color: Color(0xFFC90D0D),
                              size: 20,
                            ),
                            errorText: _quantityError,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Payment Mode'),
                        const SizedBox(height: 8),
                        _buildDropdown(
                          value: _paymentMode.isEmpty ? null : _paymentMode,
                          items: _paymentModes,
                          hint: 'Select payment',
                          onChanged: (value) => setState(() => _paymentMode = value ?? ''),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isFormValid ? _submitBooking : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isFormValid ? const Color(0xFFC90D0D) : Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
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
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadTypeButton({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC90D0D) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFFC90D0D) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFFC90D0D).withOpacity(0.3)
                  : Colors.black.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: isSelected ? 12 : 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Container(
                width: 20,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
                margin: const EdgeInsets.only(bottom: 8),
              ),
            Icon(
              icon,
              size: 24,
              color: isSelected ? Colors.white : const Color(0xFFC90D0D),
            ),
            const SizedBox(height: 6),
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
            const SizedBox(height: 2),
            Text(
              title == 'Partial Load' ? '(5 to 10 Tons)' : '(15 to 45 Tons)',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 10,
                color: isSelected
                    ? Colors.white.withOpacity(0.9)
                    : const Color(0xFF777777),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Times New Roman',
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildDateTimeField({
    required String? value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: InputDecorator(
        decoration: _inputDecoration('Select').copyWith(
          suffixIcon: Icon(icon, color: const Color(0xFFC90D0D), size: 20),
        ),
        child: Text(
          value ?? 'Select',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 14,
            color: value == null ? Colors.grey.shade600 : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: _inputDecoration(hint),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: const TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 14,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
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
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFC90D0D), width: 2),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
    );
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

  void _submitBooking() {
    if (!_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please fill all required fields',
            style: TextStyle(fontFamily: 'Times New Roman'),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
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
}