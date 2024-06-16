import 'dart:async';
import 'package:flutter/material.dart';

class DashboardBanner extends StatefulWidget {
  const DashboardBanner({super.key});

  @override
  State<DashboardBanner> createState() => _DashboardBannerState();
}

class _DashboardBannerState extends State<DashboardBanner> {
  static const int _pomodoroTime = 25 * 60; // 25 minutes in seconds
  int _seconds = _pomodoroTime;
  Timer? _timer;
  bool _isRunning = false; // New variable to track timer state

  void _startTimer() {
    if (_timer != null && _timer!.isActive) return; // Prevent multiple timers
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() => _seconds--);
      } else {
        _timer?.cancel();
        setState(() => _isRunning = false);
      }
    });
    setState(() => _isRunning = true); // Update running state when timer starts
  }

  void _pauseTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
      setState(() => _isRunning = false); // Update running state when paused
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _seconds = _pomodoroTime;
      _isRunning = false; // Ensure correct state reset
    });
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _seconds ~/ 60;
    final seconds = _seconds % 60;

    return Container(
      height: 140,
      margin: const EdgeInsets.only(right: 5),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 184, 0),
            Color.fromARGB(255, 255, 225, 120)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  minutes.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: 60,
                    color: Colors.brown[900],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ':',
                  style: TextStyle(
                    fontSize: 60,
                    color: Colors.brown[900],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  seconds.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: 60,
                    color: Colors.brown[900],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.restart_alt),
                  color: Colors.brown[900],
                  onPressed: _resetTimer,
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  color: Colors.brown[900],
                  onPressed: _isRunning ? _pauseTimer : _startTimer,
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  color: Colors.brown[900],
                  onPressed: () {}, // Future functionality or placeholder
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
