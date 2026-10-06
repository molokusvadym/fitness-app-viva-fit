import 'dart:async';
import 'package:flutter/material.dart';
import '/history_screen_service.dart';

class BeginnerCardioWorkoutScreen extends StatefulWidget {
  const BeginnerCardioWorkoutScreen({super.key});

  @override
  State<BeginnerCardioWorkoutScreen> createState() =>
      _BeginnerCardioWorkoutScreenState();
}

class _BeginnerCardioWorkoutScreenState
    extends State<BeginnerCardioWorkoutScreen> {

  final HistoryService historyService = HistoryService();

  final List<Exercise> exercises = [
    Exercise(
      name: "Warm Up",
      description: "(Optional) - Brisk Walk Before Run",
      duration: 300,
      image: "assets/images/workout/beginner_cardio/WALK.png",
    ),
    Exercise(
      name: "Interval Run Cycle 1",
      description: "Run / Jog For 30 seconds",
      duration: 30,
      image: "assets/images/workout/beginner_cardio/RUN.png",
    ),
    Exercise(
      name: "Break",
      description: "Switch Back To Walking",
      duration: 90,
      image: "assets/images/workout/beginner_cardio/WALK.png",
    ),
    Exercise(
      name: "Interval Run Cycle 2",
      description: "Run / Jog For 30 seconds",
      duration: 30,
      image: "assets/images/workout/beginner_cardio/RUN.png",
    ),
    Exercise(
      name: "Break",
      description: "Switch Back To Walking",
      duration: 90,
      image: "assets/images/workout/beginner_cardio/WALK.png",
    ),
    Exercise(
      name: "Interval Run Cycle 3",
      description: "Run / Jog For 30 seconds",
      duration: 30,
      image: "assets/images/workout/beginner_cardio/RUN.png",
    ),
    Exercise(
      name: "Break",
      description: "Switch Back To Walking",
      duration: 90,
      image: "assets/images/workout/beginner_cardio/WALK.png",
    ),
    Exercise(
      name: "Interval Run Cycle 4",
      description: "Run / Jog For 30 seconds",
      duration: 30,
      image: "assets/images/workout/beginner_cardio/RUN.png",
    ),
    Exercise(
      name: "Break",
      description: "Switch Back To Walking",
      duration: 90,
      image: "assets/images/workout/beginner_cardio/WALK.png",
    ),
    Exercise(
      name: "Interval Run Cycle 5",
      description: "Run / Jog For 30 seconds",
      duration: 30,
      image: "assets/images/workout/beginner_cardio/RUN.png",
    ),
    Exercise(
      name: "Break",
      description: "Switch Back To Walking",
      duration: 90,
      image: "assets/images/workout/beginner_cardio/WALK.png",
    ),
    Exercise(
      name: "Interval Run Cycle 6",
      description: "Run / Jog For 30 seconds",
      duration: 30,
      image: "assets/images/workout/beginner_cardio/RUN.png",
    ),
    Exercise(
      name: "Break",
      description: "Switch Back To Walking",
      duration: 90,
      image: "assets/images/workout/beginner_cardio/WALK.png",
    ),
    Exercise(
      name: "Cool-Down",
      description: "Workout Finished, Cooldown (Optional)",
      duration: 60,
      image: "assets/images/workout/beginner_cardio/RUN_FINISHED.png",
    ),
  ];

  int currentIndex = 0;
  int remainingSeconds = 0;
  Timer? timer;

  Future<void> saveWorkout() async {
    await historyService.addWorkout(
      name: "Beginner Cardio Run",
      type: "Cardio",
    );
  }

  @override
  void initState() {
    super.initState();
    startExercise();
  }

  void startExercise() {
    timer?.cancel();

    setState(() {
      remainingSeconds = exercises[currentIndex].duration;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        t.cancel();
        nextExercise();
      }
    });
  }

  void nextExercise() async {
    timer?.cancel();

    if (currentIndex < exercises.length - 1) {
      setState(() {
        currentIndex++;
      });
      startExercise();
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
      });
      startExercise();
    }
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
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
            width: double.infinity,
            height: double.infinity,
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
                    formatTime(remainingSeconds),
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
  final int duration;
  final String image;

  Exercise({
    required this.name,
    required this.description,
    required this.duration,
    required this.image,
  });
}