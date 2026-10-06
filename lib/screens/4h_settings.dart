import 'dart:ui';
import 'package:flutter/material.dart';
import '/widgets/theme/tab_theme.dart';
import '/main.dart';
import '/settings_storage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double selectedScale = fontScaleNotifier.value;
  final List<double> scaleOptions = [0.6, 0.8, 1.0, 1.2, 1.4];

  void updateScale(double value) async {
    setState(() {
      selectedScale = value;
      fontScaleNotifier.value = value;
    });
    await SettingsStorage.saveFontScale(value);
  }

  Widget glassSection({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white.withOpacity(0.08),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "SETTINGS",
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                          color: Colors.white,
                          iconSize: 28,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    glassSection(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Appearance",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Theme",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 12),
                          ValueListenableBuilder<Color>(
                            valueListenable: CategoryTabTheme.accentColor,
                            builder: (context, selectedColor, _) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: CategoryTabTheme.presets.map((color) {
                                  final isSelected = selectedColor == color;
                                  return GestureDetector(
                                    onTap: () async {
                                      CategoryTabTheme.accentColor.value = color;
                                      await SettingsStorage.saveAccent(color);
                                    },
                                    child: Container(
                                      width: 34,
                                      height: 34,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                        border: isSelected
                                            ? Border.all(color: Colors.white, width: 2.5)
                                            : Border.all(color: Colors.transparent, width: 2.5),
                                        boxShadow: isSelected
                                            ? [BoxShadow(color: color.withOpacity(0.6), blurRadius: 8, spreadRadius: 1)]
                                            : [],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Font",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          ValueListenableBuilder<String>(
                            valueListenable: fontFamilyNotifier,
                            builder: (context, font, _) {
                              final displayFont = (font == 'OpenDyslexic') ? 'Inter' : font;
                              return DropdownButton<String>(
                                value: displayFont,
                                dropdownColor: const Color(0xFF1C1C1E),
                                style: const TextStyle(color: Colors.white),
                                underline: const SizedBox(),
                                iconEnabledColor: Colors.white,
                                items: const [
                                  DropdownMenuItem(value: 'Inter', child: Text('Inter')),
                                  DropdownMenuItem(value: 'Satoshi', child: Text('Satoshi')),
                                  DropdownMenuItem(value: 'Figtree', child: Text('Figtree')),
                                ],
                                onChanged: (value) async {
                                  if (value == null) return;
                                  fontFamilyNotifier.value = value;
                                  await SettingsStorage.saveFontFamily(value);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    glassSection(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Accessibility",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Font Size",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              inactiveTrackColor: Colors.white.withOpacity(0.3),
                              activeTrackColor: Colors.white,
                              thumbColor: Colors.white,
                              overlayColor: Colors.black.withOpacity(0.2),
                              valueIndicatorColor: Colors.white,
                            ),
                            child: Slider(
                              value: selectedScale,
                              min: scaleOptions.first,
                              max: scaleOptions.last,
                              divisions: scaleOptions.length - 1,
                              onChanged: (value) {
                                double snapped = scaleOptions.reduce(
                                  (a, b) => (a - value).abs() < (b - value).abs() ? a : b,
                                );
                                updateScale(snapped);
                              },
                            ),
                          ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Dyslexia Mode",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: Colors.white),
                              ),
                              ValueListenableBuilder<String>(
                                valueListenable: fontFamilyNotifier,
                                builder: (context, font, _) {
                                  final isEnabled = font == "OpenDyslexic";
                                  return Switch(
                                    value: isEnabled,
                                    activeThumbColor: Colors.green,
                                    onChanged: (value) async {
                                      final newFont = value ? "OpenDyslexic" : "Inter";
                                      setState(() {
                                        fontFamilyNotifier.value = newFont;
                                      });
                                      await SettingsStorage.saveFontFamily(newFont);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Colour Blind Mode",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: Colors.white),
                              ),
                              ValueListenableBuilder<String>(
                                valueListenable: colourBlindNotifier,
                                builder: (context, mode, _) {
                                  return DropdownButton<String>(
                                    value: mode,
                                    dropdownColor: const Color(0xFF1C1C1E),
                                    style: const TextStyle(color: Colors.white),
                                    underline: const SizedBox(),
                                    iconEnabledColor: Colors.white,
                                    items: const [
                                      DropdownMenuItem(value: 'off', child: Text('Off')),
                                      DropdownMenuItem(value: 'protanopia', child: Text('Protanopia')),
                                      DropdownMenuItem(value: 'deuteranopia', child: Text('Deuteranopia')),
                                      DropdownMenuItem(value: 'tritanopia', child: Text('Tritanopia')),
                                    ],
                                    onChanged: (value) async {
                                      if (value == null) return;
                                      colourBlindNotifier.value = value;
                                      await SettingsStorage.saveColourBlindMode(value);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}