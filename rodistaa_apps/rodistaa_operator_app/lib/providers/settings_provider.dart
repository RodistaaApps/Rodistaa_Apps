import 'package:flutter/foundation.dart';

import '../services/mock_data.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider() {
    _load();
  }

  final SettingsService _service = SettingsService.instance;
  SettingsModel _settings = SettingsModel(
    pushNotifications: true,
    showNearby: true,
    useMobileData: false,
    languageCode: 'en',
    theme: 'light',
  );
  bool _isLoading = true;
  bool _hasPendingChanges = false;

  SettingsModel get settings => _settings;
  bool get isLoading => _isLoading;
  bool get hasPendingChanges => _hasPendingChanges;

  Future<void> _load() async {
    _settings = await _service.fetchSettings();
    _isLoading = false;
    _hasPendingChanges = false;
    notifyListeners();
  }

  Future<void> refresh() => _load();

  void togglePushNotifications(bool value) {
    _settings = _settings.copyWith(pushNotifications: value);
    _hasPendingChanges = true;
    notifyListeners();
  }

  void toggleShowNearby(bool value) {
    _settings = _settings.copyWith(showNearby: value);
    _hasPendingChanges = true;
    notifyListeners();
  }

  void toggleMobileData(bool value) {
    _settings = _settings.copyWith(useMobileData: value);
    _hasPendingChanges = true;
    notifyListeners();
  }

  void changeLanguage(String? code) {
    if (code == null) return;
    _settings = _settings.copyWith(languageCode: code);
    _hasPendingChanges = true;
    notifyListeners();
  }

  void changeTheme(String? theme) {
    if (theme == null) return;
    _settings = _settings.copyWith(theme: theme);
    _hasPendingChanges = true;
    notifyListeners();
  }

  Future<void> save() async {
    await _service.saveSettings(_settings);
    _hasPendingChanges = false;
    notifyListeners();
  }
}

