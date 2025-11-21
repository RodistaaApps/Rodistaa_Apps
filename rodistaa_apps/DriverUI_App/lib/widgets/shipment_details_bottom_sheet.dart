import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme.dart';

class ShipmentDetailsBottomSheet extends StatelessWidget {
  const ShipmentDetailsBottomSheet({
    super.key,
    required this.shipment,
    required this.controller,
    this.focusEventId,
    this.readOnly = false,
    this.onDownloadInvoice,
    this.onRaiseIssue,
  });

  final Map<String, dynamic> shipment;
  final ScrollController controller;
  final String? focusEventId;
  final bool readOnly;
  final Future<Uri> Function(String shipmentId)? onDownloadInvoice;
  final Future<void> Function(
    String shipmentId, {
    required String subject,
    required String description,
    String? attachmentPath,
  })? onRaiseIssue;

  @override
  Widget build(BuildContext context) {
    final events =
        List<Map<String, dynamic>>.from(shipment['events'] ?? const []);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (focusEventId != null) {
        final index = events.indexWhere((event) => event['id'] == focusEventId);
        if (index != -1) {
          controller.animateTo(
            index * 120,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      }
    });
    return Column(
      children: [
        const SizedBox(height: RodistaaTheme.gapS),
        Container(
          width: 48,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: RodistaaTheme.gapM),
        Expanded(
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            children: [
              _sectionTitle('Truck Details'),
              const SizedBox(height: RodistaaTheme.gapS),
              _infoRow('Truck Number', shipment['truckNo']),
              _infoRow('Truck Type', shipment['truckType']),
              _infoRow('Tyres', shipment['tyres']),
              _infoRow('Operator Phone', shipment['operatorPhone']),
              const SizedBox(height: RodistaaTheme.gapL),
              _sectionTitle('Contacts'),
              const SizedBox(height: RodistaaTheme.gapS),
              _contactRow('Sender', shipment['senderPhone']),
              _contactRow('Receiver', shipment['receiverPhone']),
              const SizedBox(height: RodistaaTheme.gapL),
              _sectionTitle('Timeline'),
              const SizedBox(height: RodistaaTheme.gapS),
              ...events.map(_timelineTile),
              const SizedBox(height: RodistaaTheme.gapL),
              _sectionTitle('Attachments'),
              const SizedBox(height: RodistaaTheme.gapS),
              Text(
                'Photos and documents will appear here once uploaded.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: RodistaaTheme.gapL),
            ],
          ),
        ),
        if (readOnly)
          _ReadOnlyActions(
            onDownloadInvoiceTap: onDownloadInvoice == null
                ? null
                : () => _handleDownloadInvoice(context),
            onRaiseIssueTap: onRaiseIssue == null
                ? null
                : () => _showRaiseIssueDialog(context),
          ),
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _infoRow(String label, Object? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(color: RodistaaTheme.muted),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value?.toString() ?? '--'),
          ),
        ],
      ),
    );
  }

  Widget _contactRow(String label, Object? phone) {
    final phoneNumber = phone?.toString() ?? '';
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(phoneNumber),
      trailing: IconButton(
        icon: const Icon(Icons.call),
        onPressed: phoneNumber.isEmpty
            ? null
            : () {
                final uri = Uri.parse('tel:$phoneNumber');
                launchUrl(uri);
              },
      ),
    );
  }

  Widget _timelineTile(Map<String, dynamic> event) {
    final title = event['title']?.toString() ?? '';
    final time = event['time']?.toString() ?? '';
    final detail = event['detail']?.toString() ?? '';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: RodistaaTheme.gapS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const CircleAvatar(
                radius: 8,
                backgroundColor: RodistaaTheme.rodistaaRed,
              ),
              Container(
                width: 2,
                height: 40,
                color: RodistaaTheme.divider,
              ),
            ],
          ),
          const SizedBox(width: RodistaaTheme.gapM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(time,
                    style: const TextStyle(
                        color: RodistaaTheme.muted, fontSize: 12)),
                if (detail.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: RodistaaTheme.gapXS),
                    child: Text(detail),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDownloadInvoice(BuildContext context) async {
    if (onDownloadInvoice == null) return;
    final uri = await onDownloadInvoice!(shipment['id']);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invoice ready: ${uri.toString()}')),
    );
  }

  Future<void> _showRaiseIssueDialog(BuildContext context) async {
    if (onRaiseIssue == null) return;
    final subjectController = TextEditingController();
    final descriptionController = TextEditingController();
    final attachmentController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Raise Issue'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: subjectController,
                decoration: const InputDecoration(labelText: 'Subject'),
              ),
              const SizedBox(height: RodistaaTheme.gapS),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: RodistaaTheme.gapS),
              TextField(
                controller: attachmentController,
                decoration: const InputDecoration(
                    labelText: 'Attachment URL (optional)'),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel')),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                  backgroundColor: RodistaaTheme.rodistaaRed),
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
    if (result == true) {
      await onRaiseIssue!(
        shipment['id'],
        subject: subjectController.text,
        description: descriptionController.text,
        attachmentPath: attachmentController.text.isEmpty
            ? null
            : attachmentController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Issue submitted')),
      );
    }
  }
}

class _ReadOnlyActions extends StatelessWidget {
  const _ReadOnlyActions({
    this.onDownloadInvoiceTap,
    this.onRaiseIssueTap,
  });

  final VoidCallback? onDownloadInvoiceTap;
  final VoidCallback? onRaiseIssueTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Column(
        children: [
          FilledButton.icon(
            onPressed: onDownloadInvoiceTap,
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: const Text('Download Invoice'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              backgroundColor: RodistaaTheme.rodistaaRed,
            ),
          ),
          const SizedBox(height: RodistaaTheme.gapM),
          OutlinedButton.icon(
            onPressed: onRaiseIssueTap,
            icon: const Icon(Icons.report_problem_outlined),
            label: const Text('Raise Issue'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
          ),
        ],
      ),
    );
  }
}
