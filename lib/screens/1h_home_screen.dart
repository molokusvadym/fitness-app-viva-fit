import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/widgets/category_tab.dart';
import '/widgets/featured_tab.dart';
import '/widgets/all_tab.dart';
import '/widgets/theme/tab_theme.dart';
import '/workout_screens/beginner_workout/beginner_full_body.dart';
import '/workout_screens/beginner_workout/beginner_running_cardio.dart';
import '/workout_screens/strength_workout/strength_upper_body.dart';
import '/workout_screens/strength_workout/strength_lower_body.dart';
import '/workout_screens/cardio_manual_run/manual_run_screen.dart';
import '/workout_screens/cardio_manual_run/manual_walk_screen.dart';
import '/screens/4h_settings.dart';
import '/screens/3h_history_screen.dart';
import '/screens/login_screen.dart';
import '/screens/2h_progress_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  int bottomIndex = 0;
  final categories = ["Getting Started", "Strength", "Running"];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ),
    );
  }

  Widget sectionDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 25),
      child: Divider(color: Colors.white, thickness: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Image.asset(
            "assets/images/HOME_BACKGROUND.png",
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            "Choose your\nWorkout Program",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 36,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: CategoryChip(
                              text: categories[index],
                              active: selectedIndex == index,
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    _topSection(),
                    sectionDivider(),
                    Text(
                      "All Workouts",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        AllWorkoutCard(
                          title: "BEGINNER FULL BODY",
                          time: "10 min",
                          imagePath: "assets/images/ALL_WORKOUT_ICON.png",
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const BeginnerFullBodyWorkoutScreen(),
                            ));
                          },
                        ),
                        AllWorkoutCard(
                          title: "INTERVAL CARDIO",
                          time: "22 min",
                          imagePath: "assets/images/ALL_WORKOUT_ICON.png",
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const BeginnerCardioWorkoutScreen(),
                            ));
                          },
                        ),
                        AllWorkoutCard(
                          title: "STRENGTH UPPER BODY",
                          time: "10 min",
                          imagePath: "assets/images/ALL_WORKOUT_ICON.png",
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const StrengthUpperBodyWorkoutScreen(),
                            ));
                          },
                        ),
                        AllWorkoutCard(
                          title: "STRENGTH LOWER BODY",
                          time: "10 min",
                          imagePath: "assets/images/ALL_WORKOUT_ICON.png",
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const StrengthLowerBodyWorkoutScreen(),
                            ));
                          },
                        ),
                        AllWorkoutCard(
                          title: "RUN",
                          time: "Any",
                          imagePath: "assets/images/workout/beginner_cardio/RUN.png",
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const ManualRunWorkoutScreen(),
                            ));
                          },
                        ),
                        AllWorkoutCard(
                          title: "WALK",
                          time: "Any",
                          imagePath: "assets/images/workout/beginner_cardio/WALK.png",
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const ManualWalkWorkoutScreen(),
                            ));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: GlassContainer(
              width: MediaQuery.of(context).size.width,
              height: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(Icons.home_rounded, "Dashboard", 0),
                  _navItem(Icons.show_chart_rounded, "Progress", 1),
                  _navItem(Icons.history_rounded, "History", 2),
                  _navItem(Icons.settings_rounded, "Settings", 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    return ValueListenableBuilder<Color>(
      valueListenable: CategoryTabTheme.accentColor,
      builder: (context, accentColor, _) {
        final bool isActive = bottomIndex == index;
        return GestureDetector(
          onTap: () {
            setState(() { bottomIndex = index; });
            if (index == 1) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProgressScreen()));
            } else if (index == 2) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen()));
            } else if (index == 3) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isActive ? accentColor : Colors.white),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(fontSize: 12, color: isActive ? accentColor : Colors.white)),
            ],
          ),
        );
      },
    );
  }

  Widget _topSection() {
    return SizedBox(
      height: 170,
      child: IndexedStack(
        index: selectedIndex,
        children: [_beginnerFeatured(), _strengthFeatured(), _runningFeatured()],
      ),
    );
  }

  Widget _beginnerFeatured() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        FeaturedWorkoutCard(title: "FULL BODY", time: "10 min", onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const BeginnerFullBodyWorkoutScreen()));
        }),
        FeaturedWorkoutCard(title: "INTERVAL CARDIO", time: "22 min", onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const BeginnerCardioWorkoutScreen()));
        }),
      ],
    );
  }

  Widget _strengthFeatured() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        FeaturedWorkoutCard(title: "STRENGTH UPPER BODY", time: "10 min", onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const StrengthUpperBodyWorkoutScreen()));
        }),
        FeaturedWorkoutCard(title: "STRENGTH LOWER BODY", time: "10 min", onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const StrengthLowerBodyWorkoutScreen()));
        }),
      ],
    );
  }

  Widget _runningFeatured() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        FeaturedWorkoutCard(title: "RUN", time: "Any", onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ManualRunWorkoutScreen()));
        }),
        FeaturedWorkoutCard(title: "WALK", time: "Any", onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ManualWalkWorkoutScreen()));
        }),
      ],
    );
  }
}