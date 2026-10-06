import 'package:flutter/material.dart';
import '/widgets/theme/tab_theme.dart';

class CategoryChip extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.text,
    this.active = false,
    this.onTap,
  });

  Color _textColor(Color background) {
    final brightness = ThemeData.estimateBrightnessForColor(background);
    return brightness == Brightness.dark ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: CategoryTabTheme.accentColor,
      builder: (context, accentColor, _) {
        final textColor = _textColor(accentColor);

        return GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: active ? accentColor : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: active ? textColor : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }
}
