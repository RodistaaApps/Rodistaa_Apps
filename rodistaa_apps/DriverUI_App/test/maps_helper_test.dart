import 'package:flutter_test/flutter_test.dart';
import 'package:rodistaa_driver_app/utils/maps_helper.dart';

void main() {
  test('MapsHelper builds correct URIs', () {
    final uris = MapsHelper.buildUrisForTest(
      pickupLat: 12.9,
      pickupLng: 77.5,
      dropLat: 13.1,
      dropLng: 80.2,
    );

    expect(uris, isNotEmpty);
    expect(uris.first.toString(), contains('origin=12.9,77.5'));
    expect(uris.first.toString(), contains('destination=13.1,80.2'));
  });
}


