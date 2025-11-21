import 'package:flutter/material.dart';

import '../services/shipment_api.dart';
import '../theme.dart';
import '../widgets/advanced_filter_bottom_sheet.dart';
import '../widgets/completed_shipment_card.dart';
import '../widgets/shipment_card_final.dart';
import '../widgets/shipment_details_bottom_sheet.dart';

class ShipmentsScreen extends StatefulWidget {
  const ShipmentsScreen({
    super.key,
    this.api = const ShipmentApi(),
    this.initialStatus = ShipmentStatusFilter.ongoing,
  });

  final ShipmentApi api;
  final ShipmentStatusFilter initialStatus;

  @override
  State<ShipmentsScreen> createState() => _ShipmentsScreenState();
}

class _ShipmentsScreenState extends State<ShipmentsScreen> {
  late ShipmentStatusFilter _status = widget.initialStatus;
  AdvancedShipmentFilters _filters =
      const AdvancedShipmentFilters(unpaidOnly: false);
  final ScrollController _scrollController = ScrollController();
  bool _loading = false;
  bool _loadingMore = false;
  bool _hasMore = true;
  int _page = 1;
  List<Map<String, dynamic>> _shipments = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadShipments(reset: true);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  Future<void> _loadShipments({bool reset = false}) async {
    if (reset) {
      setState(() {
        _loading = true;
        _error = null;
        _page = 1;
        _shipments = [];
        _hasMore = true;
      });
    } else {
      if (_loadingMore || !_hasMore) return;
      setState(() => _loadingMore = true);
    }
    try {
      final newShipments = await widget.api.fetchShipments(
        status: _status,
        page: _page,
        filters: _filters,
      );
      setState(() {
        if (_page == 1) {
          _shipments = newShipments;
        } else {
          _shipments.addAll(newShipments);
        }
        if (newShipments.isEmpty) {
          _hasMore = false;
        } else {
          _page += 1;
        }
      });
    } catch (err) {
      setState(() => _error = err.toString());
    } finally {
      if (reset) {
        setState(() => _loading = false);
      } else {
        setState(() => _loadingMore = false);
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >
            _scrollController.position.maxScrollExtent - 120 &&
        !_loading &&
        !_loadingMore) {
      _loadShipments();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text('Shipments'),
      backgroundColor: RodistaaTheme.rodistaaRed,
      actions: [
        IconButton(
          tooltip: 'Advanced filters',
          icon: const Icon(Icons.filter_alt_outlined),
          onPressed: _openFilters,
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: RefreshIndicator(
        onRefresh: () => _loadShipments(reset: true),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final children = <Widget>[
              _headerSection(context),
              const SizedBox(height: RodistaaTheme.gapM),
              _segmentedControl(),
              const SizedBox(height: RodistaaTheme.gapL),
            ];

            if (_error != null) {
              children.add(_errorState());
            } else if (_loading && _shipments.isEmpty) {
              children.addAll(List.generate(3, (_) => _skeletonCard()));
            } else if (_shipments.isEmpty) {
              children.add(_emptyState(context));
            } else {
              children.addAll(_shipments
                  .map((shipment) => Padding(
                        padding:
                            const EdgeInsets.only(bottom: RodistaaTheme.gapL),
                        child: _status == ShipmentStatusFilter.completed
                            ? CompletedShipmentCard(
                                shipment: shipment,
                                onTap: () =>
                                    _openDetails(shipment, readOnly: true),
                              )
                            : ShipmentCardFinal(
                                shipment: shipment,
                                onOtpSubmit: (otp, type) =>
                                    widget.api.verifyOtp(
                                  shipmentId: shipment['id'],
                                  type: type,
                                  otp: otp,
                                ),
                                onDetailsRequested: (data,
                                        {readOnly = false}) =>
                                    _openDetails(data, readOnly: readOnly),
                              ),
                      ))
                  .toList());
              if (_loadingMore) {
                children.add(const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: RodistaaTheme.gapM),
                    child: CircularProgressIndicator(),
                  ),
                ));
              }
            }

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                    maxWidth: RodistaaTheme.maxContentWidth),
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  children: children,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _headerSection(BuildContext context) {
    final isCompleted = _status == ShipmentStatusFilter.completed;
    final title = isCompleted ? 'Completed Shipments' : 'My Shipments';
    final tagline = isCompleted ? 'Track your completed deliveries.' : null;
    final textTheme = RodistaaTheme.serifTextTheme(Theme.of(context).textTheme);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (tagline != null) ...[
          const SizedBox(height: RodistaaTheme.gapS),
          Text(
            tagline,
            style: textTheme.bodyMedium?.copyWith(color: RodistaaTheme.muted),
          ),
        ],
      ],
    );
  }

  Widget _segmentedControl() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: RodistaaTheme.divider),
      ),
      child: Row(
        children: ShipmentStatusFilter.values.map((filter) {
          final isSelected = filter == _status;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _status = filter);
                _loadShipments(reset: true);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? RodistaaTheme.rodistaaRed
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text(
                  _labelFor(filter),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        isSelected ? Colors.white : RodistaaTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _labelFor(ShipmentStatusFilter filter) {
    switch (filter) {
      case ShipmentStatusFilter.ongoing:
        return 'Ongoing';
      case ShipmentStatusFilter.completed:
        return 'Completed';
      case ShipmentStatusFilter.all:
        return 'All';
    }
  }

  Widget _skeletonCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: RodistaaTheme.gapL),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: List.generate(
          3,
          (index) => Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            height: 14,
            decoration: BoxDecoration(
              color: RodistaaTheme.divider,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.inbox_outlined, size: 64, color: RodistaaTheme.muted),
        const SizedBox(height: RodistaaTheme.gapM),
        Text(
          'No shipments yet',
          style: RodistaaTheme.headingMedium(context),
        ),
        const SizedBox(height: RodistaaTheme.gapS),
        const Text('Try adjusting filters or check again later.'),
      ],
    );
  }

  Widget _errorState() {
    return Column(
      children: [
        const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
        const SizedBox(height: RodistaaTheme.gapS),
        Text(_error ?? 'Something went wrong'),
        TextButton(
          onPressed: () => _loadShipments(reset: true),
          child: const Text('Retry'),
        ),
      ],
    );
  }

  Future<void> _openFilters() async {
    final result = await showModalBottomSheet<AdvancedShipmentFilters>(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (_, controller) =>
            AdvancedFilterBottomSheet(initialFilters: _filters),
      ),
    );
    if (result != null) {
      setState(() => _filters = result);
      _loadShipments(reset: true);
    }
  }

  Future<void> _openDetails(Map<String, dynamic> shipment,
      {required bool readOnly}) async {
    final detailed = await widget.api.fetchShipmentDetails(shipment['id']);
    final scrollController = ScrollController();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: readOnly ? 0.6 : 0.62,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, __) {
            return ShipmentDetailsBottomSheet(
              shipment: detailed,
              controller: scrollController,
              readOnly: readOnly,
              onDownloadInvoice: widget.api.downloadInvoice,
              onRaiseIssue: widget.api.raiseIssue,
            );
          },
        );
      },
    );
  }
}
