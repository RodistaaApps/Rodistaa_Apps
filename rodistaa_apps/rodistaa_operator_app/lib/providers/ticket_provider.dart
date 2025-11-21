import 'package:flutter/foundation.dart';
import '../data/mock_tickets.dart';
import '../models/support_ticket.dart';
import '../services/mock_data.dart';

class TicketProvider extends ChangeNotifier {
  TicketProvider() {
    _load();
  }

  final TicketService _service = TicketService.instance;
  List<SupportTicket> _tickets = mockTickets;
  bool _isLoading = true;

  List<SupportTicket> get tickets => _tickets;
  bool get isLoading => _isLoading;

  List<SupportTicket> get openTickets =>
      _tickets.where((t) => t.status == TicketStatus.open).toList();

  List<SupportTicket> get inProgressTickets =>
      _tickets.where((t) => t.status == TicketStatus.inProgress).toList();

  List<SupportTicket> get resolvedTickets =>
      _tickets.where((t) => t.status == TicketStatus.resolved).toList();

  SupportTicket? getTicketById(String ticketId) {
    try {
      return _tickets.firstWhere((t) => t.ticketId == ticketId);
    } catch (e) {
      return null;
    }
  }

  Future<void> _load() async {
    _tickets = await _service.fetchTickets();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() => _load();

  Future<void> createTicket({
    required TicketCategory category,
    required String subject,
    required String description,
    List<String>? attachments,
  }) async {
    await _service.createTicket(
      category: category,
      subject: subject,
      description: description,
      attachments: attachments ?? [],
    );
    await _load();
  }

  Future<void> addReply({
    required String ticketId,
    required String message,
    required bool isFromSupport,
    List<String>? attachments,
  }) async {
    await _service.addReply(
      ticketId: ticketId,
      message: message,
      isFromSupport: isFromSupport,
    );
    await _load();
  }

  Future<void> updateStatus(String ticketId, TicketStatus status) async {
    await _service.updateStatus(ticketId, status);
    await _load();
  }
}

