import 'dart:async';

class PaymentsService {
  PaymentsService._();

  static final PaymentsService instance = PaymentsService._();

  Future<void> requestPayment({
    required String shipmentId,
    required double amount,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
  }

  Future<void> recordCashCollection({
    required String shipmentId,
    required double amount,
    String? receiptUrl,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
  }
}

