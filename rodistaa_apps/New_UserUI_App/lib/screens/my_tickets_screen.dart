import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyTicketsScreen extends StatefulWidget {
  const MyTicketsScreen({Key? key}) : super(key: key);

  @override
  State<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _tickets = [];
  bool _isLoading = true;

  // Mock tickets data
  final List<Map<String, dynamic>> _mockTickets = [
    {
      'id': 'TKT001',
      'title': 'Payment Issue',
      'description': 'Unable to complete payment for booking RDS1234',
      'category': 'Payment',
      'priority': 'High',
      'status': 'Open',
      'createdAt': DateTime.now().subtract(const Duration(hours: 2)),
      'updatedAt': DateTime.now().subtract(const Duration(minutes: 30)),
      'messages': [
        {
          'sender': 'user',
          'message': 'Unable to complete payment for booking RDS1234',
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        },
        {
          'sender': 'support',
          'message': 'We are looking into this issue. Please provide your transaction ID.',
          'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
        },
        {
          'sender': 'user',
          'message': 'Transaction ID: TXN789456123',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
        },
      ],
    },
    {
      'id': 'TKT002',
      'title': 'Driver Contact Issue',
      'description': 'Cannot reach assigned driver for booking RDS5678',
      'category': 'Driver',
      'priority': 'Medium',
      'status': 'In Progress',
      'createdAt': DateTime.now().subtract(const Duration(days: 1)),
      'updatedAt': DateTime.now().subtract(const Duration(hours: 6)),
      'messages': [
        {
          'sender': 'user',
          'message': 'Cannot reach assigned driver for booking RDS5678',
          'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        },
        {
          'sender': 'support',
          'message': 'We have contacted the driver and they will reach out to you shortly.',
          'timestamp': DateTime.now().subtract(const Duration(hours: 6)),
        },
      ],
    },
    {
      'id': 'TKT003',
      'title': 'App Bug Report',
      'description': 'App crashes when trying to view shipment details',
      'category': 'Technical',
      'priority': 'Low',
      'status': 'Resolved',
      'createdAt': DateTime.now().subtract(const Duration(days: 3)),
      'updatedAt': DateTime.now().subtract(const Duration(days: 1)),
      'messages': [
        {
          'sender': 'user',
          'message': 'App crashes when trying to view shipment details',
          'timestamp': DateTime.now().subtract(const Duration(days: 3)),
        },
        {
          'sender': 'support',
          'message': 'Thank you for reporting this. Our team is working on a fix.',
          'timestamp': DateTime.now().subtract(const Duration(days: 2)),
        },
        {
          'sender': 'support',
          'message': 'This issue has been resolved in the latest update. Please update your app.',
          'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTickets();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTickets() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Load mock data
    setState(() {
      _tickets = List.from(_mockTickets);
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get _openTickets {
    return _tickets.where((ticket) => ticket['status'] != 'Resolved').toList();
  }

  List<Map<String, dynamic>> get _closedTickets {
    return _tickets.where((ticket) => ticket['status'] == 'Resolved').toList();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return const Color(0xFFC90D0D);
      case 'in progress':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return const Color(0xFFC90D0D);
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'payment':
        return Icons.payment;
      case 'driver':
        return Icons.local_shipping;
      case 'technical':
        return Icons.bug_report;
      case 'general':
        return Icons.help_outline;
      default:
        return Icons.support;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Tickets',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            color: Color(0xFFC90D0D),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFFC90D0D)),
        actions: [
          IconButton(
            onPressed: _showNewTicketModal,
            icon: const Icon(Icons.add, color: Color(0xFFC90D0D)),
            tooltip: 'Raise New Ticket',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFFC90D0D),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFFC90D0D),
          labelStyle: const TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.normal,
          ),
          tabs: [
            Tab(
              text: 'Open (${_openTickets.length})',
            ),
            Tab(
              text: 'Closed (${_closedTickets.length})',
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFC90D0D),
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildTicketsList(_openTickets, isOpen: true),
                _buildTicketsList(_closedTickets, isOpen: false),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewTicketModal,
        backgroundColor: const Color(0xFFC90D0D),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTicketsList(List<Map<String, dynamic>> tickets, {required bool isOpen}) {
    if (tickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isOpen ? Icons.support_agent : Icons.check_circle_outline,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              isOpen ? 'No open tickets' : 'No closed tickets',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isOpen 
                  ? 'Tap + to raise a new support ticket'
                  : 'Your resolved tickets will appear here',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTickets,
      color: const Color(0xFFC90D0D),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          return _buildTicketCard(ticket);
        },
      ),
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showTicketDetails(ticket),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(ticket['priority']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getCategoryIcon(ticket['category']),
                        size: 18,
                        color: _getPriorityColor(ticket['priority']),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ticket['title'],
                            style: const TextStyle(
                              fontFamily: 'Times New Roman',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'ID: ${ticket['id']}',
                            style: TextStyle(
                              fontFamily: 'Times New Roman',
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(ticket['status']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getStatusColor(ticket['status']).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        ticket['status'],
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(ticket['status']),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Description
                Text(
                  ticket['description'],
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                
                // Footer Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(ticket['priority']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        ticket['priority'],
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _getPriorityColor(ticket['priority']),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        ticket['category'],
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(ticket['updatedAt']),
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM dd').format(dateTime);
    }
  }

  void _showTicketDetails(Map<String, dynamic> ticket) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TicketDetailsModal(ticket: ticket),
    );
  }

  void _showNewTicketModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NewTicketModal(
        onTicketCreated: (newTicket) {
          setState(() {
            _tickets.insert(0, newTicket);
          });
        },
      ),
    );
  }
}

class TicketDetailsModal extends StatefulWidget {
  final Map<String, dynamic> ticket;

  const TicketDetailsModal({Key? key, required this.ticket}) : super(key: key);

  @override
  State<TicketDetailsModal> createState() => _TicketDetailsModalState();
}

class _TicketDetailsModalState extends State<TicketDetailsModal> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return const Color(0xFFC90D0D);
      case 'in progress':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.ticket['title'],
                            style: const TextStyle(
                              fontFamily: 'Times New Roman',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ticket ID: ${widget.ticket['id']}',
                            style: TextStyle(
                              fontFamily: 'Times New Roman',
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(widget.ticket['status']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _getStatusColor(widget.ticket['status']).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        widget.ticket['status'],
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(widget.ticket['status']),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: widget.ticket['messages'].length,
              itemBuilder: (context, index) {
                final message = widget.ticket['messages'][index];
                final isUser = message['sender'] == 'user';
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isUser) ...[
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: const Color(0xFFC90D0D).withOpacity(0.1),
                          child: const Icon(
                            Icons.support_agent,
                            size: 16,
                            color: Color(0xFFC90D0D),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUser ? const Color(0xFFC90D0D) : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['message'],
                                style: TextStyle(
                                  fontFamily: 'Times New Roman',
                                  fontSize: 14,
                                  color: isUser ? Colors.white : Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('MMM dd, hh:mm a').format(message['timestamp']),
                                style: TextStyle(
                                  fontFamily: 'Times New Roman',
                                  fontSize: 11,
                                  color: isUser ? Colors.white70 : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isUser) ...[
                        const SizedBox(width: 8),
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey.shade200,
                          child: Icon(
                            Icons.person,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Message Input (only for open tickets)
          if (widget.ticket['status'] != 'Resolved')
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(fontFamily: 'Times New Roman'),
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(
                          fontFamily: 'Times New Roman',
                          color: Colors.grey.shade500,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Color(0xFFC90D0D)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFC90D0D),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (_messageController.text.trim().isNotEmpty) {
                          // Add message logic here
                          _messageController.clear();
                        }
                      },
                      icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class NewTicketModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onTicketCreated;

  const NewTicketModal({Key? key, required this.onTicketCreated}) : super(key: key);

  @override
  State<NewTicketModal> createState() => _NewTicketModalState();
}

class _NewTicketModalState extends State<NewTicketModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _selectedCategory = 'General';
  String _selectedPriority = 'Medium';
  bool _isSubmitting = false;

  final List<String> _categories = [
    'General',
    'Payment',
    'Driver',
    'Technical',
    'Booking',
    'Account',
  ];

  final List<String> _priorities = [
    'Low',
    'Medium',
    'High',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitTicket() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    final newTicket = {
      'id': 'TKT${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'category': _selectedCategory,
      'priority': _selectedPriority,
      'status': 'Open',
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
      'messages': [
        {
          'sender': 'user',
          'message': _descriptionController.text.trim(),
          'timestamp': DateTime.now(),
        },
      ],
    };

    widget.onTicketCreated(newTicket);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Ticket created successfully!',
            style: TextStyle(fontFamily: 'Times New Roman'),
          ),
          backgroundColor: const Color(0xFFC90D0D),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Raise New Ticket',
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC90D0D),
                  ),
                ),
              ],
            ),
          ),
          
          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      'Title',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      style: const TextStyle(fontFamily: 'Times New Roman'),
                      decoration: InputDecoration(
                        hintText: 'Brief description of your issue',
                        hintStyle: TextStyle(
                          fontFamily: 'Times New Roman',
                          color: Colors.grey.shade500,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFFC90D0D)),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    // Category and Priority Row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Category',
                                style: TextStyle(
                                  fontFamily: 'Times New Roman',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: _selectedCategory,
                                style: const TextStyle(
                                  fontFamily: 'Times New Roman',
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Color(0xFFC90D0D)),
                                  ),
                                  contentPadding: const EdgeInsets.all(16),
                                ),
                                items: _categories.map((category) {
                                  return DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategory = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Priority',
                                style: TextStyle(
                                  fontFamily: 'Times New Roman',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: _selectedPriority,
                                style: const TextStyle(
                                  fontFamily: 'Times New Roman',
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Color(0xFFC90D0D)),
                                  ),
                                  contentPadding: const EdgeInsets.all(16),
                                ),
                                items: _priorities.map((priority) {
                                  return DropdownMenuItem(
                                    value: priority,
                                    child: Text(priority),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedPriority = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Description
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      style: const TextStyle(fontFamily: 'Times New Roman'),
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Describe your issue in detail...',
                        hintStyle: TextStyle(
                          fontFamily: 'Times New Roman',
                          color: Colors.grey.shade500,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFFC90D0D)),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please describe your issue';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitTicket,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC90D0D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Submit Ticket',
                                style: TextStyle(
                                  fontFamily: 'Times New Roman',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
