String formatTruckNumber(String input) {
  final cleaned = input.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').toUpperCase();
  if (cleaned.isEmpty) return '';

  // Attempt to format as AA00AA0000 if possible
  final buffer = StringBuffer();
  final chunks = <int>[2, 2, 2, cleaned.length - 6];
  int index = 0;
  for (final size in chunks) {
    if (size <= 0 || index >= cleaned.length) continue;
    final end = (index + size).clamp(0, cleaned.length);
    buffer.write(cleaned.substring(index, end));
    index = end;
  }
  if (index < cleaned.length) {
    buffer.write(cleaned.substring(index));
  }
  return buffer.toString();
}

String sanitizeSearch(String input) {
  return formatTruckNumber(input).toLowerCase();
}
