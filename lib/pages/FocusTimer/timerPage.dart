import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FocusTimerPage extends StatefulWidget {
  const FocusTimerPage({super.key});

  @override
  State<FocusTimerPage> createState() => _FocusTimerPageState();
}

class _FocusTimerPageState extends State<FocusTimerPage> {
  // Variables
  int timeLeft = 0;
  int initialTime = 0;
  bool isPaused = false;
  bool clockAni = false;
  Timer? timer;

  final TextEditingController _timeController = TextEditingController();

  // Helper: Format time as MM:SS
  String formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // Start timer
  void _startCountdown() {
    if (timer != null && timer!.isActive) return; // Prevent multiple timers

    if (timeLeft == 0) {
      _showMessage("Enter time before starting the timer!");
      return;
    }

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPaused) {
        setState(() {
          if (timeLeft > 0) {
            timeLeft--;
            clockAni = true;
          } else {
            timer.cancel();
            clockAni = false;
          }
        });
      }
    });
  }

  // Pause/Resume timer
  void _pauseOrResume() {
    if (timeLeft == 0) {
      _showMessage("Nothing to pause or resume!");
      return;
    }

    setState(() {
      isPaused = !isPaused;
      clockAni = !clockAni;
    });
  }

  // Restart timer
  void _restartTimer() {
    if (timer != null) {
      timer!.cancel();
    }

    setState(() {
      timeLeft = initialTime;
      isPaused = false;
      clockAni = false;
    });
  }

  // Display message
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel the timer when the widget is disposed
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Focus Timer"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Timer Animation
              Center(
                child: SizedBox(
                  width: 200, // Desired width
                  height: 200, // Desired height
                  child: Lottie.asset(
                    "assets/animations/timer.json",
                    repeat: clockAni,
                  ),
                ),
              ),

              // Display Timer or Message
              Text(
                timeLeft == 0 && initialTime == 0
                    ? 'Select the required time' // Initial message
                    : timeLeft == 0
                    ? 'Hurray'
                    : isPaused
                    ? 'Paused'
                    : formatTime(timeLeft),
                style: const TextStyle(fontSize: 30),
              ),

              // Input Time
              TextField(
                controller: _timeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter time (minutes)',
                ),
                onSubmitted: (value) {
                  final parsedTime = int.tryParse(value);
                  if (parsedTime != null && parsedTime > 0) {
                    setState(() {
                      initialTime = parsedTime * 60;
                      timeLeft = initialTime;
                    });
                  } else {
                    _showMessage("Please enter a valid number!");
                  }
                },
              ),

              // Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: _startCountdown,
                    child: const Text('Start'),
                    color: Colors.purple,
                  ),
                  const SizedBox(width: 20),
                  MaterialButton(
                    onPressed: _pauseOrResume,
                    child: Text(isPaused ? 'Resume' : 'Pause'),
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 20),
                  MaterialButton(
                    onPressed: _restartTimer,
                    child: const Text('Restart'),
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

