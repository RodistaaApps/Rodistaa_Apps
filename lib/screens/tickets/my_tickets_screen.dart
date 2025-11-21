import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../models/support_ticket.dart';
import '../../providers/ticket_provider.dart';

class MyTicketsScreen extends StatefulWidget {
  const MyTicketsScreen({super.key});

  @override
  State<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> {
  TicketStatus? _statusFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.white,
        title: const Text('My Tickets'),
      ),
      body: Consumer<TicketProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final tickets = _filteredTickets(provider.tickets);
          return Column(
            children: [
              _StatusFilterRow(
                current: _statusFilter,
                onChanged: (status) => setState(() => _statusFilter = status),
              ),
              Expanded(
                child: tickets.isEmpty
                    ? const _EmptyTicketsState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: tickets.length,
                        itemBuilder: (context, index) {
                          final ticket = tickets[index];
                          return _TicketCard(
                            ticket: ticket,
                            onTap: () => _openTicketDetail(context, provider, ticket),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryRed,
        onPressed: () => _openCreateTicketSheet(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  List<SupportTicket> _filteredTickets(List<SupportTicket> tickets) {
    if (_statusFilter == null) return tickets;
    return tickets.where((t) => t.status == _statusFilter).toList();
  }

  Future<void> _openCreateTicketSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => const _CreateTicketSheet(),
    );
  }

  Future<void> _openTicketDetail(
    BuildContext context,
    TicketProvider provider,
    SupportTicket ticket,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _TicketDetailSheet(ticketId: ticket.ticketId),
    );
    if (mounted) {
      await provider.refresh();
    }
  }
}

class _StatusFilterRow extends StatelessWidget {
  const _StatusFilterRow({
    required this.current,
    required this.onChanged,
  });

  final TicketStatus? current;
  final ValueChanged<TicketStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    const statuses = [
      TicketStatus.open,
      TicketStatus.inProgress,
      TicketStatus.resolved,
    ];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FilterChip(
            label: const Text('All'),
            selected: current == null,
            onSelected: (_) => onChanged(null),
          ),
          ...statuses.map(
            (status) => FilterChip(
              label: Text(status.name.toUpperCase()),
              selected: current == status,
              onSelected: (_) => onChanged(status),
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({
    required this.ticket,
    required this.onTap,
  });

  final SupportTicket ticket;
  final VoidCallback onTap;

  Color _statusColor(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return Colors.orange;
      case TicketStatus.inProgress:
        return Colors.blue;
      case TicketStatus.resolved:
        return Colors.green;
      case TicketStatus.closed:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        title: Text(
          ticket.subject,
          style: const TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticket.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontFamily: 'Times New Roman'),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('dd MMM, hh:mm a').format(ticket.createdAt),
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 12,
                color: Color(0xFF777777),
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _statusColor(ticket.status).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            ticket.status.name.toUpperCase(),
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: _statusColor(ticket.status),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyTicketsState extends StatelessWidget {
  const _EmptyTicketsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.confirmation_number_outlined, size: 72, color: Color(0xFFCCCCCC)),
          SizedBox(height: 12),
          Text(
            'No tickets yet',
            style: TextStyle(fontFamily: 'Times New Roman', fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _CreateTicketSheet extends StatefulWidget {
  const _CreateTicketSheet();

  @override
  State<_CreateTicketSheet> createState() => _CreateTicketSheetState();
}

class _CreateTicketSheetState extends State<_CreateTicketSheet> {
  final _formKey = GlobalKey<FormState>();
  TicketCategory _category = TicketCategory.paymentIssues;
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Create ticket',
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<TicketCategory>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: TicketCategory.values
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category.name.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _category = value);
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _subjectController,
              decoration: const InputDecoration(labelText: 'Subject'),
              validator: (value) => value == null || value.isEmpty ? 'Enter a subject' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 4,
              validator: (value) => value == null || value.length < 10 ? 'Add more details' : null,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _isSubmitting ? null : () => _submit(context),
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.send, color: Colors.white),
              label: const Text(
                'Submit ticket',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                minimumSize: const Size.fromHeight(48),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    await context.read<TicketProvider>().createTicket(
          category: _category,
          subject: _subjectController.text.trim(),
          description: _descriptionController.text.trim(),
        );
    if (mounted) {
      setState(() => _isSubmitting = false);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ticket created successfully')),
      );
    }
  }
}

class _TicketDetailSheet extends StatefulWidget {
  const _TicketDetailSheet({required this.ticketId});

  final String ticketId;

  @override
  State<_TicketDetailSheet> createState() => _TicketDetailSheetState();
}

class _TicketDetailSheetState extends State<_TicketDetailSheet> {
  final TextEditingController _replyController = TextEditingController();
  bool _isSending = false;
  bool _isResolving = false;

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TicketProvider>(
      builder: (context, provider, _) {
        final ticket = provider.getTicketById(widget.ticketId);
        if (ticket == null) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Text('Ticket not found'),
          );
        }

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      ticket.subject,
                      style: const TextStyle(
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    ticket.status.name.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 11,
                      color: AppColors.primaryRed,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 260,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: ticket.replies.length,
                  itemBuilder: (context, index) {
                    final reply = ticket.replies[index];
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 16,
                        backgroundColor: reply.isFromSupport ? AppColors.primaryRed : Colors.grey[300],
                        child: Icon(
                          reply.isFromSupport ? Icons.support_agent : Icons.person,
                          size: 16,
                          color: reply.isFromSupport ? Colors.white : Colors.black87,
                        ),
                      ),
                      title: Text(
                        reply.message,
                        style: const TextStyle(fontFamily: 'Times New Roman'),
                      ),
                      subtitle: Text(
                        DateFormat('dd MMM, hh:mm a').format(reply.timestamp),
                        style: const TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 11,
                          color: Color(0xFF777777),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _replyController,
                decoration: const InputDecoration(
                  hintText: 'Add a reply...',
                  border: OutlineInputBorder(),
                ),
                minLines: 1,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isResolving || ticket.status == TicketStatus.resolved
                          ? null
                          : () => _markResolved(context),
                      child: _isResolving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Mark resolved',
                              style: TextStyle(fontFamily: 'Times New Roman'),
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSending ? null : () => _sendReply(context),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryRed),
                      child: _isSending
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text(
                              'Send',
                              style: TextStyle(
                                fontFamily: 'Times New Roman',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Future<void> _sendReply(BuildContext context) async {
    if (_replyController.text.trim().isEmpty) return;
    setState(() => _isSending = true);
    await context.read<TicketProvider>().addReply(
          ticketId: widget.ticketId,
          message: _replyController.text.trim(),
          isFromSupport: false,
        );
    if (mounted) {
      _replyController.clear();
      setState(() => _isSending = false);
    }
  }

  Future<void> _markResolved(BuildContext context) async {
    setState(() => _isResolving = true);
    await context.read<TicketProvider>().updateStatus(widget.ticketId, TicketStatus.resolved);
    if (mounted) {
      setState(() => _isResolving = false);
    }
  }
}

