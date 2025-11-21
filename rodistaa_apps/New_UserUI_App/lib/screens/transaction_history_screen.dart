import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Completed', 'Pending', 'Failed'];

  // Mock transaction data
  final List<Map<String, dynamic>> _allTransactions = [
    {
      'id': 'TXN001',
      'type': 'Promote Load',
      'description': 'Premium load promotion - Hyderabad to Chennai',
      'amount': 500,
      'date': DateTime(2025, 11, 10, 14, 30),
      'status': 'Completed',
      'icon': Icons.trending_up,
      'category': 'promotion',
    },
    {
      'id': 'TXN002',
      'type': 'Load Bid Fee',
      'description': 'Bidding fee for load RDS1267',
      'amount': 75,
      'date': DateTime(2025, 11, 8, 9, 15),
      'status': 'Pending',
      'icon': Icons.gavel,
      'category': 'bid',
    },
    {
      'id': 'TXN003',
      'type': 'Premium Membership',
      'description': 'Monthly premium subscription',
      'amount': 1000,
      'date': DateTime(2025, 11, 1, 10, 0),
      'status': 'Completed',
      'icon': Icons.star,
      'category': 'subscription',
    },
    {
      'id': 'TXN004',
      'type': 'Promote Load',
      'description': 'Premium load promotion - Mumbai to Pune',
      'amount': 300,
      'date': DateTime(2025, 10, 28, 16, 45),
      'status': 'Completed',
      'icon': Icons.trending_up,
      'category': 'promotion',
    },
    {
      'id': 'TXN005',
      'type': 'Load Bid Fee',
      'description': 'Bidding fee for load RDS1245',
      'amount': 50,
      'date': DateTime(2025, 10, 25, 11, 20),
      'status': 'Failed',
      'icon': Icons.gavel,
      'category': 'bid',
    },
    {
      'id': 'TXN006',
      'type': 'Wallet Recharge',
      'description': 'Added money to wallet',
      'amount': 2000,
      'date': DateTime(2025, 10, 20, 13, 10),
      'status': 'Completed',
      'icon': Icons.account_balance_wallet,
      'category': 'wallet',
    },
    {
      'id': 'TXN007',
      'type': 'Promote Load',
      'description': 'Premium load promotion - Bangalore to Hyderabad',
      'amount': 400,
      'date': DateTime(2025, 10, 15, 8, 30),
      'status': 'Completed',
      'icon': Icons.trending_up,
      'category': 'promotion',
    },
    {
      'id': 'TXN008',
      'type': 'Load Bid Fee',
      'description': 'Bidding fee for load RDS1198',
      'amount': 100,
      'date': DateTime(2025, 10, 12, 15, 45),
      'status': 'Pending',
      'icon': Icons.gavel,
      'category': 'bid',
    },
    {
      'id': 'TXN009',
      'type': 'Document Verification',
      'description': 'KYC document verification fee',
      'amount': 25,
      'date': DateTime(2025, 10, 5, 12, 0),
      'status': 'Completed',
      'icon': Icons.verified_user,
      'category': 'verification',
    },
    {
      'id': 'TXN010',
      'type': 'Promote Load',
      'description': 'Premium load promotion - Delhi to Jaipur',
      'amount': 350,
      'date': DateTime(2025, 9, 30, 17, 20),
      'status': 'Completed',
      'icon': Icons.trending_up,
      'category': 'promotion',
    },
  ];

  List<Map<String, dynamic>> get _filteredTransactions {
    if (_selectedFilter == 'All') {
      return _allTransactions;
    }
    return _allTransactions.where((transaction) => 
        transaction['status'] == _selectedFilter).toList();
  }

  double get _totalSpent {
    return _filteredTransactions
        .where((t) => t['status'] == 'Completed')
        .fold(0.0, (sum, t) => sum + t['amount']);
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Transaction History',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            color: Color(0xFFC90D0D),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFFC90D0D)),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Summary Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFC90D0D).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFC90D0D).withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFC90D0D),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Transactions: ${_filteredTransactions.length}',
                          style: const TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFC90D0D),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total Spent: ₹${_totalSpent.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Filter Tabs
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = _selectedFilter == filter;
                  
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(
                        filter,
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : const Color(0xFFC90D0D),
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      selectedColor: const Color(0xFFC90D0D),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFC90D0D)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Transactions List
            Expanded(
              child: _filteredTransactions.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredTransactions.length,
                      itemBuilder: (context, index) {
                        return _buildTransactionCard(_filteredTransactions[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No transactions found',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _selectedFilter == 'All' 
                  ? 'Start using Rodistaa services to see your transaction history'
                  : 'No $_selectedFilter transactions found',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final status = transaction['status'] as String;
    Color statusColor;
    Color statusBgColor;
    
    switch (status) {
      case 'Completed':
        statusColor = Colors.green;
        statusBgColor = Colors.green.withOpacity(0.1);
        break;
      case 'Pending':
        statusColor = Colors.orange;
        statusBgColor = Colors.orange.withOpacity(0.1);
        break;
      case 'Failed':
        statusColor = Colors.red;
        statusBgColor = Colors.red.withOpacity(0.1);
        break;
      default:
        statusColor = Colors.grey;
        statusBgColor = Colors.grey.withOpacity(0.1);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFC90D0D).withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showTransactionDetails(transaction),
          borderRadius: BorderRadius.circular(10),
          splashColor: const Color(0xFFC90D0D).withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC90D0D).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    transaction['icon'],
                    color: const Color(0xFFC90D0D),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                
                // Transaction Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              transaction['type'],
                              style: const TextStyle(
                                fontFamily: 'Times New Roman',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Text(
                            '₹${transaction['amount']}',
                            style: const TextStyle(
                              fontFamily: 'Times New Roman',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFC90D0D),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        transaction['description'],
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('dd MMM yyyy, hh:mm a').format(transaction['date']),
                            style: TextStyle(
                              fontFamily: 'Times New Roman',
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusBgColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: statusColor.withOpacity(0.3)),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontFamily: 'Times New Roman',
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Transaction Details',
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC90D0D),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Transaction ID', transaction['id']),
                      _buildDetailRow('Type', transaction['type']),
                      _buildDetailRow('Description', transaction['description']),
                      _buildDetailRow('Amount', '₹${transaction['amount']}'),
                      _buildDetailRow('Date & Time', 
                          DateFormat('dd MMM yyyy, hh:mm a').format(transaction['date'])),
                      _buildDetailRow('Status', transaction['status']),
                      _buildDetailRow('Category', transaction['category'].toString().toUpperCase()),
                      
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      
                      if (transaction['status'] == 'Completed') ...[
                        Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green, size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Transaction completed successfully',
                              style: TextStyle(
                                fontFamily: 'Times New Roman',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ] else if (transaction['status'] == 'Pending') ...[
                        Row(
                          children: [
                            Icon(Icons.pending, color: Colors.orange, size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Transaction is being processed',
                              style: TextStyle(
                                fontFamily: 'Times New Roman',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ] else if (transaction['status'] == 'Failed') ...[
                        Row(
                          children: [
                            Icon(Icons.error, color: Colors.red, size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Transaction failed',
                              style: TextStyle(
                                fontFamily: 'Times New Roman',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                      
                      const SizedBox(height: 24),
                      
                      // Action Buttons
                      if (transaction['status'] == 'Completed') ...[
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Receipt download feature coming soon!',
                                    style: TextStyle(fontFamily: 'Times New Roman'),
                                  ),
                                  backgroundColor: const Color(0xFFC90D0D),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFC90D0D)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            icon: const Icon(Icons.download, color: Color(0xFFC90D0D)),
                            label: const Text(
                              'Download Receipt',
                              style: TextStyle(
                                fontFamily: 'Times New Roman',
                                fontSize: 14,
                                color: Color(0xFFC90D0D),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ] else if (transaction['status'] == 'Failed') ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Retry payment feature coming soon!',
                                    style: TextStyle(fontFamily: 'Times New Roman'),
                                  ),
                                  backgroundColor: const Color(0xFFC90D0D),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC90D0D),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            icon: const Icon(Icons.refresh, color: Colors.white),
                            label: const Text(
                              'Retry Payment',
                              style: TextStyle(
                                fontFamily: 'Times New Roman',
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          const Text(': ', style: TextStyle(color: Colors.grey)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
