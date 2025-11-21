import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/address_model.dart';

/// Persists pickup/drop addresses locally using SharedPreferences.
class AddressStore {
  static const _storagePrefix = 'saved_addresses_v1_';
  static const _lastSelectedPrefix = 'saved_addresses_last_v1_';

  final String key;

  const AddressStore(this.key);

  String get _storageKey => '$_storagePrefix$key';
  String get _lastSelectedKey => '$_lastSelectedPrefix$key';

  Future<List<AddressModel>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => AddressModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveAll(List<AddressModel> addresses) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded =
        jsonEncode(addresses.map((address) => address.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  Future<void> add(AddressModel address, {int maxAddresses = 5}) async {
    final addresses = await load();
    addresses.removeWhere((element) => element.id == address.id);
    addresses.insert(0, address);
    if (addresses.length > maxAddresses) {
      addresses.removeRange(maxAddresses, addresses.length);
    }
    await saveAll(addresses);
    await setLastSelected(address.id);
  }

  Future<void> remove(String id) async {
    final addresses = await load();
    addresses.removeWhere((element) => element.id == id);
    await saveAll(addresses);

    final prefs = await SharedPreferences.getInstance();
    final lastId = prefs.getString(_lastSelectedKey);
    if (lastId == id) {
      if (addresses.isNotEmpty) {
        await setLastSelected(addresses.first.id);
      } else {
        await prefs.remove(_lastSelectedKey);
      }
    }
  }

  Future<AddressModel?> loadLastSelected() async {
    final prefs = await SharedPreferences.getInstance();
    final lastId = prefs.getString(_lastSelectedKey);
    final addresses = await load();
    if (lastId == null) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
    try {
      return addresses.firstWhere((address) => address.id == lastId);
    } catch (_) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }

  Future<void> setLastSelected(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSelectedKey, id);
  }
}

