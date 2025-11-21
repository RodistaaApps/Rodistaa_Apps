import 'dart:async';

import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({
    super.key,
    required this.endAt,
    this.style,
    this.onEnd,
  });

  final DateTime endAt;
  final TextStyle? style;
  final VoidCallback? onEnd;

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration _remaining;
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _tick();
    _t = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (!mounted) return;
    setState(() {
      _remaining = widget.endAt.difference(DateTime.now());
      if (_remaining.isNegative) {
        _t?.cancel();
        widget.onEnd?.call();
        _remaining = Duration.zero;
      }
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = _remaining.inHours.remainder(100).toString().padLeft(2, '0');
    final m = _remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = _remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return GestureDetector(
      onLongPress: () {
        final fmt = widget.endAt.toLocal().toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bidding ends at: $fmt')),
        );
      },
      child: Text(
        '$h:$m:$s',
        style: widget.style ??
            const TextStyle(
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
      ),
    );
  }
}

