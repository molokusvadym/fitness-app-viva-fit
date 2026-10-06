import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme/fitness_app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/1h_home_screen.dart';
import 'screens/4h_settings.dart';
import 'screens/3h_history_screen.dart';
import 'workout_screens/beginner_workout/beginner_full_body.dart';
import 'workout_screens/beginner_workout/beginner_running_cardio.dart';
import 'workout_screens/strength_workout/strength_upper_body.dart';
import 'workout_screens/strength_workout/strength_lower_body.dart';
import 'workout_screens/cardio_manual_run/manual_run_screen.dart';
import 'workout_screens/cardio_manual_run/manual_walk_screen.dart';
import 'screens/intro.dart';
import 'widgets/theme/tab_theme.dart';
import 'settings_storage.dart';

final ValueNotifier<double> fontScaleNotifier = ValueNotifier(1.0);
final ValueNotifier<String> fontFamilyNotifier = ValueNotifier('Inter');
final ValueNotifier<String> colourBlindNotifier = ValueNotifier('off');

const Map<String, List<double>> colourBlindMatrices = {
  'off': [
    1, 0, 0, 0, 0,
    0, 1, 0, 0, 0,
    0, 0, 1, 0, 0,
    0, 0, 0, 1, 0,
  ],
  'protanopia': [
    0.567, 0.433, 0, 0, 0,
    0.558, 0.442, 0, 0, 0,
    0, 0.242, 0.758, 0, 0,
    0, 0, 0, 1, 0,
  ],
  'deuteranopia': [
    0.625, 0.375, 0, 0, 0,
    0.7, 0.3, 0, 0, 0,
    0, 0.3, 0.7, 0, 0,
    0, 0, 0, 1, 0,
  ],
  'tritanopia': [
    0.95, 0.05, 0, 0, 0,
    0, 0.433, 0.567, 0, 0,
    0, 0.475, 0.525, 0, 0,
    0, 0, 0, 1, 0,
  ],
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final savedScale = await SettingsStorage.loadFontScale();
  final savedFont = await SettingsStorage.loadFontFamily();
  final savedAccent = await SettingsStorage.loadAccent();
  final savedColourBlind = await SettingsStorage.loadColourBlindMode();

  if (savedScale != null) fontScaleNotifier.value = savedScale;
  if (savedFont != null) fontFamilyNotifier.value = savedFont;
  if (savedAccent != null) CategoryTabTheme.accentColor.value = savedAccent;
  if (savedColourBlind != null) colourBlindNotifier.value = savedColourBlind;

  runApp(const FitnessApp());
}

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: fontScaleNotifier,
      builder: (context, double scale, _) {
        return ValueListenableBuilder(
          valueListenable: fontFamilyNotifier,
          builder: (context, String fontFamily, __) {
            return ValueListenableBuilder(
              valueListenable: colourBlindNotifier,
              builder: (context, String colourBlindMode, ___) {
                return ColorFiltered(
                  colorFilter: ColorFilter.matrix(
                    colourBlindMatrices[colourBlindMode]!,
                  ),
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: FitnessAppTheme.lightTheme(scale, fontFamily),
                    initialRoute: '/intro',
                    routes: {
                      '/intro': (context) => const IntroScreen(),
                      '/login': (context) => const LoginScreen(),
                      '/register': (context) => const RegisterScreen(),
                      '/home': (context) => const HomeScreen(),
                      '/settings': (context) => const SettingsScreen(),
                      '/history': (context) => const HistoryScreen(),
                      '/workout_beginner_full_body': (context) => const BeginnerFullBodyWorkoutScreen(),
                      '/workout_beginner_cardio': (context) => const BeginnerCardioWorkoutScreen(),
                      '/workout_strength_upper_body': (context) => const StrengthUpperBodyWorkoutScreen(),
                      '/workout_strength_lower_body': (context) => const StrengthLowerBodyWorkoutScreen(),
                      '/workout_manual_run_screen': (context) => const ManualRunWorkoutScreen(),
                      '/workout_manual_walk_screen': (context) => const ManualWalkWorkoutScreen(),
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}