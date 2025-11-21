import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const String _preferredTruckKey = 'preferred_truck_id';

  /// Get the preferred truck ID from preferences
  static Future<String?> getPreferredTruck() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_preferredTruckKey);
  }

  /// Set the preferred truck ID
  static Future<void> setPreferredTruck(String truckId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_preferredTruckKey, truckId);
  }

  /// Clear the preferred truck
  static Future<void> clearPreferredTruck() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_preferredTruckKey);
  }
}

