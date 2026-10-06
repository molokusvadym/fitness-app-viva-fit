import 'package:flutter/material.dart';
import '/history_screen_service.dart';
import '/widgets/theme/tab_theme.dart';
import '/widgets/featured_tab.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  List<Map<String, dynamic>> _getAwards(List<Map<String, dynamic>> workouts) {
    final total = workouts.length;
    final hasRun = workouts.any((w) => w['type'] == 'Cardio');

    final dates = workouts
        .map((w) => DateTime.parse(w['date']))
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet()
        .toList()
      ..sort();

    int longestStreak = 0;
    int currentStreak = 1;
    for (int i = 1; i < dates.length; i++) {
      if (dates[i].difference(dates[i - 1]).inDays == 1) {
        currentStreak++;
        if (currentStreak > longestStreak) longestStreak = currentStreak;
      } else {
        currentStreak = 1;
      }
    }
    if (dates.length == 1) longestStreak = 1;

    return [
      {'title': 'First Step', 'desc': 'Complete your first workout', 'icon': Icons.fitness_center, 'earned': total >= 1},
      {'title': 'First Run', 'desc': 'Complete your first cardio workout', 'icon': Icons.directions_run, 'earned': hasRun},
      {'title': 'On A Roll', 'desc': 'Complete 10 workouts', 'icon': Icons.local_fire_department, 'earned': total >= 10},
      {'title': '7 Days In A Row', 'desc': '7 days in a row', 'icon': Icons.calendar_month, 'earned': longestStreak >= 7},
      {'title': 'Dedicated', 'desc': 'Complete 25 workouts', 'icon': Icons.military_tech, 'earned': total >= 25},
    ];
  }

  int _getBestStreak(List<Map<String, dynamic>> workouts) {
    final dates = workouts
        .map((w) => DateTime.parse(w['date']))
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet()
        .toList()
      ..sort();

    if (dates.isEmpty) return 0;
    if (dates.length == 1) return 1;

    int longestStreak = 1;
    int currentStreak = 1;
    for (int i = 1; i < dates.length; i++) {
      if (dates[i].difference(dates[i - 1]).inDays == 1) {
        currentStreak++;
        if (currentStreak > longestStreak) longestStreak = currentStreak;
      } else {
        currentStreak = 1;
      }
    }
    return longestStreak;
  }

  @override
  Widget build(BuildContext context) {
    const int weeklyGoal = 5;
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/HOME_BACKGROUND.png",
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.9),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Progress",
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: HistoryService().watchHistory(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(color: Colors.white));
                        }
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text("Error loading progress", style: TextStyle(color: Colors.white)),
                          );
                        }
                        final workouts = snapshot.data ?? [];
                        final now = DateTime.now();
                        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
                        final weeklyWorkouts = workouts
                            .where((w) => DateTime.parse(w["date"]).isAfter(startOfWeek))
                            .length;
                        final dayCounts = List.generate(7, (index) {
                          final day = startOfWeek.add(Duration(days: index));
                          return workouts.where((w) => DateTime.parse(w["date"]).day == day.day).length;
                        });
                        final progress = (weeklyWorkouts / weeklyGoal).clamp(0.0, 1.0);
                        final awards = _getAwards(workouts);
                        final bestStreak = _getBestStreak(workouts);
                        final total = workouts.length;
                        final accentColor = CategoryTabTheme.accentColor.value;

                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              GlassContainer(
                                width: double.infinity,
                                height: 140,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              backgroundColor: const Color(0xFF1C1C1E),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Text("Weekly Goal", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                                  const SizedBox(height: 20),
                                                  Text("$weeklyWorkouts / $weeklyGoal", style: TextStyle(color: accentColor, fontSize: 48, fontWeight: FontWeight.bold)),
                                                  const SizedBox(height: 8),
                                                  const Text("Workouts Completed This Week", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 14)),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        child: SizedBox(
                                          width: 80,
                                          height: 80,
                                          child: CircularProgressIndicator(
                                            value: progress,
                                            strokeWidth: 7,
                                            backgroundColor: Colors.grey,
                                            valueColor: AlwaysStoppedAnimation(accentColor),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _statRow("Total Workouts", "$total"),
                                            const SizedBox(height: 10),
                                            _statRow("This Week", "$weeklyWorkouts"),
                                            const SizedBox(height: 10),
                                            _statRow("Best Streak", "${bestStreak}d"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              GlassContainer(
                                width: double.infinity,
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Weekly Stats", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                                      const SizedBox(height: 12),
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: List.generate(7, (index) {
                                            final count = dayCounts[index];
                                            final value = (count / weeklyGoal).clamp(0.0, 1.0);
                                            return Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Flexible(
                                                    child: GlassContainer(
                                                      width: 20,
                                                      height: 100,
                                                      child: FractionallySizedBox(
                                                        alignment: Alignment.bottomCenter,
                                                        heightFactor: value,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: accentColor,
                                                            borderRadius: BorderRadius.circular(6),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(weekDays[index], style: const TextStyle(color: Colors.white, fontSize: 11)),
                                                  const SizedBox(height: 2),
                                                  Text("$count", style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                                ],
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              GlassContainer(
                                width: double.infinity,
                                height: 180,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Awards", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: awards.map((award) {
                                          final earned = award['earned'] as bool;
                                          return GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  backgroundColor: const Color(0xFF1C1C1E),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                  content: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        width: 70,
                                                        height: 70,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: Border.all(color: earned ? Colors.white : Colors.grey, width: 1.5),
                                                        ),
                                                        child: Icon(award['icon'] as IconData, size: 36, color: earned ? Colors.white : Colors.grey),
                                                      ),
                                                      const SizedBox(height: 12),
                                                      Text(award['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                                      const SizedBox(height: 6),
                                                      Text(award['desc'] as String, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 14)),
                                                      const SizedBox(height: 10),
                                                      Text(earned ? "Earned ✓" : "Not yet earned", style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 56,
                                                  height: 56,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: earned ? Colors.white : Colors.grey, width: 1.5),
                                                  ),
                                                  child: Icon(award['icon'] as IconData, size: 26, color: earned ? Colors.white : Colors.grey),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  award['title'] as String,
                                                  style: TextStyle(fontSize: 10, color: earned ? Colors.white : Colors.grey, fontWeight: FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        );
                      },
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

  Widget _statRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}