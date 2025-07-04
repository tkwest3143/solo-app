import 'package:flutter/material.dart';
import 'package:solo/screen/colors.dart';

class MenuNavigationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final List<Color>? gradientColors;
  final VoidCallback onTap;
  final bool isHighlighted;
  final double? iconSize;

  const MenuNavigationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.gradientColors,
    required this.onTap,
    this.isHighlighted = false,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final cardIconSize = iconSize ?? (isHighlighted ? 40.0 : 32.0);
    final cardIconColor = iconColor ?? Colors.white;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isHighlighted ? 20 : 15),
          color: backgroundColor ?? Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: isHighlighted 
                ? Theme.of(context).colorScheme.mediumShadowColor
                : Theme.of(context).colorScheme.lightShadowColor,
              blurRadius: isHighlighted ? 15 : 10,
              offset: Offset(0, isHighlighted ? 6 : 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(isHighlighted ? 20 : 16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: gradientColors != null
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradientColors!,
                      )
                    : null,
                color: gradientColors == null 
                    ? (backgroundColor ?? Theme.of(context).colorScheme.primary.withOpacity(0.1))
                    : null,
              ),
              child: Icon(
                icon,
                color: cardIconColor,
                size: cardIconSize,
              ),
            ),
            SizedBox(height: isHighlighted ? 16 : 12),
            Text(
              title,
              style: TextStyle(
                fontSize: isHighlighted ? 18 : 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primaryTextColor,
              ),
            ),
            SizedBox(height: isHighlighted ? 8 : 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: isHighlighted ? 14 : 12,
                color: Theme.of(context).colorScheme.secondaryTextColor,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}