import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final List<Map<String, String>> faqs = [
    {
      "question": "How do I book a truck on Rodistaa?",
      "answer":
          "To book a truck, go to the Home screen and select either 'Book Partial Load' or 'Book Full Load'. Fill in the pickup and drop locations, select the load type, and submit your booking. Drivers will start bidding on your request immediately."
    },
    {
      "question": "What is the bidding process?",
      "answer":
          "After you post a booking, registered transporters and drivers can bid on your shipment. You'll receive multiple bids with different prices. You can review all bids and select the one that best fits your requirements."
    },
    {
      "question": "How do I track my shipment?",
      "answer":
          "Once your booking is confirmed, go to 'My Shipments' from the bottom navigation. Click on any active shipment and tap 'Live Tracking' to see the real-time location of your truck, driver details, and estimated arrival time."
    },
    {
      "question": "What payment methods are accepted?",
      "answer":
          "Rodistaa accepts multiple payment methods including UPI, Net Banking, Credit/Debit Cards, and Cash on Delivery. You can choose your preferred payment method during checkout."
    },
    {
      "question": "How does KYC verification work?",
      "answer":
          "KYC verification helps us ensure secure transactions. Go to Profile > Complete KYC and submit your Aadhaar, PAN card, and business registration documents. Our team will verify your documents within 24-48 hours."
    },
    {
      "question": "Can I cancel a booking?",
      "answer":
          "Yes, you can cancel a booking from 'My Bookings' screen. However, if a driver has already been assigned and is en route, cancellation charges may apply as per our cancellation policy."
    },
    {
      "question": "What is 'Find Another Driver' feature?",
      "answer":
          "If your confirmed driver becomes unavailable, you can use the 'Find Another Driver' button to unassign the current driver and reopen bidding. This allows you to select a new driver quickly."
    },
    {
      "question": "How do I contact support?",
      "answer":
          "You can reach our support team via:\n• Phone: +91 1800-123-4567\n• Email: support@rodistaa.com\n• WhatsApp: +91 98765-43210\nYou can also create a support ticket from Profile > Support Tickets."
    },
    {
      "question": "What is the OTP verification for delivery?",
      "answer":
          "Every shipment has a unique Receiver OTP. Share this OTP with the driver only when the goods are delivered safely. This ensures proof of delivery and prevents unauthorized access."
    },
    {
      "question": "How are drivers verified?",
      "answer":
          "All drivers on Rodistaa platform go through a strict verification process including document verification, vehicle inspection, and background checks to ensure reliability and safety of your shipments."
    },
  ];

  String searchQuery = "";
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    final filteredFaqs = faqs
        .where((faq) =>
            faq['question']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
            faq['answer']!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFC90D0D),
        elevation: 0,
        title: const Text(
          'Help & FAQ',
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
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFC90D0D).withOpacity(0.05),
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  expandedIndex = null;
                });
              },
              style: const TextStyle(fontFamily: 'Times New Roman'),
              decoration: InputDecoration(
                hintText: 'Search your question...',
                hintStyle: const TextStyle(fontFamily: 'Times New Roman'),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFC90D0D)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFC90D0D), width: 2),
                ),
              ),
            ),
          ),

          // FAQ List
          Expanded(
            child: filteredFaqs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          'No results found',
                          style: TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredFaqs.length,
                    itemBuilder: (context, index) {
                      return _buildFAQItem(filteredFaqs[index], index);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/myBookings'); // Or create ticket screen
        },
        backgroundColor: const Color(0xFFC90D0D),
        icon: const Icon(Icons.support_agent, color: Colors.white),
        label: const Text(
          'Contact Support',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFAQItem(Map<String, String> faq, int index) {
    final isExpanded = expandedIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExpanded
              ? const Color(0xFFC90D0D)
              : const Color(0xFFC90D0D).withOpacity(0.1),
          width: isExpanded ? 2 : 1,
        ),
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
          onTap: () {
            setState(() {
              expandedIndex = isExpanded ? null : index;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC90D0D).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.help_outline,
                        color: Color(0xFFC90D0D),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        faq['question']!,
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isExpanded ? const Color(0xFFC90D0D) : Colors.black87,
                        ),
                      ),
                    ),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: const Color(0xFFC90D0D),
                    ),
                  ],
                ),
                if (isExpanded) ...[
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  Text(
                    faq['answer']!,
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

