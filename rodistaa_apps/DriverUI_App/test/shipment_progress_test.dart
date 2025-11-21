import 'package:flutter_test/flutter_test.dart';
import 'package:rodistaa_driver_app/widgets/shipment_card_final.dart';

void main() {
  test('progressVisualStates returns expected steps', () {
    final states = progressVisualStates(2);
    expect(states.length, 4);
    expect(states[0].isCompleted, isTrue);
    expect(states[1].isCompleted, isTrue);
    expect(states[2].isCurrent, isTrue);
    expect(states[3].isCompleted, isFalse);
  });
}


