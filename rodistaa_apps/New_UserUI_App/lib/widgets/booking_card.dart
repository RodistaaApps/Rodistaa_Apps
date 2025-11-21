import 'dart:async';
import 'package:flutter/material.dart';

class BookingCard extends StatefulWidget {
  final String bookingId;
  final String pickup;
  final String drop;
  final String km;
  final String date;
  final String time;
  final String status;
  final int timerMinutes;
  final String loadType; // PTL or FTL
  final VoidCallback onCancel;
  final VoidCallback onViewBids;
  final VoidCallback onViewDetails;
  final VoidCallback? onFindAnotherDriver;

  const BookingCard({
    Key? key,
    required this.bookingId,
    required this.pickup,
    required this.drop,
    required this.km,
    required this.date,
    required this.time,
    required this.status,
    required this.timerMinutes,
    required this.loadType,
    required this.onCancel,
    required this.onViewBids,
    required this.onViewDetails,
    this.onFindAnotherDriver,
  }) : super(key: key);

  @override
  State<BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.timerMinutes * 60;
    
    if (widget.status == 'Posted' && _remainingSeconds > 0) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime() {
    final hours = _remainingSeconds ~/ 3600;
    final minutes = (_remainingSeconds % 3600) ~/ 60;
    final seconds = _remainingSeconds % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPosted = widget.status == 'Posted';
    final bool isConfirmed = widget.status == 'Confirmed';
    final bool isCancelled = widget.status == 'Cancelled';
    final bool isReopened = widget.status == 'Reopened';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: isReopened
            ? Border.all(color: const Color(0xFFC90D0D).withOpacity(0.3), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Booking ID and Timer/KM badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Booking ID: ${widget.bookingId}',
                    style: const TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC90D0D),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Timer or KM badge based on status
                if (isPosted && _remainingSeconds > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC90D0D),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFC90D0D).withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Tooltip(
                          message: 'Truck Finalizing Time',
                          textStyle: const TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 12,
                            color: Colors.black,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.timer,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _formatTime(),
                          style: const TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC90D0D).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${widget.km} KM',
                      style: const TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC90D0D),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),

            // Reopened Status Tag
            if (isReopened)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '🟠',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Reopened for New Bids',
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Load Type Icon Badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC90D0D),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFC90D0D).withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.loadType == 'PTL' 
                            ? Icons.local_shipping_outlined  // Partial - outlined truck
                            : Icons.local_shipping,          // Full - solid truck
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.loadType == 'PTL' ? 'Partial Load' : 'Full Load',
                        style: const TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Pickup Location
            Row(
              children: [
                const Icon(Icons.location_on, size: 18, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.pickup,
                    style: const TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Drop Location
            Row(
              children: [
                const Icon(Icons.location_on, size: 18, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.drop,
                    style: const TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Date and Time
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '${widget.date}, ${widget.time}',
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            
            // Timer warning if less than 10 minutes
            if (isPosted && _remainingSeconds > 0 && _remainingSeconds < 600)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning_amber_rounded, size: 16, color: Colors.red.shade700),
                      const SizedBox(width: 6),
                      Text(
                        'Hurry! Accept a bid soon',
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 12,
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 16),

            // Action Buttons or Status Label
            if (isPosted)
              Column(
                children: [
                  // View Details button (full width)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: widget.onViewDetails,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFC90D0D)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(
                        Icons.info_outline,
                        color: Color(0xFFC90D0D),
                        size: 18,
                      ),
                      label: const Text(
                        'View Details',
                        style: TextStyle(
                          color: Color(0xFFC90D0D),
                          fontFamily: 'Times New Roman',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // View Bids and Cancel buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.onViewBids,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFC90D0D)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'View Bids',
                            style: TextStyle(
                              color: Color(0xFFC90D0D),
                              fontFamily: 'Times New Roman',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: widget.onCancel,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC90D0D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Times New Roman',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            else if (isConfirmed)
              Column(
                children: [
                  // View Details button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: widget.onViewDetails,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFC90D0D)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(
                        Icons.info_outline,
                        color: Color(0xFFC90D0D),
                        size: 18,
                      ),
                      label: const Text(
                        'View Details',
                        style: TextStyle(
                          color: Color(0xFFC90D0D),
                          fontFamily: 'Times New Roman',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Find Another Driver button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.onFindAnotherDriver,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC90D0D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: const Text(
                        'Change Operator',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Times New Roman',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Confirmed badge
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.check_circle, color: Colors.green, size: 20),
                        SizedBox(width: 8),
                        Text(
                          '✅ Confirmed',
                          style: TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            else if (isReopened)
              Column(
                children: [
                  // View Details button (full width)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: widget.onViewDetails,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFC90D0D)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(
                        Icons.info_outline,
                        color: Color(0xFFC90D0D),
                        size: 18,
                      ),
                      label: const Text(
                        'View Details',
                        style: TextStyle(
                          color: Color(0xFFC90D0D),
                          fontFamily: 'Times New Roman',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // View Bids and Cancel buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.onViewBids,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFC90D0D)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'View Bids',
                            style: TextStyle(
                              color: Color(0xFFC90D0D),
                              fontFamily: 'Times New Roman',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: widget.onCancel,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC90D0D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Times New Roman',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            else if (isCancelled)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.cancel, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text(
                      '❌ Cancelled by You',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
