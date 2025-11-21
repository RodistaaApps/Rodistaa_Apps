import 'package:flutter/foundation.dart';
import '../data/mock_transactions.dart';
import '../models/transaction.dart';
import '../services/mock_data.dart';

class TransactionProvider extends ChangeNotifier {
  TransactionProvider() {
    _load();
  }

  final TransactionService _service = TransactionService.instance;
  List<Transaction> _transactions = mockTransactions;
  bool _isLoading = true;

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;

  List<Transaction> get creditTransactions =>
      _transactions.where((t) => t.type == TransactionType.credit).toList();

  List<Transaction> get debitTransactions =>
      _transactions.where((t) => t.type == TransactionType.debit).toList();

  List<Transaction> get pendingTransactions =>
      _transactions.where((t) => t.status == TransactionStatus.pending).toList();

  double get totalEarnings {
    return creditTransactions
        .where((t) => t.status == TransactionStatus.completed)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalDeductions {
    return debitTransactions
        .where((t) => t.status == TransactionStatus.completed)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get netEarnings => totalEarnings - totalDeductions;

  double get pendingAmount {
    return pendingTransactions.fold(0.0, (sum, t) => sum + t.amount);
  }

  Future<void> _load() async {
    _transactions = await _service.fetchTransactions();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() => _load();

  Future<String> downloadInvoice(Transaction transaction) {
    return _service.downloadInvoice(transaction);
  }
}

