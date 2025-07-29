import 'dart:async';

import 'package:flutter/material.dart';

class CountDownTimer extends StatefulWidget {
  final DateTime dueDate;
  const CountDownTimer({super.key, required this.dueDate});

  @override
  State<CountDownTimer> createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  late DateTime _dueDate;
  late Duration _remainingTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _dueDate = widget.dueDate;
    _calculateRemainingTime();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateRemainingTime(),
    );
  }

  void _calculateRemainingTime() {
    setState(() {
      _remainingTime = _dueDate.difference(DateTime.now());
    });
  }

  void _updateRemainingTime() {
    if (_remainingTime.inSeconds > 0) {
      setState(() {
        _remainingTime = _dueDate.difference(DateTime.now());
      });
    } else {
      _timer.cancel();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) {
      return 'Deadline Passed';
    }
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    return '$hours h $minutes m $seconds s';
  }

  @override
  Widget build(BuildContext context) {
    final String formattedTime = _formatDuration(_remainingTime);
    return Text(
      formattedTime,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
    );
  }
}
