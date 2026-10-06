import 'dart:async';
import 'package:flutter/material.dart';
import '/history_screen_service.dart';

class ManualWalkWorkoutScreen extends StatefulWidget {
  const ManualWalkWorkoutScreen({super.key});

  @override
  State<ManualWalkWorkoutScreen> createState() =>
      _ManualWalkWorkoutScreenState();
}

class _ManualWalkWorkoutScreenState extends State<ManualWalkWorkoutScreen> {
  final HistoryService historyService = HistoryService();

  int secondsElapsed = 0;
  Timer? timer;

  Future<void> saveWorkout() async {
    await historyService.addWorkout(
      name: "Manual Walk",
      type: "Cardio",
    );
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        secondsElapsed++;
      });
    });
  }

  String get formattedTime {
    final minutes = secondsElapsed ~/ 60;
    final seconds = secondsElapsed % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/workout/beginner_cardio/WALK.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(
                    formattedTime,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 128,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: ElevatedButton(
                      onPressed: () async {
                        await saveWorkout();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: const Text(
                        "STOP",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
}