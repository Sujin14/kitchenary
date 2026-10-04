import 'package:flutter/material.dart';

/// The content of one onboarding page.
class OnboardingPage {
  const OnboardingPage({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  static const List<OnboardingPage> pages = [
    OnboardingPage(
      icon: Icons.menu_book_rounded,
      title: 'Learn it',
      message: 'Browse hundreds of recipes, from everyday Indian dals to '
          'dishes from around the world.',
    ),
    OnboardingPage(
      icon: Icons.shopping_basket_outlined,
      title: 'Shop it',
      message: 'See exactly what you need, then order the ingredients from '
          'your favourite grocery app.',
    ),
    OnboardingPage(
      icon: Icons.local_fire_department_outlined,
      title: 'Cook it',
      message: 'Follow big, clear steps with the screen kept awake, and set '
          'timers so nothing burns.',
    ),
  ];
}
