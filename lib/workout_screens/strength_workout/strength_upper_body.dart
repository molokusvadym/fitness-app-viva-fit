import 'dart:async';
import 'package:flutter/material.dart';
import '/history_screen_service.dart';

class StrengthUpperBodyWorkoutScreen extends StatefulWidget {
  const StrengthUpperBodyWorkoutScreen({super.key});

  @override
  State<StrengthUpperBodyWorkoutScreen> createState() =>
      _StrengthUpperBodyWorkoutScreenState();
}

class _StrengthUpperBodyWorkoutScreenState
    extends State<StrengthUpperBodyWorkoutScreen> {

  final HistoryService historyService = HistoryService();

  final List<Exercise> exercises = [
    Exercise(
      name: "Push Ups",
      description: "Keep your body straight, drop to knees if needed.",
      reps: "x12",
      image: "assets/images/workout/strength_upper_body/PUSHUPS.png",
    ),
    Exercise(
      name: "Incline Push Ups",
      description: "Hands elevated on a bench or wall.",
      reps: "x12",
      image: "assets/images/workout/strength_upper_body/PUSHUPS.png",
    ),
    Exercise(
      name: "Tricep Dips",
      description: "Use a chair, keep elbows pointing back.",
      reps: "x12",
      image: "assets/images/workout/strength_upper_body/DIPS.png",
    ),
    Exercise(
      name: "Arm Circles",
      description: "Controlled circles, keep arms straight.",
      reps: "x30",
      image: "assets/images/workout/strength_upper_body/ARM_CIRCLES.png",
    ),
    Exercise(
      name: "Plank Shoulder Taps",
      description: "Keep hips stable, tap opposite shoulder.",
      reps: "x12",
      image: "assets/images/workout/strength_upper_body/PLANKTAP.png",
    ),
  ];

  int currentIndex = 0;
  int currentRound = 1;
  final int totalRounds = 2;
  int restSeconds = 30;
  bool isResting = false;
  Timer? timer;

  Future<void> saveWorkout() async {
    await historyService.addWorkout(
      name: "Strength Upper Body",
      type: "Strength",
    );
  }

  void startRest() {
    setState(() {
      isResting = true;
      restSeconds = 30;
    });

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => restSeconds--);
      if (restSeconds == 0) {
        t.cancel();
        setState(() => isResting = false);
      }
    });
  }

  void nextExercise() async {
    timer?.cancel();
    if (currentIndex < exercises.length - 1) {
      setState(() => currentIndex++);
      startRest();
    } else if (currentRound < totalRounds) {
      setState(() {
        currentRound++;
        currentIndex = 0;
      });
      startRest();
    } else {
      await saveWorkout();
      Navigator.pop(context);
    }
  }

  void previousExercise() {
    if (currentIndex > 0) {
      timer?.cancel();
      setState(() {
        currentIndex--;
        isResting = false;
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercise = exercises[currentIndex];

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            exercise.image,
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
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Round $currentRound / $totalRounds",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    exercise.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    exercise.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isResting ? "Rest: ${restSeconds}s" : exercise.reps,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: previousExercise,
                        icon: const Icon(Icons.skip_previous),
                        color: Colors.white,
                        iconSize: 36,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await saveWorkout();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          backgroundColor: Colors.white,
                        ),
                        child: const Icon(
                          Icons.stop,
                          color: Colors.black,
                          size: 32,
                        ),
                      ),
                      IconButton(
                        onPressed: nextExercise,
                        icon: const Icon(Icons.skip_next),
                        color: Colors.white,
                        iconSize: 36,
                      ),
                    ],
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

class Exercise {
  final String name;
  final String description;
  final String reps;
  final String image;

  Exercise({
    required this.name,
    required this.description,
    required this.reps,
    required this.image,
  });
}