const Map<String, int> _tierToTyre = {
  'Mini': 10,
  'LCV': 12,
  'MCV': 14,
  'HCV': 16,
  'Trailer': 18,
};

/// Converts a textual truck type/tier label to a numeric tyre count.
int tyreCountFromLabel(String label) {
  final sanitized = label.trim();
  final numericValue = int.tryParse(sanitized);
  if (numericValue != null && numericValue > 0) {
    return numericValue;
  }
  return _tierToTyre[sanitized] ?? 12;
}

/// Returns a lightweight body type (Open/Closed) hint for UI display.
String deriveBodyType(String truckType) {
  final normalized = truckType.toLowerCase();
  if (normalized.contains('open')) return 'Open';
  if (normalized.contains('container') || normalized.contains('box') || normalized.contains('closed')) {
    return 'Closed';
  }
  if (normalized.contains('trailer') || normalized.contains('hcv') || normalized.contains('mcv')) {
    return 'Open';
  }
  return 'Closed';
}

