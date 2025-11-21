import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../models/transaction.dart';
import '../../providers/transaction_provider.dart';

enum _TransactionRange { last30, last90, all }

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  _TransactionRange _range = _TransactionRange.last30;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Transaction> _applyFilters(List<Transaction> items) {
    final now = DateTime.now();
    final filteredByRange = items.where((txn) {
      switch (_range) {
        case _TransactionRange.last30:
          return txn.transactionDate.isAfter(now.subtract(const Duration(days: 30)));
        case _TransactionRange.last90:
          return txn.transactionDate.isAfter(now.subtract(const Duration(days: 90)));
        case _TransactionRange.all:
          return true;
      }
    });

    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return filteredByRange.toList();
    return filteredByRange
        .where(
          (txn) =>
              (txn.shipmentId ?? '').toLowerCase().contains(query) ||
              txn.description.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.white,
        title: const Text('Transaction History'),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final transactions = _applyFilters(provider.transactions);
          return Column(
            children: [
              _SummaryStrip(
                total: provider.totalEarnings,
                net: provider.netEarnings,
                pending: provider.pendingAmount,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _RangeChip(
                          label: 'Last 30 days',
                          selected: _range == _TransactionRange.last30,
                          onTap: () => setState(() => _range = _TransactionRange.last30),
                        ),
                        const SizedBox(width: 8),
                        _RangeChip(
                          label: 'Last 90 days',
                          selected: _range == _TransactionRange.last90,
                          onTap: () => setState(() => _range = _TransactionRange.last90),
                        ),
                        const SizedBox(width: 8),
                        _RangeChip(
                          label: 'All',
                          selected: _range == _TransactionRange.all,
                          onTap: () => setState(() => _range = _TransactionRange.all),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search by booking/shipment ID',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: transactions.isEmpty
                    ? const _EmptyTransactionsState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final txn = transactions[index];
                          return _TransactionExpansionTile(
                            transaction: txn,
                            onDownload: () => _downloadInvoice(context, provider, txn),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _downloadInvoice(
    BuildContext context,
    TransactionProvider provider,
    Transaction transaction,
  ) async {
    final json = await provider.downloadInvoice(transaction);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invoice ready (mock JSON stored). Length: ${json.length} chars'),
      ),
    );
  }
}

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip({
    required this.total,
    required this.net,
    required this.pending,
  });

  final double total;
  final double net;
  final double pending;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFFF5F5),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SummaryItem(label: 'Total', value: total, color: AppColors.primaryRed),
          _SummaryItem(label: 'Net', value: net, color: Colors.green),
          _SummaryItem(label: 'Pending', value: pending, color: Colors.orange),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '₹${value.toStringAsFixed(0)}',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 12,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }
}

class _RangeChip extends StatelessWidget {
  const _RangeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontFamily: 'Times New Roman')),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primaryRed,
      labelStyle: TextStyle(color: selected ? Colors.white : AppColors.primaryRed),
      backgroundColor: const Color(0xFFFFE1E1),
    );
  }
}

class _TransactionExpansionTile extends StatelessWidget {
  const _TransactionExpansionTile({
    required this.transaction,
    required this.onDownload,
  });

  final Transaction transaction;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('dd MMM yyyy • hh:mm a');
    final isCredit = transaction.type == TransactionType.credit;
    final color = isCredit ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(isCredit ? Icons.south_west : Icons.north_east, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.description,
                    style: const TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    formatter.format(transaction.transactionDate),
                    style: const TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 12,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isCredit ? '+' : '-'}₹${transaction.amount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    transaction.status.name.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 10,
                      color: AppColors.primaryRed,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(label: 'Category', value: transaction.categoryLabel),
                _DetailRow(label: 'Shipment', value: transaction.shipmentId ?? 'N/A'),
                _DetailRow(label: 'Type', value: isCredit ? 'Credit' : 'Debit'),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: onDownload,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    minimumSize: const Size.fromHeight(44),
                  ),
                  icon: const Icon(Icons.download, color: Colors.white),
                  label: const Text(
                    'Download invoice (JSON)',
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
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

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                color: Color(0xFF555555),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTransactionsState extends StatelessWidget {
  const _EmptyTransactionsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.account_balance_wallet_outlined, size: 72, color: Color(0xFFCCCCCC)),
          SizedBox(height: 12),
          Text(
            'No transactions for this filter',
            style: TextStyle(fontFamily: 'Times New Roman', fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

