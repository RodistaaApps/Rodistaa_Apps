import 'package:flutter/material.dart';

class SupportTicketsScreen extends StatefulWidget {
  const SupportTicketsScreen({Key? key}) : super(key: key);

  @override
  State<SupportTicketsScreen> createState() => _SupportTicketsScreenState();
}

class _SupportTicketsScreenState extends State<SupportTicketsScreen> {
  List<Map<String, dynamic>> tickets = [
    {
      "id": "TKT-001",
      "title": "Payment not received",
      "description": "Payment for booking RDS1267 not credited",
      "status": "Open",
      "date": "05 Nov 2025",
    },
    {
      "id": "TKT-002",
      "title": "Driver contact issue",
      "description": "Unable to reach assigned driver",
      "status": "In Progress",
      "date": "03 Nov 2025",
    },
    {
      "id": "TKT-003",
      "title": "Invoice download error",
      "description": "Cannot download invoice PDF",
      "status": "Resolved",
      "date": "01 Nov 2025",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFC90D0D),
        elevation: 0,
        title: const Text(
          'Support Tickets',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Header Stats
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFC90D0D).withOpacity(0.05),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard('Open', tickets.where((t) => t['status'] == 'Open').length.toString(), Icons.pending),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard('In Progress', tickets.where((t) => t['status'] == 'In Progress').length.toString(), Icons.timelapse),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard('Resolved', tickets.where((t) => t['status'] == 'Resolved').length.toString(), Icons.check_circle),
                ),
              ],
            ),
          ),

          // Tickets List
          Expanded(
            child: tickets.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      return _buildTicketCard(tickets[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewTicket,
        backgroundColor: const Color(0xFFC90D0D),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'New Ticket',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC90D0D).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFC90D0D), size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFC90D0D),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket) {
    Color statusColor;
    switch (ticket['status']) {
      case 'Open':
        statusColor = Colors.orange;
        break;
      case 'In Progress':
        statusColor = Colors.blue;
        break;
      case 'Resolved':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC90D0D).withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC90D0D).withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _viewTicketDetails(ticket),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: statusColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        ticket['status'],
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      ticket['id'],
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  ticket['title'],
                  style: const TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  ticket['description'],
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 6),
                    Text(
                      ticket['date'],
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 12,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.support_agent, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No Support Tickets',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a ticket if you need help',
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

  void _createNewTicket() {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Support Ticket',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC90D0D),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                style: const TextStyle(fontFamily: 'Times New Roman'),
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: const TextStyle(fontFamily: 'Times New Roman'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFC90D0D), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                style: const TextStyle(fontFamily: 'Times New Roman'),
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: const TextStyle(fontFamily: 'Times New Roman'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFC90D0D), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (titleController.text.isNotEmpty && descController.text.isNotEmpty) {
                          setState(() {
                            tickets.insert(0, {
                              "id": "TKT-${(tickets.length + 1).toString().padLeft(3, '0')}",
                              "title": titleController.text,
                              "description": descController.text,
                              "status": "Open",
                              "date": "07 Nov 2025",
                            });
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ticket created successfully!',
                                  style: TextStyle(fontFamily: 'Times New Roman')),
                              backgroundColor: Color(0xFFC90D0D),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC90D0D),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _viewTicketDetails(Map<String, dynamic> ticket) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ticket['id'],
                  style: const TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC90D0D),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC90D0D).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    ticket['status'],
                    style: const TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC90D0D),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              ticket['title'],
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              ticket['description'],
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade500),
                const SizedBox(width: 8),
                Text(
                  'Created on ${ticket['date']}',
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC90D0D),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

