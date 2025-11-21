import 'package:flutter/material.dart';

import '../models/address_model.dart';
import '../services/address_store.dart';
import 'address_sheet.dart';

class AddressSelector extends StatefulWidget {
  final String label;
  final String placeholder;
  final Color iconColor;
  final AddressStore store;
  final AddressModel? initialAddress;
  final ValueChanged<AddressModel?> onChanged;
  final bool isPickup;

  const AddressSelector({
    Key? key,
    required this.label,
    required this.placeholder,
    required this.iconColor,
    required this.store,
    required this.onChanged,
    required this.isPickup,
    this.initialAddress,
  }) : super(key: key);

  @override
  State<AddressSelector> createState() => _AddressSelectorState();
}

class _AddressSelectorState extends State<AddressSelector> {
  AddressModel? _selected;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialAddress;
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    if (_selected != null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final last = await widget.store.loadLastSelected();
    if (!mounted) return;
    setState(() {
      _selected = last;
      _isLoading = false;
    });
    if (last != null) {
      widget.onChanged(last);
    }
  }

  Future<void> _openSheet() async {
    final result = await showModalBottomSheet<AddressModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddressSheet(
        store: widget.store,
        isPickup: widget.isPickup,
      ),
    );
    if (result != null) {
      setState(() => _selected = result);
      widget.onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _isLoading ? null : _openSheet,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on,
                  color: widget.iconColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _isLoading
                      ? const Text(
                          'Loading saved addresses...',
                          style: TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        )
                      : _selected == null
                          ? Text(
                              widget.placeholder,
                              style: const TextStyle(
                                fontFamily: 'Times New Roman',
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selected!.name,
                                  style: const TextStyle(
                                    fontFamily: 'Times New Roman',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _selected!.mobile,
                                  style: TextStyle(
                                    fontFamily: 'Times New Roman',
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _selected!.fullAddress,
                                  style: TextStyle(
                                    fontFamily: 'Times New Roman',
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey.shade500,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

