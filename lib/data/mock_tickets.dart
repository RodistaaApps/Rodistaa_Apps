import '../models/support_ticket.dart';

final List<SupportTicket> mockTickets = [
  SupportTicket(
    ticketId: 'T12345',
    operatorId: 'OP001',
    category: TicketCategory.paymentIssues,
    subject: 'Payment not received',
    description: 'I completed shipment #S12340 three days ago but haven\'t received payment yet.',
    status: TicketStatus.inProgress,
    attachments: [],
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    lastUpdatedAt: DateTime.now().subtract(const Duration(hours: 5)),
    resolvedAt: null,
    replies: [
      TicketReply(
        replyId: 'R001',
        ticketId: 'T12345',
        message: 'I completed the delivery on 14th Dec but still waiting for payment.',
        isFromSupport: false,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      TicketReply(
        replyId: 'R002',
        ticketId: 'T12345',
        message: 'Thank you for contacting us. We\'re checking with the payment team and will update you shortly.',
        isFromSupport: true,
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
    ],
  ),
  SupportTicket(
    ticketId: 'T12340',
    operatorId: 'OP001',
    category: TicketCategory.technicalProblems,
    subject: 'Truck not showing in fleet',
    description: 'I added a new truck yesterday (KA-03-EF-9012) but it\'s not appearing in my fleet list.',
    status: TicketStatus.resolved,
    attachments: [],
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    lastUpdatedAt: DateTime.now().subtract(const Duration(days: 4)),
    resolvedAt: DateTime.now().subtract(const Duration(days: 4)),
    replies: [
      TicketReply(
        replyId: 'R003',
        ticketId: 'T12340',
        message: 'Added truck KA-03-EF-9012 but can\'t see it in my fleet.',
        isFromSupport: false,
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
      ),
      TicketReply(
        replyId: 'R004',
        ticketId: 'T12340',
        message: 'We found the issue. Your truck is now visible. Please check and confirm.',
        isFromSupport: true,
        timestamp: DateTime.now().subtract(const Duration(days: 4, hours: 20)),
      ),
      TicketReply(
        replyId: 'R005',
        ticketId: 'T12340',
        message: 'Yes, I can see it now. Thank you!',
        isFromSupport: false,
        timestamp: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ],
  ),
];
