// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

import '../data/mock_profile.dart';
import '../data/mock_tickets.dart';
import '../data/mock_transactions.dart';
import '../models/kyc_verification.dart';
import '../models/operator_profile.dart';
import '../models/support_ticket.dart';
import '../models/transaction.dart';

const bool USE_MOCKS = true;

class MockDataStore {
  MockDataStore._internal();
  static final MockDataStore instance = MockDataStore._internal();

  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<Map<String, dynamic>> readJson(String key, Map<String, dynamic> fallback) async {
    final prefs = await _getPrefs();
    final raw = prefs.getString(key);
    if (raw == null) {
      await prefs.setString(key, jsonEncode(fallback));
      return fallback;
    }
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded;
    } catch (_) {
      await prefs.setString(key, jsonEncode(fallback));
      return fallback;
    }
  }

  Future<List<dynamic>> readJsonList(String key, List<dynamic> fallback) async {
    final prefs = await _getPrefs();
    final raw = prefs.getString(key);
    if (raw == null) {
      await prefs.setString(key, jsonEncode(fallback));
      return fallback;
    }
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded;
    } catch (_) {
      await prefs.setString(key, jsonEncode(fallback));
      return fallback;
    }
  }

  Future<void> writeJson(String key, Map<String, dynamic> data) async {
    final prefs = await _getPrefs();
    await prefs.setString(key, jsonEncode(data));
  }

  Future<void> writeJsonList(String key, List<dynamic> data) async {
    final prefs = await _getPrefs();
    await prefs.setString(key, jsonEncode(data));
  }

  Future<void> writeString(String key, String value) async {
    final prefs = await _getPrefs();
    await prefs.setString(key, value);
  }
}

class ProfileMetrics {
  const ProfileMetrics({
    required this.kmDriven,
    required this.deliveries,
    required this.rating,
  });

  final int kmDriven;
  final int deliveries;
  final double rating;

  ProfileMetrics copyWith({
    int? kmDriven,
    int? deliveries,
    double? rating,
  }) {
    return ProfileMetrics(
      kmDriven: kmDriven ?? this.kmDriven,
      deliveries: deliveries ?? this.deliveries,
      rating: rating ?? this.rating,
    );
  }

  factory ProfileMetrics.fromJson(Map<String, dynamic> json) {
    return ProfileMetrics(
      kmDriven: json['kmDriven'] as int? ?? 0,
      deliveries: json['deliveries'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kmDriven': kmDriven,
      'deliveries': deliveries,
      'rating': rating,
    };
  }
}

class ProfileService {
  ProfileService._();
  static final ProfileService instance = ProfileService._();
  static const _profileKey = 'rodistaa_profile';
  static const _metricsKey = 'rodistaa_profile_metrics';

  final MockDataStore _store = MockDataStore.instance;

  Future<OperatorProfile> fetchProfile() async {
    final data = await _store.readJson(_profileKey, mockProfile.toJson());
    return OperatorProfile.fromJson(data);
  }

  Future<void> saveProfile(OperatorProfile profile) async {
    await _store.writeJson(_profileKey, profile.toJson());
  }

  Future<ProfileMetrics> fetchMetrics() async {
    final defaults = const ProfileMetrics(kmDriven: 12345, deliveries: 124, rating: 4.5).toJson();
    final data = await _store.readJson(_metricsKey, defaults);
    return ProfileMetrics.fromJson(data);
  }

  Future<void> saveMetrics(ProfileMetrics metrics) async {
    await _store.writeJson(_metricsKey, metrics.toJson());
  }

  Future<void> markKycVerified() async {
    final profile = await fetchProfile();
    final updated = profile.copyWith(
      kycVerified: true,
      kycVerifiedDate: DateTime.now(),
      lastUpdated: DateTime.now(),
    );
    await saveProfile(updated);
  }
}

class KycHistoryEvent {
  KycHistoryEvent({required this.label, required this.timestamp});

  final String label;
  final DateTime timestamp;

  factory KycHistoryEvent.fromJson(Map<String, dynamic> json) {
    return KycHistoryEvent(
      label: json['label'] as String? ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'timestamp': timestamp.toIso8601String(),
      };
}

class KycRecord {
  const KycRecord({
    required this.status,
    this.aadhaarNumber,
    this.drivingLicenseNumber,
    this.licenseFrontBase64,
    this.licenseBackBase64,
    this.otpRequestedAt,
    this.otpVerified = false,
    this.history = const [],
  });

  final KYCStatus status;
  final String? aadhaarNumber;
  final String? drivingLicenseNumber;
  final String? licenseFrontBase64;
  final String? licenseBackBase64;
  final DateTime? otpRequestedAt;
  final bool otpVerified;
  final List<KycHistoryEvent> history;

  KycRecord copyWith({
    KYCStatus? status,
    String? aadhaarNumber,
    String? drivingLicenseNumber,
    String? licenseFrontBase64,
    String? licenseBackBase64,
    DateTime? otpRequestedAt,
    bool? otpVerified,
    List<KycHistoryEvent>? history,
  }) {
    return KycRecord(
      status: status ?? this.status,
      aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
      drivingLicenseNumber: drivingLicenseNumber ?? this.drivingLicenseNumber,
      licenseFrontBase64: licenseFrontBase64 ?? this.licenseFrontBase64,
      licenseBackBase64: licenseBackBase64 ?? this.licenseBackBase64,
      otpRequestedAt: otpRequestedAt ?? this.otpRequestedAt,
      otpVerified: otpVerified ?? this.otpVerified,
      history: history ?? this.history,
    );
  }

  factory KycRecord.fromJson(Map<String, dynamic> json) {
    return KycRecord(
      status: KYCStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => KYCStatus.notStarted,
      ),
      aadhaarNumber: json['aadhaarNumber'] as String?,
      drivingLicenseNumber: json['drivingLicenseNumber'] as String?,
      licenseFrontBase64: json['licenseFrontBase64'] as String?,
      licenseBackBase64: json['licenseBackBase64'] as String?,
      otpRequestedAt: json['otpRequestedAt'] != null ? DateTime.tryParse(json['otpRequestedAt'] as String) : null,
      otpVerified: json['otpVerified'] as bool? ?? false,
      history: (json['history'] as List<dynamic>? ?? const [])
          .map((entry) => KycHistoryEvent.fromJson(entry as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
      'aadhaarNumber': aadhaarNumber,
      'drivingLicenseNumber': drivingLicenseNumber,
      'licenseFrontBase64': licenseFrontBase64,
      'licenseBackBase64': licenseBackBase64,
      'otpRequestedAt': otpRequestedAt?.toIso8601String(),
      'otpVerified': otpVerified,
      'history': history.map((event) => event.toJson()).toList(),
    };
  }
}

class KycService {
  KycService._();
  static final KycService instance = KycService._();
  static const _kycKey = 'rodistaa_kyc';

  final MockDataStore _store = MockDataStore.instance;
  final ProfileService _profileService = ProfileService.instance;

  Future<KycRecord> fetchRecord() async {
    final fallback = const KycRecord(status: KYCStatus.notStarted).toJson();
    final data = await _store.readJson(_kycKey, fallback);
    return KycRecord.fromJson(data);
  }

  Future<void> _saveRecord(KycRecord record) async {
    await _store.writeJson(_kycKey, record.toJson());
  }

  Future<KycRecord> sendOtp(String aadhaar) async {
    final sanitized = aadhaar.replaceAll(' ', '');
    final record = (await fetchRecord()).copyWith(
      aadhaarNumber: sanitized,
      otpRequestedAt: DateTime.now(),
      history: [
        ...await _historyWith('OTP sent to registered mobile.'),
      ],
    );
    await _saveRecord(record);
    return record;
  }

  Future<List<KycHistoryEvent>> _historyWith(String message) async {
    final record = await fetchRecord();
    return [
      ...record.history,
      KycHistoryEvent(label: message, timestamp: DateTime.now()),
    ];
  }

  Future<bool> verifyOtp(String otp) async {
    final record = await fetchRecord();
    if (otp != '123456') {
      return false;
    }
    final updated = record.copyWith(
      otpVerified: true,
      status: KYCStatus.verified,
      history: [
        ...record.history,
        KycHistoryEvent(label: 'OTP verified successfully.', timestamp: DateTime.now()),
        KycHistoryEvent(label: 'KYC verified automatically (demo).', timestamp: DateTime.now()),
      ],
    );
    await _saveRecord(updated);
    await _profileService.markKycVerified();
    return true;
  }

  Future<KycRecord> updateDrivingLicense({
    String? licenseNumber,
    String? frontBase64,
    String? backBase64,
  }) async {
    final record = await fetchRecord();
    final updated = record.copyWith(
      drivingLicenseNumber: licenseNumber ?? record.drivingLicenseNumber,
      licenseFrontBase64: frontBase64 ?? record.licenseFrontBase64,
      licenseBackBase64: backBase64 ?? record.licenseBackBase64,
    );
    await _saveRecord(updated);
    return updated;
  }

  Future<KycRecord> submitForVerification() async {
    var record = await fetchRecord();
    record = record.copyWith(
      status: KYCStatus.pending,
      history: [
        ...record.history,
        KycHistoryEvent(label: 'Submitted for verification.', timestamp: DateTime.now()),
      ],
    );
    await _saveRecord(record);

    await Future<void>.delayed(const Duration(seconds: 3));

    record = record.copyWith(
      status: KYCStatus.verified,
      history: [
        ...record.history,
        KycHistoryEvent(label: 'KYC verified automatically (demo).', timestamp: DateTime.now()),
      ],
    );
    await _saveRecord(record);
    await _profileService.markKycVerified();
    return record;
  }

  Future<String> loadPlaceholderLicense() async {
    final bytes = await rootBundle.load('assets/images/placeholder_load_thumb.png');
    final buffer = bytes.buffer.asUint8List();
    return base64Encode(buffer);
  }
}

class TransactionService {
  TransactionService._();
  static final TransactionService instance = TransactionService._();
  static const _transactionsKey = 'rodistaa_transactions';
  static const _lastInvoiceKey = 'rodistaa_last_invoice';

  final MockDataStore _store = MockDataStore.instance;

  Future<List<Transaction>> fetchTransactions() async {
    final fallback = mockTransactions.map((txn) => txn.toJson()).toList();
    final data = await _store.readJsonList(_transactionsKey, fallback);
    return data.map((item) => Transaction.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<void> saveTransactions(List<Transaction> transactions) async {
    await _store.writeJsonList(_transactionsKey, transactions.map((t) => t.toJson()).toList());
  }

  Future<String> downloadInvoice(Transaction transaction) async {
    final invoice = {
      'transactionId': transaction.transactionId,
      'amount': transaction.amount,
      'type': transaction.type.name,
      'category': transaction.categoryLabel,
      'status': transaction.status.name,
      'shipmentId': transaction.shipmentId,
      'generatedAt': DateTime.now().toIso8601String(),
    };
    await _store.writeString(_lastInvoiceKey, jsonEncode(invoice));
    return jsonEncode(invoice);
  }
}

class TicketService {
  TicketService._();
  static final TicketService instance = TicketService._();
  static const _ticketsKey = 'rodistaa_tickets';

  final MockDataStore _store = MockDataStore.instance;

  Future<List<SupportTicket>> fetchTickets() async {
    final fallback = mockTickets.map((ticket) => ticket.toJson()).toList();
    final data = await _store.readJsonList(_ticketsKey, fallback);
    return data.map((entry) => SupportTicket.fromJson(entry as Map<String, dynamic>)).toList();
  }

  Future<void> _save(List<SupportTicket> tickets) async {
    await _store.writeJsonList(_ticketsKey, tickets.map((ticket) => ticket.toJson()).toList());
  }

  Future<SupportTicket> createTicket({
    required TicketCategory category,
    required String subject,
    required String description,
    List<String> attachments = const [],
  }) async {
    final tickets = await fetchTickets();
    final ticketId = 'T${DateTime.now().millisecondsSinceEpoch}';
    final newTicket = SupportTicket(
      ticketId: ticketId,
      operatorId: 'OP001',
      category: category,
      subject: subject,
      description: description,
      status: TicketStatus.open,
      attachments: attachments,
      createdAt: DateTime.now(),
      lastUpdatedAt: DateTime.now(),
      replies: [
        TicketReply(
          replyId: 'R${DateTime.now().millisecondsSinceEpoch}',
          ticketId: ticketId,
          message: description,
          isFromSupport: false,
          timestamp: DateTime.now(),
          attachments: attachments,
        ),
      ],
    );
    final updatedTickets = [newTicket, ...tickets];
    await _save(updatedTickets);
    return newTicket;
  }

  Future<void> addReply({
    required String ticketId,
    required String message,
    bool isFromSupport = false,
  }) async {
    final tickets = await fetchTickets();
    final index = tickets.indexWhere((ticket) => ticket.ticketId == ticketId);
    if (index == -1) return;
    final ticket = tickets[index];
    final reply = TicketReply(
      replyId: 'R${DateTime.now().millisecondsSinceEpoch}',
      ticketId: ticket.ticketId,
      message: message,
      isFromSupport: isFromSupport,
      timestamp: DateTime.now(),
    );
    final updated = SupportTicket(
      ticketId: ticket.ticketId,
      operatorId: ticket.operatorId,
      category: ticket.category,
      subject: ticket.subject,
      description: ticket.description,
      status: ticket.status,
      attachments: ticket.attachments,
      createdAt: ticket.createdAt,
      lastUpdatedAt: DateTime.now(),
      resolvedAt: ticket.resolvedAt,
      replies: [...ticket.replies, reply],
    );
    tickets[index] = updated;
    await _save(tickets);
  }

  Future<void> updateStatus(String ticketId, TicketStatus status) async {
    final tickets = await fetchTickets();
    final index = tickets.indexWhere((ticket) => ticket.ticketId == ticketId);
    if (index == -1) return;
    final ticket = tickets[index];
    tickets[index] = SupportTicket(
      ticketId: ticket.ticketId,
      operatorId: ticket.operatorId,
      category: ticket.category,
      subject: ticket.subject,
      description: ticket.description,
      status: status,
      attachments: ticket.attachments,
      createdAt: ticket.createdAt,
      lastUpdatedAt: DateTime.now(),
      resolvedAt: status == TicketStatus.resolved ? DateTime.now() : ticket.resolvedAt,
      replies: ticket.replies,
    );
    await _save(tickets);
  }
}

class NotificationMessage {
  NotificationMessage({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.read = false,
  });

  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool read;

  NotificationMessage copyWith({bool? read}) {
    return NotificationMessage(
      id: id,
      title: title,
      body: body,
      timestamp: timestamp,
      read: read ?? this.read,
    );
  }

  factory NotificationMessage.fromJson(Map<String, dynamic> json) {
    return NotificationMessage(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
      read: json['read'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'read': read,
    };
  }
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();
  static const _notificationsKey = 'rodistaa_notifications';

  final MockDataStore _store = MockDataStore.instance;

  Future<List<NotificationMessage>> fetchNotifications() async {
    final data = await _store.readJsonList(_notificationsKey, const []);
    return data.map((entry) => NotificationMessage.fromJson(entry as Map<String, dynamic>)).toList();
  }

  Future<void> _save(List<NotificationMessage> items) async {
    await _store.writeJsonList(_notificationsKey, items.map((item) => item.toJson()).toList());
  }

  Future<void> addNotification(String title, String body) async {
    final items = await fetchNotifications();
    final message = NotificationMessage(
      id: 'N${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      body: body,
      timestamp: DateTime.now(),
    );
    await _save([message, ...items]);
  }

  Future<void> markRead(String id) async {
    final items = await fetchNotifications();
    final updated = items.map((item) => item.id == id ? item.copyWith(read: true) : item).toList();
    await _save(updated);
  }

  Future<void> markAllRead() async {
    final items = await fetchNotifications();
    final updated = items.map((item) => item.copyWith(read: true)).toList();
    await _save(updated);
  }

  Future<void> dismiss(String id) async {
    final items = await fetchNotifications();
    items.removeWhere((item) => item.id == id);
    await _save(items);
  }
}

class SettingsModel {
  SettingsModel({
    required this.pushNotifications,
    required this.showNearby,
    required this.useMobileData,
    required this.languageCode,
    required this.theme,
  });

  final bool pushNotifications;
  final bool showNearby;
  final bool useMobileData;
  final String languageCode;
  final String theme; // light, dark, system

  SettingsModel copyWith({
    bool? pushNotifications,
    bool? showNearby,
    bool? useMobileData,
    String? languageCode,
    String? theme,
  }) {
    return SettingsModel(
      pushNotifications: pushNotifications ?? this.pushNotifications,
      showNearby: showNearby ?? this.showNearby,
      useMobileData: useMobileData ?? this.useMobileData,
      languageCode: languageCode ?? this.languageCode,
      theme: theme ?? this.theme,
    );
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      showNearby: json['showNearby'] as bool? ?? true,
      useMobileData: json['useMobileData'] as bool? ?? false,
      languageCode: json['languageCode'] as String? ?? 'en',
      theme: json['theme'] as String? ?? 'light',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pushNotifications': pushNotifications,
      'showNearby': showNearby,
      'useMobileData': useMobileData,
      'languageCode': languageCode,
      'theme': theme,
    };
  }
}

class SettingsService {
  SettingsService._();
  static final SettingsService instance = SettingsService._();
  static const _settingsKey = 'rodistaa_settings';

  final MockDataStore _store = MockDataStore.instance;

  Future<SettingsModel> fetchSettings() async {
    final fallback = SettingsModel(
      pushNotifications: true,
      showNearby: true,
      useMobileData: false,
      languageCode: 'en',
      theme: 'light',
    ).toJson();
    final data = await _store.readJson(_settingsKey, fallback);
    return SettingsModel.fromJson(data);
  }

  Future<void> saveSettings(SettingsModel settings) async {
    await _store.writeJson(_settingsKey, settings.toJson());
  }
}

Future<String> generateAttachmentPlaceholder() async {
  final bytes = await rootBundle.load('assets/images/placeholder_load_thumb.png');
  final buffer = bytes.buffer;
  return base64Encode(Uint8List.view(buffer));
}

String randomTicketId() => 'T${Random().nextInt(999999)}';
String randomNotificationId() => 'N${Random().nextInt(999999)}';

