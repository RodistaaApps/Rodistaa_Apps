import 'package:flutter/foundation.dart';
import '../data/mock_profile.dart';
import '../models/operator_profile.dart';
import '../services/mock_data.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider() {
    _load();
  }

  final ProfileService _service = ProfileService.instance;
  OperatorProfile _profile = mockProfile;
  ProfileMetrics _metrics = const ProfileMetrics(kmDriven: 0, deliveries: 0, rating: 0);
  bool _isLoading = true;

  OperatorProfile get profile => _profile;
  ProfileMetrics get metrics => _metrics;
  bool get isLoading => _isLoading;

  Future<void> _load() async {
    _profile = await _service.fetchProfile();
    _metrics = await _service.fetchMetrics();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile(OperatorProfile updatedProfile) async {
    _profile = updatedProfile.copyWith(lastUpdated: DateTime.now());
    await _service.saveProfile(_profile);
    _profile = updatedProfile.copyWith(
      lastUpdated: DateTime.now(),
    );
    notifyListeners();
  }

  Future<void> updateProfilePhoto(String? photoUrl) async {
    _profile = _profile.copyWith(
      profilePhotoUrl: photoUrl,
      lastUpdated: DateTime.now(),
    );
    await _service.saveProfile(_profile);
    _profile = _profile.copyWith(
      profilePhotoUrl: photoUrl,
      lastUpdated: DateTime.now(),
    );
    notifyListeners();
  }

  Future<void> updateProfileBasics({
    required String name,
    required String phone,
    required String address,
  }) async {
    final parts = address.split(',');
    final street = parts.isNotEmpty ? parts.first.trim() : address;
    final city = parts.length > 1 ? parts[1].trim() : _profile.city;
    final updated = _profile.copyWith(
      name: name,
      phoneNumber: phone,
      streetAddress: street,
      city: city,
      lastUpdated: DateTime.now(),
    );
    await updateProfile(updated);
  }

  Future<void> updateMetrics(ProfileMetrics metrics) async {
    _metrics = metrics;
    await _service.saveMetrics(metrics);
    notifyListeners();
  }

  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();
    await _load();
  }
}

