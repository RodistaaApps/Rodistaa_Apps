import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../providers/ticket_provider.dart';
import '../../widgets/status_badge.dart';
import 'package:intl/intl.dart';

class TicketDetailsScreen extends StatefulWidget {
  final String ticketId;

  const TicketDetailsScreen({super.key, required this.ticketId});

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  final _replyController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _addReply() async {
    if (_replyController.text.trim().isEmpty) return;

    setState(() {
      _isSubmitting = true;
    });

    await context.read<TicketProvider>().addReply(
          ticketId: widget.ticketId,
          message: _replyController.text.trim(),
          isFromSupport: false,
        );

    if (mounted) {
      setState(() {
        _isSubmitting = false;
        _replyController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.white,
        title: const Text('Ticket Details'),
      ),
      body: Consumer<TicketProvider>(
        builder: (context, provider, _) {
          final ticket = provider.getTicketById(widget.ticketId);
          if (ticket == null) {
            return const Center(child: Text('Ticket not found'));
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              ticket.subject,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          StatusBadge(
                            status: ticket.status.name,
                            label: ticket.status.name.toUpperCase(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ticket.categoryLabel,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        ticket.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const Text(
                        'Conversation',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ...ticket.replies.map((reply) => _ReplyBubble(reply: reply)),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _replyController,
                        decoration: InputDecoration(
                          hintText: 'Type your reply...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(color: AppColors.borderGray),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        maxLines: null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _isSubmitting ? null : _addReply,
                      icon: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send, color: AppColors.primaryRed),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReplyBubble extends StatelessWidget {
  final dynamic reply;

  const _ReplyBubble({required this.reply});

  @override
  Widget build(BuildContext context) {
    final isFromSupport = reply.isFromSupport;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isFromSupport ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isFromSupport) ...[
            CircleAvatar(
              backgroundColor: AppColors.primaryRed,
              child: const Icon(Icons.support_agent, color: AppColors.white, size: 20),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isFromSupport ? AppColors.lightGray : AppColors.primaryRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reply.message,
                    style: TextStyle(
                      color: isFromSupport ? Colors.black87 : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd MMM, hh:mm a').format(reply.timestamp),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isFromSupport) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              backgroundColor: AppColors.primaryRed,
              child: Icon(Icons.person, color: AppColors.white, size: 20),
            ),
          ],
        ],
      ),
    );
  }
}

