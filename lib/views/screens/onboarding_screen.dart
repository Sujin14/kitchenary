import 'package:flutter/material.dart';
import 'package:kitchenary/views/widgets/onboarding/onboarding_view.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: OnboardingView()));
  }
}
