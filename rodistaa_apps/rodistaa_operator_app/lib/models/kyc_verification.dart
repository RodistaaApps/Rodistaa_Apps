enum KYCStatus {
  notStarted,
  pending,
  verified,
  rejected,
}

class KYCVerification {
  final String operatorId;
  final KYCStatus status;
  final String? aadhaarNumber;
  final String? rejectionReason;
  final DateTime? submittedAt;
  final DateTime? verifiedAt;
  final DateTime? rejectedAt;

  KYCVerification({
    required this.operatorId,
    required this.status,
    this.aadhaarNumber,
    this.rejectionReason,
    this.submittedAt,
    this.verifiedAt,
    this.rejectedAt,
  });

  String get statusLabel {
    switch (status) {
      case KYCStatus.notStarted:
        return 'Not Started';
      case KYCStatus.pending:
        return 'Pending Verification';
      case KYCStatus.verified:
        return 'Verified';
      case KYCStatus.rejected:
        return 'Rejected';
    }
  }

  factory KYCVerification.fromJson(Map<String, dynamic> json) {
    return KYCVerification(
      operatorId: json['operatorId'] as String? ?? '',
      status: KYCStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => KYCStatus.notStarted,
      ),
      aadhaarNumber: json['aadhaarNumber'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      submittedAt: json['submittedAt'] != null ? DateTime.tryParse(json['submittedAt'] as String) : null,
      verifiedAt: json['verifiedAt'] != null ? DateTime.tryParse(json['verifiedAt'] as String) : null,
      rejectedAt: json['rejectedAt'] != null ? DateTime.tryParse(json['rejectedAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'operatorId': operatorId,
      'status': status.name,
      'aadhaarNumber': aadhaarNumber,
      'rejectionReason': rejectionReason,
      'submittedAt': submittedAt?.toIso8601String(),
      'verifiedAt': verifiedAt?.toIso8601String(),
      'rejectedAt': rejectedAt?.toIso8601String(),
    };
  }
}
