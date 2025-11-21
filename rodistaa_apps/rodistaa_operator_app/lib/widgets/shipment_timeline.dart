// RODISTAA THEME shipment timeline widget.
// TODO: Drive stage order + labels from backend metadata once available.

import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../models/shipment.dart';

class ShipmentTimeline extends StatefulWidget {
  const ShipmentTimeline({
    super.key,
    required this.stages,
  });

  final List<ShipmentTimelineStage> stages;

  @override
  State<ShipmentTimeline> createState() => _ShipmentTimelineState();
}

class _ShipmentTimelineState extends State<ShipmentTimeline> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final visibleStages = _showAll ? widget.stages : widget.stages.take(4).toList();
    return Column(
      children: [
        ...List.generate(visibleStages.length, (index) {
          final stage = visibleStages[index];
          final globalIndex = widget.stages.indexOf(stage);
          final isLast = globalIndex == widget.stages.length - 1;
          final completed = stage.completed;
          final previousCompleted = globalIndex == 0 ? true : widget.stages[globalIndex - 1].completed;
          final isCurrent = !completed && previousCompleted;
          return _TimelineTile(
            stage: stage,
            isLast: isLast || (!_showAll && index == visibleStages.length - 1),
            isCurrent: isCurrent,
            connectorCompleted: completed,
          );
        }),
        if (widget.stages.length > 4)
          TextButton.icon(
            onPressed: () => setState(() => _showAll = !_showAll),
            icon: Icon(_showAll ? Icons.expand_less : Icons.expand_more),
            label: Text(_showAll ? 'Show less' : 'Show more'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryRed,
              textStyle: const TextStyle(
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({
    required this.stage,
    required this.isLast,
    required this.isCurrent,
    required this.connectorCompleted,
  });

  final ShipmentTimelineStage stage;
  final bool isLast;
  final bool isCurrent;
  final bool connectorCompleted;

  static const Color _completedConnectorColor = Color(0xFF2E7D32);
  static const Color _upcomingColor = Color(0xFFB0B0B0);

  @override
  Widget build(BuildContext context) {
    final Color circleColor = stage.completed || isCurrent ? AppColors.primaryRed : Colors.white;
    final Color borderColor = stage.completed || isCurrent ? AppColors.primaryRed : _upcomingColor;

    return GestureDetector(
      onTap: () {},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: circleColor,
                  border: Border.all(color: borderColor, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: stage.completed
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 48,
                  color: connectorCompleted ? _completedConnectorColor : _upcomingColor,
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          stage.label,
                          style: TextStyle(
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.w700,
                            color: stage.completed
                                ? AppColors.primaryRed
                                : isCurrent
                                    ? AppColors.primaryRed
                                    : const Color(0xFF333333),
                          ),
                        ),
                      ),
                      if (stage.timestamp != null)
                        Text(
                          _formatTimestamp(stage.timestamp!),
                          style: const TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 12,
                            color: Color(0xFF777777),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stage.completed ? 'Updated automatically' : 'Waiting for update',
                    style: const TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 12,
                      color: Color(0xFF777777),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final hours = timestamp.hour.toString().padLeft(2, '0');
    final minutes = timestamp.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}

