import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../models/support_ticket.dart';
import '../../providers/ticket_provider.dart';
import '../../services/mock_data.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: AppColors.white,
          title: const Text('Help & Support'),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'FAQ'),
              Tab(text: 'Contact'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _FaqTab(),
            _ContactTab(),
          ],
        ),
      ),
    );
  }
}

class _FaqTab extends StatelessWidget {
  const _FaqTab();

  static final List<Map<String, String>> _faqData = [
    {'q': 'How do I add a truck?', 'a': 'Go to My Fleet > tap + and complete the onboarding form.'},
    {'q': 'How are payments processed?', 'a': 'Advance is paid instantly, balance within 24 hours after POD upload.'},
    {'q': 'Where do I upload POD documents?', 'a': 'Open Shipments > select shipment > Documents section.'},
    {'q': 'How to verify KYC?', 'a': 'Menu > KYC Verification. Enter Aadhaar + DL and submit (demo auto-approves).'},
    {'q': 'How do I update a bid?', 'a': 'My Bids > choose load > Update Bid to revise the quote.'},
    {'q': 'Can I enable nearby booking alerts?', 'a': 'Yes. Settings > toggle “Show Nearby Bookings”.'},
    {'q': 'How to contact support quickly?', 'a': 'Use Contact tab to open a ticket or call +91-1800-111-RDS.'},
    {'q': 'Where can I download invoices?', 'a': 'Transactions screen provides JSON invoice download for each payment.'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _faqData.length,
      itemBuilder: (context, index) {
        final item = _faqData[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ExpansionTile(
            title: Text(
              item['q']!,
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.w700,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  item['a']!,
                  style: const TextStyle(fontFamily: 'Times New Roman'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ContactTab extends StatefulWidget {
  const _ContactTab();

  @override
  State<_ContactTab> createState() => _ContactTabState();
}

class _ContactTabState extends State<_ContactTab> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subject = TextEditingController();
  final TextEditingController _message = TextEditingController();
  bool _isSubmitting = false;
  String? _attachment;

  @override
  void dispose() {
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create a support ticket',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _subject,
              decoration: const InputDecoration(labelText: 'Subject'),
              validator: (value) => value == null || value.isEmpty ? 'Enter subject' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _message,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Message'),
              validator: (value) => value == null || value.length < 10 ? 'Describe the issue' : null,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () async {
                final data = await generateAttachmentPlaceholder();
                if (!mounted) return;
                setState(() => _attachment = data);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Demo screenshot attached.')),
                );
              },
              icon: const Icon(Icons.attachment),
              label: const Text('Attach screenshot (demo)'),
            ),
            if (_attachment != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    base64Decode(_attachment!),
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : () => _submit(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Submit to support',
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    await context.read<TicketProvider>().createTicket(
          category: TicketCategory.other,
          subject: _subject.text.trim(),
          description: _message.text.trim(),
          attachments: _attachment != null ? <String>[_attachment!] : [],
        );
    if (!mounted) return;
    setState(() {
      _isSubmitting = false;
      _subject.clear();
      _message.clear();
      _attachment = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ticket created. Our support team will reach out shortly.')),
    );
  }
}

