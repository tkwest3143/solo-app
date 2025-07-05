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
        padding: isHighlighted 
            ? const EdgeInsets.all(20)
            : const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isHighlighted ? 20 : 16),
          color: backgroundColor ?? Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: isHighlighted 
                ? Theme.of(context).colorScheme.mediumShadowColor
                : Theme.of(context).colorScheme.lightShadowColor,
              blurRadius: isHighlighted ? 15 : 8,
              offset: Offset(0, isHighlighted ? 6 : 2),
            ),
          ],
        ),
        child: isHighlighted
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
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
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondaryTextColor,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    ),
                    child: Icon(
                      icon,
                      color: cardIconColor,
                      size: cardIconSize,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.secondaryTextColor,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                  ),
                ],
              ),
      ),
    );
  }
}