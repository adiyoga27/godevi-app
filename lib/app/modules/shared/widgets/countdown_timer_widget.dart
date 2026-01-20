import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimerWidget extends StatefulWidget {
  final DateTime targetDate;
  final TextStyle? textStyle;
  final String expiredText;

  const CountdownTimerWidget({
    Key? key,
    required this.targetDate,
    this.textStyle,
    this.expiredText = "Expired",
  }) : super(key: key);

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late Timer _timer;
  late Duration _remainingTime;

  @override
  void initState() {
    super.initState();
    _calculateRemainingTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateRemainingTime();
    });
  }

  void _calculateRemainingTime() {
    final now = DateTime.now();
    setState(() {
      _remainingTime = widget.targetDate.difference(now);
    });
    if (_remainingTime.isNegative) {
      _timer.cancel();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_remainingTime.isNegative) {
      return Text(
        widget.expiredText,
        style: widget.textStyle?.copyWith(color: Colors.red),
      );
    }

    final hours = _remainingTime.inHours.toString().padLeft(2, '0');
    final minutes = (_remainingTime.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime.inSeconds % 60).toString().padLeft(2, '0');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.timer, size: 16, color: Colors.orange),
        const SizedBox(width: 4),
        Text(
          "$hours:$minutes:$seconds",
          style:
              widget.textStyle ??
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
      ],
    );
  }
}
