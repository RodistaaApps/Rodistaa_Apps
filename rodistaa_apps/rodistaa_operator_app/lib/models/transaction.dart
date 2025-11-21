enum TransactionType {
  credit,
  debit,
}

enum TransactionCategory {
  shipmentPayment,
  commission,
  refund,
  penalty,
  bonus,
}

enum TransactionStatus {
  pending,
  completed,
  failed,
}

class Transaction {
  final String transactionId;
  final String operatorId;
  final TransactionType type;
  final double amount;
  final TransactionCategory category;
  final String? shipmentId;
  final String description;
  final TransactionStatus status;
  final DateTime transactionDate;
  final String? receiptUrl;

  Transaction({
    required this.transactionId,
    required this.operatorId,
    required this.type,
    required this.amount,
    required this.category,
    this.shipmentId,
    required this.description,
    required this.status,
    required this.transactionDate,
    this.receiptUrl,
  });

  String get categoryLabel {
    switch (category) {
      case TransactionCategory.shipmentPayment:
        return 'Shipment Payment';
      case TransactionCategory.commission:
        return 'Platform Commission';
      case TransactionCategory.refund:
        return 'Refund';
      case TransactionCategory.penalty:
        return 'Penalty';
      case TransactionCategory.bonus:
        return 'Bonus';
    }
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transactionId'] as String,
      operatorId: json['operatorId'] as String? ?? '',
      type: TransactionType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => TransactionType.credit,
      ),
      amount: (json['amount'] as num).toDouble(),
      category: TransactionCategory.values.firstWhere(
        (category) => category.name == json['category'],
        orElse: () => TransactionCategory.shipmentPayment,
      ),
      shipmentId: json['shipmentId'] as String?,
      description: json['description'] as String? ?? '',
      status: TransactionStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => TransactionStatus.completed,
      ),
      transactionDate: DateTime.tryParse(json['transactionDate'] as String? ?? '') ?? DateTime.now(),
      receiptUrl: json['receiptUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'operatorId': operatorId,
      'type': type.name,
      'amount': amount,
      'category': category.name,
      'shipmentId': shipmentId,
      'description': description,
      'status': status.name,
      'transactionDate': transactionDate.toIso8601String(),
      'receiptUrl': receiptUrl,
    };
  }
}
