import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart';

class ShiftCountdown extends StatefulWidget {
  final DateTime shiftStart;
  final TextStyle style;
  const ShiftCountdown({Key? key, required this.shiftStart, required this.style}) : super(key: key);

  @override
  _ShiftCountdownState createState() => _ShiftCountdownState();
}

class _ShiftCountdownState extends State<ShiftCountdown> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  Duration remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _ticker = createTicker((_) {
      if (!mounted) return;
      _updateRemaining();
    })..start();
  }

  void _updateRemaining() {
    final newRemaining = widget.shiftStart.difference(DateTime.now());
    if (newRemaining != remaining) {
      setState(() => remaining = newRemaining);
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (remaining.isNegative) {
      return Text("Shift started!", style: widget.style);
    }
    return Text(
      "${remaining.inDays}d ${remaining.inHours % 24}h "
          "${remaining.inMinutes % 60}m ${remaining.inSeconds % 60}s",
      style: widget.style,
    );
  }
}

