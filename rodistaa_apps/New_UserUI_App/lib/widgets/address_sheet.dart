import 'package:flutter/material.dart';

import '../models/address_model.dart';
import '../services/address_store.dart';
import '../screens/new_address_form.dart';

class AddressSheet extends StatefulWidget {
  final AddressStore store;
  final bool isPickup;

  const AddressSheet({
    Key? key,
    required this.store,
    required this.isPickup,
  }) : super(key: key);

  @override
  State<AddressSheet> createState() => _AddressSheetState();
}

class _AddressSheetState extends State<AddressSheet> {
  List<AddressModel> _addresses = [];
  bool _isLoading = true;
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() {
      _isLoading = true;
    });
    final addresses = await widget.store.load();
    final lastSelected = await widget.store.loadLastSelected();
    setState(() {
      _addresses = addresses;
      _selectedId = lastSelected?.id;
      _isLoading = false;
    });
  }

  Future<void> _selectAddress(AddressModel address) async {
    await widget.store.setLastSelected(address.id);
    if (!mounted) return;
    Navigator.of(context).pop(address);
  }

  Future<void> _deleteAddress(AddressModel address) async {
    await widget.store.remove(address.id);
    if (!mounted) return;
    await _loadAddresses();
  }

  Future<void> _addNewAddress() async {
    final newAddress = await Navigator.of(context).push<AddressModel>(
      MaterialPageRoute(
        builder: (_) => NewAddressFormScreen(
          isPickup: widget.isPickup,
        ),
      ),
    );
    if (newAddress != null) {
      await widget.store.add(newAddress);
      if (!mounted) return;
      Navigator.of(context).pop(newAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: widget.isPickup
                            ? const Color(0xFF00C853)
                            : const Color(0xFFC90D0D),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.isPickup
                              ? 'Select Pickup Address'
                              : 'Select Drop Address',
                          style: const TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.black54),
                        tooltip: 'Close',
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFC90D0D),
                      ),
                    )
                  : _addresses.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: _addresses.length,
                          itemBuilder: (context, index) {
                            final address = _addresses[index];
                            final isSelected = _selectedId == address.id;
                            return _buildAddressCard(address, isSelected);
                          },
                        ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: ElevatedButton.icon(
                onPressed: _addNewAddress,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Add New Address',
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC90D0D),
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(AddressModel address, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFFC90D0D).withOpacity(0.08)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isSelected ? const Color(0xFFC90D0D) : Colors.grey.shade200,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _selectAddress(address),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                Icons.location_pin,
                color: widget.isPickup
                    ? const Color(0xFF00C853)
                    : const Color(0xFFC90D0D),
                size: 26,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.name,
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? const Color(0xFFC90D0D)
                            : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      address.mobile,
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address.fullAddress,
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Radio<String>(
                    value: address.id,
                    groupValue: _selectedId,
                    activeColor: const Color(0xFFC90D0D),
                    onChanged: (_) => _selectAddress(address),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Colors.grey.shade500,
                    ),
                    onPressed: () => _deleteAddress(address),
                    tooltip: 'Delete',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 12),
          const Text(
            'No saved addresses yet',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first address to get started',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

