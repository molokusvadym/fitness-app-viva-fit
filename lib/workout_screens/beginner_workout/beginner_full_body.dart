import 'dart:async';
import 'package:flutter/material.dart';
import '/history_screen_service.dart';

class BeginnerFullBodyWorkoutScreen extends StatefulWidget {
  const BeginnerFullBodyWorkoutScreen({super.key});

  @override
  State<BeginnerFullBodyWorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<BeginnerFullBodyWorkoutScreen> {
  final HistoryService historyService = HistoryService();

  final List<Exercise> exercises = [
    Exercise(
      name: "Push Ups",
      description: "Keep your core tight, switch to knees if difficult.",
      reps: "x10",
      image: "assets/images/workout/beginner_full_body/PUSHUPS.png",
    ),
    Exercise(
      name: "Squats",
      description: "Chest up and heels on the floor.",
      reps: "x10",
      image: "assets/images/workout/beginner_full_body/SQUATS.png",
    ),
    Exercise(
      name: "Mountain Climbers",
      description: "Drive knees towards chest.",
      reps: "x10",
      image: "assets/images/workout/beginner_full_body/MOUNTAIN_CLIMBERS.png",
    ),
    Exercise(
      name: "Lunges",
      description: "Step forward and lower the back knee.",
      reps: "x10",
      image: "assets/images/workout/beginner_full_body/LUNGES.png",
    ),
    Exercise(
      name: "Speed Skaters",
      description: "Jump side to side lightly.",
      reps: "x10",
      image: "assets/images/workout/BEGINNER_FULL_BODY/SPEED_SKATERS.png",
    ),
  ];

  int currentIndex = 0;
  int restSeconds = 20;
  bool isResting = false;
  Timer? timer;

  Future<void> saveWorkout() async {
    await historyService.addWorkout(
      name: "Beginner Full Body",
      type: "Strength",
    );
  }

  void startRest() {
    setState(() {
      isResting = true;
      restSeconds = 20;
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