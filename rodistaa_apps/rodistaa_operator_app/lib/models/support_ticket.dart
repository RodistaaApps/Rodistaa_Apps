enum TicketStatus {
  open,
  inProgress,
  resolved,
  closed,
}

enum TicketCategory {
  paymentIssues,
  technicalProblems,
  accountIssues,
  shipmentIssues,
  other,
}

class TicketReply {
  final String replyId;
  final String ticketId;
  final String message;
  final bool isFromSupport;
  final DateTime timestamp;
  final List<String> attachments;

  TicketReply({
    required this.replyId,
    required this.ticketId,
    required this.message,
    required this.isFromSupport,
    required this.timestamp,
    this.attachments = const [],
  });

  factory TicketReply.fromJson(Map<String, dynamic> json) {
    return TicketReply(
      replyId: json['replyId'] as String,
      ticketId: json['ticketId'] as String,
      message: json['message'] as String? ?? '',
      isFromSupport: json['isFromSupport'] as bool? ?? false,
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
      attachments: (json['attachments'] as List<dynamic>? ?? const []).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'replyId': replyId,
      'ticketId': ticketId,
      'message': message,
      'isFromSupport': isFromSupport,
      'timestamp': timestamp.toIso8601String(),
      'attachments': attachments,
    };
  }
}

class SupportTicket {
  final String ticketId;
  final String operatorId;
  final TicketCategory category;
  final String subject;
  final String description;
  final TicketStatus status;
  final List<String> attachments;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;
  final DateTime? resolvedAt;
  final List<TicketReply> replies;

  SupportTicket({
    required this.ticketId,
    required this.operatorId,
    required this.category,
    required this.subject,
    required this.description,
    required this.status,
    this.attachments = const [],
    required this.createdAt,
    required this.lastUpdatedAt,
    this.resolvedAt,
    this.replies = const [],
  });

  String get categoryLabel {
    switch (category) {
      case TicketCategory.paymentIssues:
        return 'Payment Issues';
      case TicketCategory.technicalProblems:
        return 'Technical Problems';
      case TicketCategory.accountIssues:
        return 'Account Issues';
      case TicketCategory.shipmentIssues:
        return 'Shipment Issues';
      case TicketCategory.other:
        return 'Other';
    }
  }

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      ticketId: json['ticketId'] as String,
      operatorId: json['operatorId'] as String? ?? '',
      category: TicketCategory.values.firstWhere(
        (category) => category.name == json['category'],
        orElse: () => TicketCategory.other,
      ),
      subject: json['subject'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: TicketStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => TicketStatus.open,
      ),
      attachments: (json['attachments'] as List<dynamic>? ?? const []).map((e) => e as String).toList(),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      lastUpdatedAt: DateTime.tryParse(json['lastUpdatedAt'] as String? ?? '') ?? DateTime.now(),
      resolvedAt: json['resolvedAt'] != null ? DateTime.tryParse(json['resolvedAt'] as String) : null,
      replies: (json['replies'] as List<dynamic>? ?? const [])
          .map((reply) => TicketReply.fromJson(reply as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticketId': ticketId,
      'operatorId': operatorId,
      'category': category.name,
      'subject': subject,
      'description': description,
      'status': status.name,
      'attachments': attachments,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
      'replies': replies.map((reply) => reply.toJson()).toList(),
    };
  }
}
